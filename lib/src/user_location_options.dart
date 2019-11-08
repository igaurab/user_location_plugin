import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';
import 'dart:async';

import 'package:location/location.dart';

class UserLocationOptions extends LayerOptions {
  BuildContext context;
  MapController mapController;
  List<Marker> markers;
  Widget markerWidget;
  StreamController markerlocationStream;
  bool updateMapLocationOnPositionChange;

  UserLocationOptions({
    @required this.context,
    @required this.markers,
    @required this.markerlocationStream,
    this.markerWidget,
    this.mapController,
    this.updateMapLocationOnPositionChange: true,
  });

  void dispose() {
    markerlocationStream.close();
  }
}
