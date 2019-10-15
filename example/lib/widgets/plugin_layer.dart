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
  MapController controller = MapController();

  @override
  Widget build(BuildContext context) {
    var customPlugin = MyCustomPluginOptions(context: context);
    return FutureBuilder(
      future: customPlugin.getLocation(),
      initialData: LatLng(0, 0),
      builder: (context, AsyncSnapshot snapshot) {
        LatLng value = snapshot.data;
        print('Data of Snapshot ${value}');

        // Doing so, the map moves everytime the widget gets rebuild, which it happens every second
        // We have to move the map only when if the current location is out of bound(screen)
        // Same goes with the position of marker, we have to move the position of marker only if the data changes.
        //For static data value, don't change the position of marker as well as map

        //Update: widget.map.zoom gives us the current zoom level of the map

        widget.map
            .move(LatLng(value.latitude, value.longitude), widget.map.zoom);

        return FlutterMap(
          options: MapOptions(
            center: LatLng(value.latitude, value.longitude),
          ),
          layers: [
            MarkerLayerOptions(markers: [
              Marker(
                  point: LatLng(value.latitude, value.longitude),
                  builder: (context) {
                    print("Marker is prinitng...");
                    return Container(
                        height: 30.0,
                        width: 30.0,
                        child: Icon(
                          Icons.location_on,
                          color: Colors.redAccent,
                        ));
                  }),
            ])
          ],
        );
      },
    );
  }
}
