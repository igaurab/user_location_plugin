import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:location/location.dart';
import '../widgets/plugin_layer_options.dart';
import '../widgets/my_custom_plugin.dart';
import 'package:latlong/latlong.dart';
import '../widgets/getLocation.dart';

class MapsPluginLayer extends StatefulWidget {
  final MyCustomPluginOptions options;
  final MapState map;
  final Stream<Null> stream;

  MapsPluginLayer(this.options, this.map, this.stream);

  @override
  _MapsPluginLayerState createState() => _MapsPluginLayerState();
}

class _MapsPluginLayerState extends State<MapsPluginLayer> {
  MapController controller = MapController();
  LatLng _currentLocation;
  List<Marker> markers;

  @override
  void initState() {
    var location = new Location();
    location.onLocationChanged().listen((onValue) {
      if (onValue.latitude is double) {
        setState(() {
          if (onValue == null) {
            _currentLocation = LatLng(0, 0);
          } else {
            _currentLocation = LatLng(onValue.latitude, onValue.longitude);
          }
          markers = [
            Marker(
                height: 30.0,
                width: 30.0,
                point: LatLng(
                    _currentLocation.latitude, _currentLocation.longitude),
                builder: (context) {
                  return Icon(Icons.location_on);
                })
          ];
          widget.map.move(
              LatLng(_currentLocation.latitude, _currentLocation.longitude),
              widget.map.zoom);
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(0, 0),
      ),
      layers: [MarkerLayerOptions(markers: markers)],
    );
  }
}
