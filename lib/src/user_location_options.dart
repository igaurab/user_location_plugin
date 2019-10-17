import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';
import 'dart:async';
import '../utils/getLocation.dart';

class UserLocationOptions extends LayerOptions {
  BuildContext context;
  MapController mapController;
  List<Marker> markers;
  UserLocationOptions({this.context, this.mapController, this.markers});
}
