import 'dart:convert';
import '../widgets/getLocation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';
import '../widgets/drawer.dart';
import 'dart:async';

class MyCustomPluginOptions extends LayerOptions {
  BuildContext context;
  MyCustomPluginOptions({this.context});
}
