import 'dart:convert';
import '../widgets/getLocation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';
import '../widgets/drawer.dart';
import 'dart:async';

class PluginPage extends StatelessWidget {
  static const String route = 'plugins';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Plugins')),
      drawer: buildDrawer(context, PluginPage.route),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Flexible(
              child: FlutterMap(
                options: MapOptions(
                  zoom: 20.0,
                  plugins: [
                    MyCustomPlugin(),
                  ],
                ),
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
                  MyCustomPluginOptions(context: context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//             'accessToken': 'pk.eyJ1IjoiaWdhdXJhYiIsImEiOiJjazFhOWlkN2QwYzA5M2RyNWFvenYzOTV0In0.lzjuSBZC6LcOy_oRENLKCg',

class MyCustomPluginOptions extends LayerOptions {
  LatLng latLng;
  BuildContext context;
  GetLocation loc = GetLocation();

  MyCustomPluginOptions({this.context});

  Future<LatLng> getLocation() async {
    print('GOT TO LOCATION');
    await loc.getLocation().then((onValue) {
      latLng = onValue;
      print(latLng);
      print('The latitide is  ${latLng.latitude}');
    });
    return latLng;
  }
}

class MyCustomPlugin implements MapPlugin {
  @override
  Widget createLayer(
      LayerOptions options, MapState mapState, Stream<Null> stream) {
    if (options is MyCustomPluginOptions) {
      var context = options.context;
      var customPlugin = MyCustomPluginOptions(context: context);
      var latLng = customPlugin.getLocation();
      // print("INSIDE PLUGIN: $latLng");

      return FutureBuilder(
        future: customPlugin.getLocation(),
        builder: (context, AsyncSnapshot snapshot) {
          LatLng value = snapshot.data;
          print("Data of Snapshot ${value}");
          print("$value.latitude");
          print("$value.longitude");
          // MapController mapController = MapController();
          // mapController.move(LatLng(value.latitude, value.longitude), 10.0);
          return FlutterMap(
            options: MapOptions(center: value, zoom: 10.0),
            layers: [
              MarkerLayerOptions(markers: [
                Marker(
                    point: value,
                    builder: (context) => Container(
                          child: Icon(
                            Icons.my_location,
                            color: Colors.blueAccent[300],
                          ),
                        ))
              ])
            ],
            // mapController: mapController,
          );
        },
      );
    }
    throw Exception('Unknown options type for MyCustom'
        'plugin: $options');
  }

  @override
  bool supportsLayer(LayerOptions options) {
    return options is MyCustomPluginOptions;
  }

  List<Marker> markers;
}
