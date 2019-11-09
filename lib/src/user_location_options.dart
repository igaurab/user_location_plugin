import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';
import 'dart:async';

import 'package:location/location.dart';

class UserLocationOptions extends LayerOptions {
  BuildContext context;
  List<Marker> markers;
  MapController mapController;

  Widget markerWidget;
  StreamController markerlocationStream;
  bool updateMapLocationOnPositionChange;
  bool showMoveToCurrentLocationFloatingActionButton;
  Widget moveToCurrentLocationFloatingActionButton;

  UserLocationOptions(
      {@required this.context,
      @required this.markers,
      this.mapController,
      this.markerWidget,
      this.markerlocationStream,
      this.updateMapLocationOnPositionChange: true,
      this.showMoveToCurrentLocationFloatingActionButton: true,
      this.moveToCurrentLocationFloatingActionButton});

  void dispose() {
    markerlocationStream.close();
  }
}
