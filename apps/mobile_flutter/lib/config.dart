import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

enum Flavor {
  dev,
  tst,
  prod,
}

class AppConfig extends InheritedWidget {
  final Flavor flavor;

  AppConfig({
    @required this.flavor,
    @required Widget child,
  }) : super(child: child);

  static AppConfig of(
    BuildContext context,
  ) =>
      context.dependOnInheritedWidgetOfExactType(aspect: AppConfig);

  static bool isDebug(
    BuildContext context,
  ) {
    Flavor flavor = AppConfig.of(context).flavor;
    switch (flavor) {
      case Flavor.dev:
        return true;

      case Flavor.tst:
        return false;

      case Flavor.prod:
      default:
        return false;
    }
  }

  static bool isRelease(
    BuildContext context,
  ) {
    Flavor flavor = AppConfig.of(context).flavor;
    switch (flavor) {
      case Flavor.prod:
        return true;

      case Flavor.tst:
      case Flavor.dev:
      default:
        return false;
    }
  }

  @override
  bool updateShouldNotify(
    InheritedWidget oldWidget,
  ) =>
      false;
}
