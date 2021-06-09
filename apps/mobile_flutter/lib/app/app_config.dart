import 'package:flutter/widgets.dart';
import 'package:flutter_weather/enums/flavor.dart';
import 'package:flutter_weather/models/models.dart';

class AppConfig extends InheritedWidget {
  final Flavor flavor;
  final Config config;

  static late AppConfig _instance;

  factory AppConfig({
    required Flavor flavor,
    required Config config,
    required Widget child,
  }) {
    _instance = AppConfig._internal(
      flavor,
      config,
      child,
    );

    return _instance;
  }

  AppConfig._internal(
    this.flavor,
    this.config,
    Widget child,
  ) : super(child: child);

  static AppConfig get instance => _instance;

  static AppConfig? of(
    BuildContext context,
  ) =>
      context.dependOnInheritedWidgetOfExactType(aspect: AppConfig);

  static bool isDebug() {
    switch (instance.flavor) {
      case Flavor.dev:
        return true;

      case Flavor.tst:
        return false;

      case Flavor.prod:
      default:
        return false;
    }
  }

  static bool isRelease() {
    switch (instance.flavor) {
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
