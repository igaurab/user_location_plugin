import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import "dart:math" show pi;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:user_location/src/user_location_marker.dart';
import 'package:user_location/src/user_location_options.dart';

class MapsPluginLayer extends StatefulWidget {
  final UserLocationOptions options;
  final MapState map;
  final Stream<Null> stream;

  MapsPluginLayer(this.options, this.map, this.stream);

  @override
  _MapsPluginLayerState createState() => _MapsPluginLayerState();
}

class _MapsPluginLayerState extends State<MapsPluginLayer>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  LatLng _currentLocation;
  UserLocationMarker _locationMarker;
  EventChannel _stream = EventChannel('locationStatusStream');
  var location = Location();

  bool mapLoaded;
  bool initialStateOfupdateMapLocationOnPositionChange;

  double _direction;

  StreamSubscription<LocationData> _onLocationChangedStreamSubscription;
  StreamSubscription<CompassEvent> _compassStreamSubscription;
  StreamSubscription _locationStatusChangeSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    initialStateOfupdateMapLocationOnPositionChange =
        widget.options.updateMapLocationOnPositionChange;

    setState(() {
      mapLoaded = false;
    });
    initialize();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _locationStatusChangeSubscription?.cancel();
    _onLocationChangedStreamSubscription?.cancel();
    _compassStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (widget.options.locationUpdateInBackground == false) {
      switch (state) {
        case AppLifecycleState.inactive:
        case AppLifecycleState.paused:
          if (Platform.isAndroid) {
            _locationStatusChangeSubscription?.cancel();
          }
          _onLocationChangedStreamSubscription?.cancel();
          break;
        case AppLifecycleState.resumed:
          if (Platform.isAndroid) {
            _handleLocationStatusChanges();
            _subscribeToLocationChanges();
          } else {
            _onLocationChangedStreamSubscription?.resume();
          }
          break;
        case AppLifecycleState.detached:
          break;
      }
    }
  }

  void initialize() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _handleLocationStatusChanges();
    _subscribeToLocationChanges();
    _handleCompassDirection();
  }

  void printLog(String log) {
    if (widget.options.verbose) {
      print(log);
    }
  }

  Future<void> _subscribeToLocationChanges() async {
    printLog("OnSubscribe to location change");
    var location = Location();
    if (await location.requestService() &&
        await location.changeSettings(
            interval: widget.options.locationUpdateIntervalMs)) {
      _onLocationChangedStreamSubscription =
          location.onLocationChanged.listen((onValue) {
        _addsMarkerLocationToMarkerLocationStream(onValue);
        setState(() {
          if (onValue.latitude == null || onValue.longitude == null) {
            _currentLocation = LatLng(0, 0);
          } else {
            _currentLocation = LatLng(onValue.latitude, onValue.longitude);
          }

          var height = 20.0 * (1 - (onValue.accuracy / 100));
          var width = 20.0 * (1 - (onValue.accuracy / 100));
          if (height < 0 || width < 0) {
            height = 20;
            width = 20;
          }

          if (_locationMarker != null) {
            widget.options.markers.remove(_locationMarker);
          }

          printLog("Direction : " + (_direction ?? 0).toString());

          _locationMarker = UserLocationMarker(
            height: 20.0,
            width: 20.0,
            point:
                LatLng(_currentLocation.latitude, _currentLocation.longitude),
            builder: (context) {
              return Stack(
                alignment: AlignmentDirectional.center,
                children: <Widget>[
                  if (_direction != null && widget.options.showHeading)
                    ClipOval(
                      child: Transform.rotate(
                        angle: _direction / 180 * math.pi,
                        child: CustomPaint(
                          size: Size(60.0, 60.0),
                          painter: MyDirectionPainter(),
                        ),
                      ),
                    ),
                  widget.options.markerWidget ??
                      Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue[300].withOpacity(0.7),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                ],
              );
            },
          );

          widget.options.markers.add(_locationMarker);

          if (widget.options.updateMapLocationOnPositionChange &&
              widget.options.mapController != null) {
            _moveMapToCurrentLocation();
          } else if (widget.options.updateMapLocationOnPositionChange) {
            if (!widget.options.updateMapLocationOnPositionChange) {
              widget.map.fitBounds(widget.map.bounds, FitBoundsOptions());
            }
            printLog(
                "Warning: updateMapLocationOnPositionChange set to true, but no mapController provided: can't move map");
          } else {
            forceMapUpdate();
          }

          if (widget.options.zoomToCurrentLocationOnLoad && (!mapLoaded)) {
            setState(() {
              mapLoaded = true;
            });
            animatedMapMove(_currentLocation, widget.options.defaultZoom,
                widget.options.mapController, this);
          }
        });
      });
    }
  }

  void _moveMapToCurrentLocation({double zoom}) {
    if (_currentLocation != null) {
      animatedMapMove(
        LatLng(_currentLocation.latitude ?? LatLng(0, 0),
            _currentLocation.longitude ?? LatLng(0, 0)),
        zoom ?? widget.map.zoom ?? 15,
        widget.options.mapController,
        this,
      );
    }
  }

  void _handleLocationStatusChanges() {
    printLog(_stream.toString());
    bool _locationStatusChanged;
    if (_locationStatusChanged == null) {
      _locationStatusChangeSubscription =
          _stream.receiveBroadcastStream().listen((onData) {
        _locationStatusChanged = onData;
        printLog("LOCATION ACCESS CHANGED: CURRENT-> ${onData ? 'On' : 'Off'}");
        if (onData == false) {
          var location = Location();
          location.requestService();
        }
        if (onData == true) {
          _subscribeToLocationChanges();
        }
      });
    }
  }

  void _handleCompassDirection() {
    if (widget.options.showHeading) {
      _compassStreamSubscription = FlutterCompass.events.listen((event) {
        setState(() {
          _direction = event.heading;
        });
        forceMapUpdate();
      });
    }
  }

  _addsMarkerLocationToMarkerLocationStream(LocationData onValue) {
    if (widget.options.onLocationUpdate == null) {
      printLog("Stream not provided");
    } else {
      widget.options.onLocationUpdate(
        LatLng(onValue.latitude, onValue.longitude),
        onValue.speed,
      );
    }
  }

  Widget build(BuildContext context) {
    if (_locationMarker != null &&
        !widget.options.markers.contains(_locationMarker)) {
      widget.options.markers.add(_locationMarker);
    }

    return widget.options.showMoveToCurrentLocationFloatingActionButton
        ? Positioned(
            bottom: widget.options.fabBottom,
            right: widget.options.fabRight,
            height: widget.options.fabHeight,
            width: widget.options.fabWidth,
            child: InkWell(
              hoverColor: Colors.blueAccent[200],
              onTap: () {
                if (initialStateOfupdateMapLocationOnPositionChange) {
                  setState(() {
                    widget.options.updateMapLocationOnPositionChange = false;
                  });
                }

                ///TODO: initialize listens to various streams without cancelling them first. (this causes undisposed streams to keep listening)
                //steps to reproduce: 1. open map, 2. click on FAB, 3. exit map.
                initialize();
                _moveMapToCurrentLocation(zoom: widget.options.defaultZoom);
                if (widget.options.onTapFAB != null) {
                  widget.options.onTapFAB();
                }
              },
              child: widget.options.moveToCurrentLocationFloatingActionButton ??
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(color: Colors.grey, blurRadius: 10.0),
                      ],
                    ),
                    child: Icon(
                      Icons.my_location,
                      color: Colors.white,
                    ),
                  ),
            ),
          )
        : Container();
  }

  void animatedMapMove(
      LatLng destLocation, double destZoom, _mapController, vsync) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final _latTween = Tween<double>(
        begin: _mapController.center.latitude, end: destLocation.latitude);
    final _lngTween = Tween<double>(
        begin: _mapController.center.longitude, end: destLocation.longitude);
    final _zoomTween = Tween<double>(begin: _mapController.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    var controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: vsync);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      _mapController.move(
          LatLng(_latTween.evaluate(animation), _lngTween.evaluate(animation)),
          _zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (initialStateOfupdateMapLocationOnPositionChange) {
          setState(() {
            widget.options.updateMapLocationOnPositionChange = true;
          });
        }

        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        if (initialStateOfupdateMapLocationOnPositionChange) {
          setState(() {
            widget.options.updateMapLocationOnPositionChange = true;
          });
        }
        controller.dispose();
      }
    });
    controller.forward();
  }

  void forceMapUpdate() {
    var zoom = widget.options.mapController.zoom;
    widget.options.mapController.move(widget.options.mapController.center,
        widget.options.mapController.zoom + 0.000001);
    widget.options.mapController
        .move(widget.options.mapController.center, zoom);
  }
}

class MyDirectionPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // create a bounding square, based on the centre and radius of the arc
    Rect rect = new Rect.fromCircle(
      center: new Offset(30.0, 30.0),
      radius: 40.0,
    );

    // a fancy rainbow gradient
    final Gradient gradient = new RadialGradient(
      colors: <Color>[
        Colors.blue.shade500.withOpacity(0.6),
        Colors.blue.shade500.withOpacity(0.3),
        Colors.blue.shade500.withOpacity(0.1),
      ],
      stops: [
        0.0,
        0.5,
        1.0,
      ],
    );

    // create the Shader from the gradient and the bounding square
    final Paint paint = new Paint()..shader = gradient.createShader(rect);

    // and draw an arc
    canvas.drawArc(rect, pi * 6 / 5, pi * 3 / 5, true, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
