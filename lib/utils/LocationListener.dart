import 'dart:async';
import 'package:flutter/services.dart';

class LocationListener {
  EventChannel _stream;
  LocationListener() {
    _stream = EventChannel('locationStatusStream');
  }
  Stream<bool> _locationStatusChanged;
  Stream<bool> onLocationStatusChanged() {
    if (_locationStatusChanged == null) {
      _stream.receiveBroadcastStream().listen((onData) {
        _locationStatusChanged = onData;
      });
    }
    return _locationStatusChanged;
  }
}
