import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';

class UserLocationOptions extends LayerOptions {
  BuildContext context;
  MapController mapController;
  List<Marker> markers;
  Widget markerWidget;
  UserLocationOptions(
      {this.context, this.mapController, this.markers, this.markerWidget});
}
