import 'dart:convert';
import '../widgets/getLocation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';
import '../widgets/drawer.dart';
import 'dart:async';
import '../widgets/plugin_layer.dart';
import '../widgets/my_custom_plugin.dart';
import '../widgets/plugin_layer_options.dart';

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
