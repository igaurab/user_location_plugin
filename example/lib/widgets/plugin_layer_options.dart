import 'dart:convert';
import '../widgets/getLocation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';
import '../widgets/drawer.dart';
import 'dart:async';

class MyCustomPluginOptions extends LayerOptions {
  LatLng latLng;
  BuildContext context;
  GetLocation loc = GetLocation();

  MyCustomPluginOptions({this.context});

  Future<LatLng> getLocation() async {
    print('GOT TO LOCATION');
    await loc.getLocation().then((onValue) {
      latLng = onValue;
      // print(latLng);
      print('The latitide is  ${latLng.latitude}');
    });
    return latLng;
  }
}
