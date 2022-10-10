import 'package:flutter/cupertino.dart';

class AppPageViewScrollPhysics extends ScrollPhysics {
  const AppPageViewScrollPhysics({
    ScrollPhysics? parent,
  }) : super(parent: parent);

  @override
  AppPageViewScrollPhysics applyTo(
    ScrollPhysics? ancestor,
  ) =>
      AppPageViewScrollPhysics(
        parent: buildParent(ancestor),
      );

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 80.0,
        stiffness: 100.0,
        damping: 1.0,
      );
}
