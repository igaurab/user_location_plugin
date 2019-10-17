import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:user_location/src/user_location_options.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';

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

  @override
  void initState() {
    super.initState();
    _subscribeToLocationChanges();
  }

  void _subscribeToLocationChanges() {
    var location = Location();
    location.onLocationChanged().listen((onValue) {
      setState(() {
        if (onValue.latitude == null || onValue.longitude == null) {
          _currentLocation = LatLng(0, 0);
        } else {
          _currentLocation = LatLng(onValue.latitude, onValue.longitude);
          print(_currentLocation);
        }
        widget.options.markers.clear();
        widget.options.markers.add(Marker(
            height: 10.0,
            width: 10.0,
            point:
                LatLng(_currentLocation.latitude, _currentLocation.longitude),
            builder: (context) {
              return Container(
                height: 10.0,
                width: 10.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.redAccent),
              );
            }));

        widget.options.mapController.move(
            LatLng(_currentLocation.latitude, _currentLocation.longitude),
            widget.map.zoom ?? 15);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
