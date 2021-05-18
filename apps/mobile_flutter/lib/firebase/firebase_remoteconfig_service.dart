import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:sentry/sentry.dart';

class FirebaseRemoteConfigService {
  final RemoteConfig? _remoteConfig;

  FirebaseRemoteConfigService({
    RemoteConfig? remoteConfig,
  }) : _remoteConfig = remoteConfig;

  static FirebaseRemoteConfigService? _instance;
  static FirebaseRemoteConfigService? getInstance() {
    if (_instance == null) {
      _instance = FirebaseRemoteConfigService(
        remoteConfig: RemoteConfig.instance,
      );
    }

    return _instance;
  }

  Future initialize() async {
    try {
      await _fetchAndActivate();
    } on Exception catch (exception, stackTrace) {
      // Fetch throttled.
      print('Remote config fetch throttled: $exception');
      await Sentry.captureException(exception, stackTrace: stackTrace);
    } catch (exception, stackTrace) {
      print('Unable to fetch remote config. Cached or default values will be '
          'used');

      await Sentry.captureException(exception, stackTrace: stackTrace);
    }
  }

  Future _fetchAndActivate() async {
    DateTime lastFetch = _remoteConfig!.lastFetchTime;
    print('[FirebaseRemoteConfig] Last fetch: $lastFetch');

    await _remoteConfig!.setDefaults({
      'openweathermap_api_current_forecast_path': '/data/2.5/weather',
      'openweathermap_api_hourly_forecast_path': '/data/2.5/forecast/hourly',
      'openweathermap_api_daily_forecast_path': '/data/2.5/forecast/daily',
    });

    await _remoteConfig!.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: Duration(seconds: 10),
      minimumFetchInterval: Duration(hours: 1),
    ));

    await _remoteConfig!.fetch();
    await _remoteConfig!.activate();
  }

  String get appVersion => _remoteConfig!.getString('app_version');
  String get appPushNotificationsSave =>
      _remoteConfig!.getString('app_push_notifications_save');

  String get appPushNotificationsRemove =>
      _remoteConfig!.getString('app_push_notifications_remove');

  String get openWeatherMapApiKey =>
      _remoteConfig!.getString('openweathermap_api_key');

  String get openWeatherMapApiUri =>
      _remoteConfig!.getString('openweathermap_api_uri');

  String get openWeatherMapApiCurrentForecastPath =>
      _remoteConfig!.getString('openweathermap_api_current_forecast_path');

  String get openWeatherMapApiDailyForecastPath =>
      _remoteConfig!.getString('openweathermap_api_daily_forecast_path');

  String get openWeatherMapApiHourlyForecastPath =>
      _remoteConfig!.getString('openweathermap_api_hourly_forecast_path');

  int get refreshTimeout => _remoteConfig!.getInt('refresh_timeout');

  String get defaultCountryCode =>
      _remoteConfig!.getString('default_country_code');

  String get supportedLocales => _remoteConfig!.getString('supported_locales');
  String? get privacyPolicyUrl =>
      _remoteConfig!.getString('privacy_policy_url');

  String? get githubUrl => _remoteConfig!.getString('github_url');
  String? get sentryDsn => _remoteConfig!.getString('sentry_dsn');
}
