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
  bool zoomToCurrentLocationOnLoad;
  Widget moveToCurrentLocationFloatingActionButton;

  void Function(LatLng location, double speed) onLocationUpdate;
  Function() onTapFAB;

  double fabBottom;
  double fabRight;
  double fabHeight;
  double fabWidth;

  bool verbose;
  bool showHeading;

  double defaultZoom;

  // If false the location update stream is paused if the app is in the
  // background (app lifecycle state inactive and paused). Once the app is
  // resumed the stream is resumed as well.
  bool locationUpdateInBackground;

  // Desired interval for location updates, in milliseconds. Only affects
  // Android; Details see underlying location package:
  // https://github.com/Lyokone/flutterlocation#public-methods-summary
  int locationUpdateIntervalMs;

  UserLocationOptions(
      {@required this.context,
      @required this.markers,
      this.mapController,
      this.markerWidget,
      this.onLocationUpdate,
      this.onTapFAB,
      this.updateMapLocationOnPositionChange: true,
      this.showMoveToCurrentLocationFloatingActionButton: true,
      this.moveToCurrentLocationFloatingActionButton,
      this.verbose: false,
      this.fabBottom: 20,
      this.fabHeight: 40,
      this.fabRight: 20,
      this.fabWidth: 40,
      this.defaultZoom: 15,
      this.zoomToCurrentLocationOnLoad: false,
      this.showHeading: true,
      this.locationUpdateInBackground: true,
      this.locationUpdateIntervalMs: 1000});
}
