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
  UserLocationOptions(
      {this.context,
      this.mapController,
      this.markers,
      this.markerWidget,
      this.markerlocationStream});

  void dispose() {
    markerlocationStream.close();
  }
}
