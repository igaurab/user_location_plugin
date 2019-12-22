import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';

class UserLocationOptions extends LayerOptions {
  BuildContext context;
  List<Marker> markers;
  MapController mapController;

  Widget markerWidget;
  bool updateMapLocationOnPositionChange;
  bool showMoveToCurrentLocationFloatingActionButton;
  Widget moveToCurrentLocationFloatingActionButton;
  Function(LatLng) onLocationUpdate;

  bool verbose;

  UserLocationOptions(
      {@required this.context,
      @required this.markers,
      this.mapController,
      this.markerWidget,
      this.onLocationUpdate,
      this.updateMapLocationOnPositionChange: true,
      this.showMoveToCurrentLocationFloatingActionButton: true,
      this.moveToCurrentLocationFloatingActionButton,
      this.verbose: false});
}
