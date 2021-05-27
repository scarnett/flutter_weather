import 'package:flutter/material.dart';

class AppFABLocation extends FloatingActionButtonLocation {
  FloatingActionButtonLocation location;
  double offsetX;
  double offsetY;

  AppFABLocation(
    this.location,
    this.offsetX,
    this.offsetY,
  );

  @override
  Offset getOffset(
    ScaffoldPrelayoutGeometry scaffoldGeometry,
  ) {
    Offset offset = location.getOffset(scaffoldGeometry);
    return Offset((offset.dx + offsetX), (offset.dy + offsetY));
  }
}
