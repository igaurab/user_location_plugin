import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:user_location/src/user_location_options.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'dart:async';

class MapsPluginLayer extends StatefulWidget {
  final UserLocationOptions options;
  final MapState map;
  final Stream<Null> stream;

  MapsPluginLayer(this.options, this.map, this.stream);

  @override
  _MapsPluginLayerState createState() => _MapsPluginLayerState();
}

class _MapsPluginLayerState extends State<MapsPluginLayer> {
  LatLng _currentLocation;
  Marker _locationMarker;
  EventChannel _stream = EventChannel('locationStatusStream');
  var location = Location();

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() {
    location.hasPermission().then((onValue) async {
      if (onValue == false) {
        await location.requestPermission();
        printLog("Request Permission Granted");
        location.serviceEnabled().then((onValue) async {
          if (onValue == false) {
            await location.requestService();
            _handleLocationChanges();
            _subscribeToLocationChanges();
          } else {
            _handleLocationChanges();
            _subscribeToLocationChanges();
          }
        });
      } else {
        location.serviceEnabled().then((onValue) async {
          if (onValue == false) {
            await location.requestService();
            _handleLocationChanges();
            _subscribeToLocationChanges();
          } else {
            _handleLocationChanges();
            _subscribeToLocationChanges();
          }
        });
      }
    });
  }

  void printLog(String log) {
    if (widget.options.verbose) {
      print(log);
    }
  }

  void _subscribeToLocationChanges() {
    printLog("OnSubscribe to location change");
    location.onLocationChanged().listen((onValue) {
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
        //widget.options.markers.clear();

        _locationMarker = Marker(
            point:
                LatLng(_currentLocation.latitude, _currentLocation.longitude),
            builder: (context) {
              return Stack(
                alignment: AlignmentDirectional.center,
                children: <Widget>[
                  Container(
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue[300].withOpacity(0.7)),
                  ),
                  widget.options.markerWidget ??
                      Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.blueAccent),
                      )
                ],
              );
            });

        widget.options.markers.add(_locationMarker);

        if (widget.options.updateMapLocationOnPositionChange &&
            widget.options.mapController != null) {
          _moveMapToCurrentLocation();
        } else if (widget.options.updateMapLocationOnPositionChange) {
          printLog(
              "Warning: updateMapLocationOnPositionChange set to true, but no mapController provided: can't move map");
        }
      });
    });
  }

  void _moveMapToCurrentLocation() {
    widget.options.mapController.move(
        LatLng(_currentLocation.latitude ?? LatLng(0, 0),
            _currentLocation.longitude ?? LatLng(0, 0)),
        widget.map.zoom ?? 15);
  }

  void _handleLocationChanges() {
    printLog(_stream.toString());
    bool _locationStatusChanged;
    if (_locationStatusChanged == null) {
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

  _addsMarkerLocationToMarkerLocationStream(LocationData onValue) {
    if (widget.options.onLocationUpdate == null) {
      printLog("Strem not provided");
    } else {
      widget.options
          .onLocationUpdate(LatLng(onValue.latitude, onValue.longitude));
    }
  }

  Widget build(BuildContext context) {
    return widget.options.showMoveToCurrentLocationFloatingActionButton
        ? Positioned(
            bottom: 20.0,
            right: 20.0,
            height: 40.0,
            width: 40.0,
            child: InkWell(
                hoverColor: Colors.blueAccent[200],
                onTap: () {
                  _moveMapToCurrentLocation();
                },
                child: widget.options
                            .moveToCurrentLocationFloatingActionButton ==
                        null
                    ? Container(
                        decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(color: Colors.grey, blurRadius: 10.0)
                            ]),
                        child: Icon(
                          Icons.my_location,
                          color: Colors.white,
                        ),
                      )
                    : widget.options.moveToCurrentLocationFloatingActionButton),
          )
        : Container();
  }
}
