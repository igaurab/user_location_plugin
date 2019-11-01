import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'dart:async';


class UserLocationOptions extends LayerOptions {
  BuildContext context;
  MapController mapController;
  List<Marker> markers;
  Widget markerWidget;
  StreamController markerlocationStream;
  bool updateMapOnPositionChange = true;

  UserLocationOptions({
    this.context,
    this.mapController,
    this.markers,
    this.markerWidget,
    this.markerlocationStream,
    this.updateMapOnPositionChange,
  });

  void dispose() {
    markerlocationStream.close();
  }
}
