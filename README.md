# user_location

A plugin for [FlutterMap](https://github.com/johnpryan/flutter_map)  package to handle and plot the current user location



### Demo

```html
<div style="text-align: center"><table><tr>
  <td style="text-align: center">
  <a href="">
    <img src="example.gif" width="200"/></a>
</td>
</tr></table></div>
```



## Usage

## Usage

Add flutter_map and  user_location to your pubspec.yaml :

```yaml
dependencies:
  flutter_map: any
  user_location: any # or the latest version on Pub
```

Add it in you FlutterMap. Make sure to pass the required options in the `UserLocationOptions` and marker in  `MarkerLayerOptions` 

```dart
import 'package:flutter/material.dart';
import 'package:user_location/user_location.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Location Plugin Demo',
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("User Location Plugin")),
        body: FlutterMap(
          options: MapOptions(
            center: LatLng(0,0),
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
                    '<access_token>',
                'id': 'mapbox.streets',
              },
            ),
            MarkerLayerOptions(markers: markers),
            UserLocationOptions(
                context: context,
                mapController: mapController,
                markers: markers),
          ],
          mapController: mapController,
        ));
  }
}
```

### Run the example

See the `example/` folder for a working example app.