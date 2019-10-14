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
                  center: LatLng(37.77823, -122.391),
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
                  MyCustomPluginOptions(
                      text: "I'm a plugin!", context: context),
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
  final String text;
  LatLng latLng;
  BuildContext context;
  GetLocation loc = GetLocation();

  MyCustomPluginOptions({this.text = '', this.context});

  void getLocation() async {
    print('GOT TO LOCATION');
    await loc.getLocation().then((onValue) {
      latLng = onValue;
      print(latLng);
      print('The latitide is  ${onValue.latitude}');
    });
  }
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
      var customPlugin = MyCustomPluginOptions(text: '', context: context);
      customPlugin.getLocation();

      return FlutterMap(
        options: MapOptions(center: options.latLng, zoom: 13.0),
        layers: [
          MarkerLayerOptions(markers: [
            Marker(
                width: 40.0,
                height: 40.0,
                point: options.latLng,
                builder: (context) => Container(
                      child: Icon(
                        Icons.my_location,
                        color: Colors.blueAccent[300],
                      ),
                    ))
          ])
        ],
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
