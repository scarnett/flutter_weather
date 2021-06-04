import 'package:flutter/material.dart';

class AppFABLocation extends FloatingActionButtonLocation {
  FloatingActionButtonLocation location;
  double offsetX;
  double offsetY;

  AppFABLocation({
    required this.location,
    required this.offsetX,
    required this.offsetY,
  });

  @override
  Offset getOffset(
    ScaffoldPrelayoutGeometry scaffoldGeometry,
  ) {
    final Offset offset = location.getOffset(scaffoldGeometry);
    return Offset((offset.dx + offsetX), (offset.dy + offsetY));
  }
}
