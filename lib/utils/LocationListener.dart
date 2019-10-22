import 'package:flutter/services.dart';

class LocationListener {
  static const EventChannel _stream =
      const EventChannel('locationStatusStream');

  Stream<bool> _locationStatusChanged;

  Stream<bool> onLocationStatusChanged() {
    if (_locationStatusChanged == null) {
      _locationStatusChanged = _stream.receiveBroadcastStream();
    }
    return _locationStatusChanged;
  }
}
