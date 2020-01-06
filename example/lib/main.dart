import 'dart:async';

import 'package:flutter/material.dart';
import 'package:user_location/user_location.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plugin Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  MapController mapController = MapController();
  List<Marker> markers = [];
  StreamController<LatLng> markerlocationStream = StreamController();

  @override
  Widget build(BuildContext context) {
    //Get the current location of marker
    markerlocationStream.stream.listen((onData) {
      // print(onData.latitude);
    });

    return Scaffold(
      appBar: AppBar(title: Text("Plugin User Location")),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(27.7172, 85.3240),
          zoom: 15.0,
          plugins: [
            UserLocationPlugin(),
          ],
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: "https://api.tiles.mapbox.com/v4/"
                "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
            additionalOptions: {
              'accessToken':
                  'pk.eyJ1IjoiaWdhdXJhYiIsImEiOiJjazFhOWlkN2QwYzA5M2RyNWFvenYzOTV0In0.lzjuSBZC6LcOy_oRENLKCg',
              'id': 'mapbox.streets',
            },
          ),
          MarkerLayerOptions(markers: markers),
          UserLocationOptions(
              context: context,
              mapController: mapController,
              markers: markers,
              onLocationUpdate: (LatLng pos) =>
                  print("onLocationUpdate ${pos.toString()}"),
              updateMapLocationOnPositionChange: true,
              showMoveToCurrentLocationFloatingActionButton: true,
              fabBottom: 50,
              fabRight: 50,
              verbose: false),
        ],
        mapController: mapController,
      ),
    );
  }

  void dispose() {
    markerlocationStream.close();
  }
}
