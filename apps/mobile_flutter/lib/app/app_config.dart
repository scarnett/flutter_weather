import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_weather/enums/flavor.dart';

class AppConfig extends InheritedWidget {
  final Flavor flavor;
  final Map<String, RemoteConfigValue>? remoteConfig;

  static late AppConfig _instance;

  factory AppConfig({
    required Flavor flavor,
    Map<String, RemoteConfigValue>? remoteConfig,
    required Widget child,
  }) {
    _instance = AppConfig._internal(
      flavor,
      remoteConfig,
      child,
    );

    return _instance;
  }

  AppConfig._internal(
    this.flavor,
    this.remoteConfig,
    Widget child,
  ) : super(child: child);

  static AppConfig get instance => _instance;

  String get appVersion => remoteConfig!['app_version']!.asString();
  String get appBuild => remoteConfig!['app_build']!.asString();
  String get appPushNotificationsSave =>
      remoteConfig!['app_push_notifications_save']!.asString();

  String get appPushNotificationsRemove =>
      remoteConfig!['app_push_notifications_remove']!.asString();

  String get appConnectivityStatus =>
      remoteConfig!['app_connectivity_status']!.asString();

  String get openWeatherMapApiKey =>
      remoteConfig!['openweathermap_api_key']!.asString();

  String get openWeatherMapApiUri =>
      remoteConfig!['openweathermap_api_uri']!.asString();

  String get openWeatherMapApiOneCallUrl =>
      remoteConfig!['openweathermap_api_one_call_url']!.asString();

  String get openWeatherMapApiDailyForecastPath =>
      remoteConfig!['openweathermap_api_daily_forecast_path']!.asString();

  String get openWeatherMapApiOneCallPath =>
      remoteConfig!['openweathermap_api_one_call_path']!.asString();

  int get refreshTimeout => remoteConfig!['refresh_timeout']!.asInt();

  String get defaultCountryCode =>
      remoteConfig!['default_country_code']!.asString();

  String get supportedLocales => remoteConfig!['supported_locales']!.asString();
  String? get privacyPolicyUrl =>
      remoteConfig!['privacy_policy_url']!.asString();

  String? get githubUrl => remoteConfig!['github_url']!.asString();
  String? get sentryDsn => remoteConfig!['sentry_dsn']!.asString();

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
