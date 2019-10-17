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
  MapController controller = MapController();
  LatLng _currentLocation;
  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
    _subscribeToLocationChanges();
  }

  void _subscribeToLocationChanges() {
    var location = Location();
    location.onLocationChanged().listen((onValue) {
      if (onValue.latitude is double) {
        setState(() {
          if (onValue == null) {
            _currentLocation = LatLng(0, 0);
          } else {
            _currentLocation = LatLng(onValue.latitude, onValue.longitude);
            print(_currentLocation);
          }
          markers.clear();
          markers.add(Marker(
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

          controller.move(
              LatLng(_currentLocation.latitude, _currentLocation.longitude),
              controller.zoom);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(center: LatLng(27.7172, 85.3240), zoom: 15.0),
      layers: [
        TileLayerOptions(
          urlTemplate: "https://api.tiles.mapbox.com/v4/"
              "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
          additionalOptions: {
            'accessToken':
                'pk.eyJ1IjoiaWdhdXJhYiIsImEiOiJjazFhOWlkN2QwYzA5M2RyNWFvenYzOTV0In0.lzjuSBZC6LcOy_oRENLKCg',
            'id': 'mapbox.streets',
          },
        ),
        MarkerLayerOptions(markers: markers),
      ],
      mapController: controller,
    );
  }
}
