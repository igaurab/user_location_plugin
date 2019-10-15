import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/plugin_api.dart';
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
  @override
  Widget build(BuildContext context) {
    var customPlugin = MyCustomPluginOptions(context: context);
    var latLng = customPlugin.getLocation();
    // print("INSIDE PLUGIN: $latLng");

    return FutureBuilder(
      future: customPlugin.getLocation(),
      initialData: LatLng(0, 0),
      builder: (context, AsyncSnapshot snapshot) {
        LatLng value = snapshot.data;
        final _zoom = 10.0;
        print('Data of Snapshot ${value}');
        print('${value.latitude}');
        print('${value.longitude}');

        widget.map.move(LatLng(value.latitude, value.longitude), _zoom);
        // MapController mapController = MapController();
        // mapController.move(LatLng(value.latitude, value.longitude), 10.0);
        return FlutterMap(
          options: MapOptions(
            center: LatLng(value.latitude, value.longitude),
          ),
          // mapController: controller,
          layers: [
            MarkerLayerOptions(markers: [
              Marker(
                  point: value,
                  builder: (context) => Container(
                        child: Icon(
                          Icons.location_on,
                        ),
                      ))
            ])
          ],
        );
      },
    );
  }
}
