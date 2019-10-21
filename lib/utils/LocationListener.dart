import 'package:flutter/services.dart';

class LocationListener {
  static const EventChannel _stream = const EventChannel('locationPermissionStream');

  Stream<bool> _locationPermissionStatus;
  Stream<bool> _locationStatusChanged;

  Stream<bool> onLocationPermissionChanged() {
    if(_locationPermissionStatus == null) {

    }
  }

  Stream<bool> onLocationStatusChanged() {
    if(_locationStatusChanged == null) {

    }
  }
}