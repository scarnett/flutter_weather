import 'package:equatable/equatable.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class Config extends Equatable {
  final String appVersion;
  final String appBuild;
  final String appPushNotificationsSave;
  final String appPushNotificationsRemove;
  final String appConnectivityStatus;
  final String openWeatherMapApiKey;
  final String openWeatherMapApiUri;
  final String openWeatherMapApiDailyForecastPath;
  final String openWeatherMapApiOneCallPath;
  final int refreshTimeout;
  final String defaultCountryCode;
  final String supportedLocales;
  final String? privacyPolicyUrl;
  final String? githubUrl;
  final String? sentryDsn;
  final String? adMobNativeUnitId;

  Config({
    required this.appVersion,
    required this.appBuild,
    required this.appPushNotificationsSave,
    required this.appPushNotificationsRemove,
    required this.appConnectivityStatus,
    required this.openWeatherMapApiKey,
    required this.openWeatherMapApiUri,
    required this.openWeatherMapApiDailyForecastPath,
    required this.openWeatherMapApiOneCallPath,
    required this.refreshTimeout,
    required this.defaultCountryCode,
    required this.supportedLocales,
    this.privacyPolicyUrl,
    this.githubUrl,
    this.sentryDsn,
    this.adMobNativeUnitId,
  });

  factory Config.mock() => Config(
        appVersion: '1.5.0',
        appBuild: '1',
        appPushNotificationsSave:
            'http://flutter-weather.mock/http-push-notifications-save',
        appPushNotificationsRemove:
            'http://flutter-weather.mock/http-push-notifications-remove',
        appConnectivityStatus:
            'http://flutter-weather.mock/http-connectivity-status',
        openWeatherMapApiKey: '',
        openWeatherMapApiUri: '',
        openWeatherMapApiDailyForecastPath: '',
        openWeatherMapApiOneCallPath: '',
        refreshTimeout: 300000,
        defaultCountryCode: 'us',
        supportedLocales: 'en',
      );

  static Config fromRemoteConfig(Map<String, RemoteConfigValue> values) =>
      Config(
        appVersion: values['app_version']!.asString(),
        appBuild: values['app_build']!.asString(),
        appPushNotificationsSave:
            values['app_push_notifications_save']!.asString(),
        appPushNotificationsRemove:
            values['app_push_notifications_remove']!.asString(),
        appConnectivityStatus: values['app_connectivity_status']!.asString(),
        openWeatherMapApiKey: values['openweathermap_api_key']!.asString(),
        openWeatherMapApiUri: values['openweathermap_api_uri']!.asString(),
        openWeatherMapApiDailyForecastPath:
            values['openweathermap_api_daily_forecast_path']!.asString(),
        openWeatherMapApiOneCallPath:
            values['openweathermap_api_one_call_path']!.asString(),
        refreshTimeout: values['refresh_timeout']!.asInt(),
        defaultCountryCode: values['default_country_code']!.asString(),
        supportedLocales: values['supported_locales']!.asString(),
        privacyPolicyUrl: values['privacy_policy_url']!.asString(),
        githubUrl: values['github_url']!.asString(),
        sentryDsn: values['sentry_dsn']!.asString(),
        adMobNativeUnitId: values['admob_native_unit_id']!.asString(),
      );

  @override
  List<Object?> get props => [
        appVersion,
        appBuild,
        appPushNotificationsSave,
        appPushNotificationsRemove,
        appConnectivityStatus,
        openWeatherMapApiKey,
        openWeatherMapApiUri,
        openWeatherMapApiDailyForecastPath,
        openWeatherMapApiOneCallPath,
        refreshTimeout,
        defaultCountryCode,
        supportedLocales,
        privacyPolicyUrl,
        githubUrl,
        sentryDsn,
        adMobNativeUnitId,
      ];

  @override
  String toString() =>
      'Config{appVersion: $appVersion, appBuild: $appBuild, ' +
      'appPushNotificationsSave: $appPushNotificationsSave, ' +
      'appPushNotificationsRemove: $appPushNotificationsRemove, ' +
      'appConnectivityStatus: $appConnectivityStatus, ' +
      'openWeatherMapApiKey: $openWeatherMapApiKey, ' +
      'openWeatherMapApiUri: $openWeatherMapApiUri, ' +
      'openWeatherMapApiDailyForecastPath: $openWeatherMapApiDailyForecastPath ' +
      'openWeatherMapApiOneCallPath: $openWeatherMapApiOneCallPath, ' +
      'refreshTimeout: $refreshTimeout, defaultCountryCode: $defaultCountryCode ' +
      'supportedLocales: $supportedLocales, privacyPolicyUrl: $privacyPolicyUrl ' +
      'githubUrl: $githubUrl, sentryDsn: $sentryDsn, ' +
      'adMobNativeUnitId: $adMobNativeUnitId}';
}
