import 'package:flutter/cupertino.dart';
import 'package:flutter/physics.dart';

class AppPageViewScrollPhysics extends ScrollPhysics {
  const AppPageViewScrollPhysics({
    ScrollPhysics? parent,
  }) : super(parent: parent);

  @override
  AppPageViewScrollPhysics applyTo(
    ScrollPhysics? ancestor,
  ) =>
      AppPageViewScrollPhysics(parent: buildParent(ancestor));

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 80,
        stiffness: 100,
        damping: 1,
      );
}
