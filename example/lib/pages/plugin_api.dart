import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';

import '../widgets/drawer.dart';

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
                  center: LatLng(27.700769,85.300140),
                  zoom: 20.0,
                  plugins: [
                    MyCustomPlugin(),
                  ],
                ),
                layers: [
                  TileLayerOptions(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c']),
                  MyCustomPluginOptions(text: "I'm a plugin!", latLng: LatLng(27.700769,85.300140),context: context ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyCustomPluginOptions extends LayerOptions {
  final String text;
  LatLng latLng;
  BuildContext context;
  MyCustomPluginOptions({this.text = '', this.latLng,this.context});
}

class MyCustomPlugin implements MapPlugin {
  @override
  Widget createLayer(
      LayerOptions options, MapState mapState, Stream<Null> stream) {
    if (options is MyCustomPluginOptions) {
      var context = options.context;
      // var style = TextStyle(
      //   fontWeight: FontWeight.bold,
      //   fontSize: 24.0,
      //   color: Colors.red,
      // );

      return FlutterMap(
        options: MapOptions(
          center: options.latLng,
          zoom: 13.0
        ),
        layers: [
          MarkerLayerOptions(
            markers: [
              Marker(
                width: 20.0,
                height: 20.0,
                point: options.latLng,
                builder: (context) => Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blueAccent
                  ),
                )
              )
            ]
          )
        ],
      );
    }
    throw Exception('Unknown options type for MyCustom'
        'plugin: $options');
  }

  @override
  bool supportsLayer(LayerOptions options) {
    return options is MyCustomPluginOptions;
  } List<Marker> markers;
}
