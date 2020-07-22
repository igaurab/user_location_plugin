# user_location

[![pub package](https://img.shields.io/pub/v/user_location.svg)](https://pub.dartlang.org/packages/user_location) ![travis](https://api.travis-ci.com/lpongetti/flutter_map_marker_cluster.svg?branch=master) [![Codemagic build status](https://api.codemagic.io/apps/5e7057c82c964659341b9932/5e7057c82c964659341b9931/status_badge.svg)](https://codemagic.io/apps/5e7057c82c964659341b9932/5e7057c82c964659341b9931/latest_build)



A plugin for [FlutterMap](https://github.com/johnpryan/flutter_map)  package to handle and plot the current user location


<div style="text-align: center"><table><tr>
  <td style="text-align: center">
  <a href="https://github.com/igaurab/UserLocationPlugin/blob/master/example.gif">
    <img src="https://github.com/igaurab/UserLocationPlugin/blob/master/example.gif" width="200"/></a>
</td>
</tr></table></div>

## Usage

Add flutter_map and  user_location to your pubspec.yaml :

```yaml
dependencies:
  flutter_map: any
  user_location:
    git:
      url: https://github.com/igaurab/user_location_plugin.git
```



Update your `gradle.properties` file with this:

```
android.enableJetifier=true
android.useAndroidX=true
org.gradle.jvmargs=-Xmx1536M
```



Also make sure that you have added those dependencies in your build.gradle:

```
  dependencies {
      classpath 'com.android.tools.build:gradle:3.3.0'
      classpath 'com.google.gms:google-services:4.2.0'
  }
  compileSdkVersion 28
```

## Getting Started 

### Android 

In order to use this plugin in Android, you have to add this permission in `AndroidManifest.xml` :

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
```

Permission check for Android 6+ was added.

### iOS
* Note: I have not tested the plugin in ios

On iOS you'll need to add the NSLocationWhenInUseUsageDescription to your Info.plist file in order to access the device's location. Simply open your Info.plist file and add the following:

```
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to location when open.</string>
```

If you would like to access the device's location when your App is running in the background, you should also add the NSLocationAlwaysAndWhenInUseUsageDescription (if your App support iOS 10 or earlier you should also add the key NSLocationAlwaysUsageDescription) key to your Info.plist file:

```
<key>NSLocationAlwaysUsageDescription</key>
<string>This app needs access to location when in the background.</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>This app needs access to location when open and in the background.</string>
```



### Installation guide

- Declare and initialize ```  MapController mapController = MapController(); List<Marker> markers = [];```
- Add ` UserLocationPlugin()` to plugins
- Add  `MarkerLayerOptions` and `UserLocationOptions` in `layers`


### Sample code

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
  // ADD THIS
  MapController mapController = MapController();
  UserLocationOptions userLocationOptions;
  // ADD THIS
  List<Marker> markers = [];
  @override
  Widget build(BuildContext context) {
    // You can use the userLocationOptions object to change the properties
    // of UserLocationOptions in runtime
    userLocationOptions = UserLocationOptions(
                context: context,
                mapController: mapController,
                markers: markers,
                );
    return Scaffold(
        appBar: AppBar(title: Text("User Location Plugin")),
        body: FlutterMap(
          options: MapOptions(
            center: LatLng(0,0),
            zoom: 15.0,
            plugins: [
             // ADD THIS
              UserLocationPlugin(),
            ],
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: "https://api.tiles.mapbox.com/v4/"
                  "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
              additionalOptions: {
                'accessToken': '<access_token>',
                'id': 'mapbox.streets',
              },
            ),
            // ADD THIS
            MarkerLayerOptions(markers: markers),
            // ADD THIS
            userLocationOptions,
          ],
          // ADD THIS
          mapController: mapController,
        ));
  }
}
```


### Optional parameters
* `markerWidget` overrides the default marker widget
* `onLocationChange` is a callback function to get the current location of user. It's uses is defined in the example program.
* `updateMapLocationOnPositionChange` moves the map to the current location of the user if set to `true`
* `showMoveToCurrentLocationFloatingActionButton` displays a floating action button at the bottom right of the screen which will redirect the user to their current location. You can also pass your own widget as FAB and control the position using options `fabBottom` and `fabRight` options.
* `showHeading` is used to control whether or not to show heading in the marker widget
* `zoomToCurrentLocationOnLoad` if true, zooms to the current location of the user with a zoom factor 17
* `moveToCurrentLocationFloatingActionButton` is a widget when passed overrides the default floating action button. Default floating action button code: 
``` 
Container(
    decoration: BoxDecoration(
    color: Colors.blueAccent,
    borderRadius: BorderRadius.circular(20.0),
    boxShadow: [
        BoxShadow(color: Colors.grey, blurRadius: 10.0)
        ]),
    child: Icon(
        Icons.my_location,
        color: Colors.white,
    ),
)
```
* `locationUpdateInBackground` if `false`, the location update stream is paused if the app is in the background. Once the app is resumed the stream is resumed as well. Option can be useful to reduce the battery consumption while the app is running in the background. Default: `true`.

* `locationUpdateIntervalMs` desired interval for a location updates, in milliseconds. Default: 1000 milliseconds.


### Run the example

See the `example/` folder for a working example app.
