import 'package:flutter/widgets.dart';
import 'package:flutter_weather/enums.dart';

class AppConfig extends InheritedWidget {
  final Flavor flavor;
  final String? appVersion;
  final String? openweathermapApiKey;
  final String? openweathermapApiUri;
  final String? openweathermapApiDailyForecastPath;
  final String? openweathermapApiHourlyForecastPath;
  final int? refreshTimeout;
  final String? defaultCountryCode;
  final String? supportedLocales;
  final String? privacyPolicyUrl;
  final String? githubUrl;
  final String? sentryDsn;

  static late AppConfig _instance;

  factory AppConfig({
    required flavor,
    appVersion,
    openweathermapApiKey,
    openweathermapApiUri,
    openweathermapApiDailyForecastPath,
    openweathermapApiHourlyForecastPath,
    refreshTimeout,
    defaultCountryCode,
    supportedLocales,
    privacyPolicyUrl,
    githubUrl,
    sentryDsn,
    required child,
  }) {
    _instance = AppConfig._internal(
      flavor,
      appVersion,
      openweathermapApiKey,
      openweathermapApiUri,
      openweathermapApiDailyForecastPath,
      openweathermapApiHourlyForecastPath,
      refreshTimeout,
      defaultCountryCode,
      supportedLocales,
      privacyPolicyUrl,
      githubUrl,
      sentryDsn,
      child,
    );

    return _instance;
  }

  AppConfig._internal(
    this.flavor,
    this.appVersion,
    this.openweathermapApiKey,
    this.openweathermapApiUri,
    this.openweathermapApiDailyForecastPath,
    this.openweathermapApiHourlyForecastPath,
    this.refreshTimeout,
    this.defaultCountryCode,
    this.supportedLocales,
    this.privacyPolicyUrl,
    this.githubUrl,
    this.sentryDsn,
    Widget child,
  ) : super(child: child);

  static AppConfig get instance {
    return _instance;
  }

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
