import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:user_location/src/user_location_options.dart';
import 'dart:async';
import 'user_location_layer.dart';

class UserLocationPlugin implements MapPlugin {
  @override
  Widget createLayer(
      LayerOptions options, MapState mapState, Stream<Null> stream) {
    if (options is UserLocationOptions) {
      return MapsPluginLayer(options, mapState, stream);
    }
    throw Exception('Unknown options type for MyCustom plugin: $options');
  }

  @override
  bool supportsLayer(LayerOptions options) {
    return options is UserLocationOptions;
  }
}
