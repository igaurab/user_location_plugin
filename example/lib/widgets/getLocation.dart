import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:latlong/latlong.dart';

class GetLocation {
  bool permission = false;

  Future<LatLng> getLocation() async {
    // LocationData currentLocation;
    LatLng latlng;
    var location = new Location();
    var serviceStatus = await location.serviceEnabled();
    print('Service Status $serviceStatus');

    if (!serviceStatus) {
      var val = await location.requestService();
      print('Req service $val');
      serviceStatus = await location.serviceEnabled();
      print('Service Status after request $serviceStatus');
      permission = await location.requestPermission();
      print('Permission $permission');
      if (!permission) {
        val = await location.requestService();
        print('Req service $val');
      }
    }
    try {
      await location.getLocation().then((onValue) {
        if (onValue.latitude is double) {
          print('Latitude is double ${onValue.latitude.toString()}');
        }

        print(onValue.latitude.toString() + "," + onValue.longitude.toString());
        latlng = LatLng(onValue.latitude, onValue.longitude);
        print(latlng);
      });
      return latlng;
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        var error = 'Permission denied';
        print(error);
      } else {
        print('Uncaught Exception');
      }
      // currentLocation = null;
    }
    // return null;
  }

  Future<LatLng> getLocationStream() async {
    var location = new Location();
    var serviceStatus = await location.serviceEnabled();
    print('Service Status $serviceStatus');

    if (!serviceStatus) {
      var val = await location.requestService();
      print('Req service $val');
      serviceStatus = await location.serviceEnabled();
      print('Service Status after request $serviceStatus');
      permission = await location.requestPermission();
      print('Permission $permission');
      if (!permission) {
        val = await location.requestService();
        print('Req service $val');
      }
    }
    try {
      await location.onLocationChanged().listen((LocationData currentLocation) {
        if (currentLocation != null) {
          LatLng latLng;
          latLng.latitude = currentLocation.latitude;
          latLng.longitude = currentLocation.longitude;
          print(currentLocation.latitude);
          print(currentLocation.longitude);
          return latLng;
        } else {
          print('Current Location is null');
          return LatLng(0, 0);
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        var error = 'Permission denied';
        print(error);
      } else {
        print('Uncaught Exception');
      }
      // currentLocation = null;
    }
    // return null;
  }
}

GetLocation loc = GetLocation();
