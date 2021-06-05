import 'package:flutter_map/flutter_map.dart';

class UserLocationMarker extends Marker {
  UserLocationMarker({
    required point,
    required builder,
    required width,
    required height,
    AnchorPos? anchorPos,
  }) : super(
          point: point,
          builder: builder,
          width: width,
          height: height,
          anchorPos: anchorPos,
        );
}
