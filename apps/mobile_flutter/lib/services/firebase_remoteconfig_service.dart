import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:sentry/sentry.dart';

class FirebaseRemoteConfigService {
  late FirebaseRemoteConfig _remoteConfig;

  Future initialize() async {
    try {
      await _fetchAndActivate();
    } on Exception catch (exception, stackTrace) {
      _remoteConfig = FirebaseRemoteConfig
          .instance; // TODO! set the 'retry' flag in the state instead

      print('Remote config fetch throttled: $exception');
      await Sentry.captureException(exception, stackTrace: stackTrace);
    } catch (exception, stackTrace) {
      _remoteConfig = FirebaseRemoteConfig
          .instance; // TODO! set the 'retry' flag in the state instead

      print('Unable to fetch remote config. Cached or default values will be '
          'used');

      await Sentry.captureException(exception, stackTrace: stackTrace);
    }
  }

  Future _fetchAndActivate({
    int fetchTimeoutSecs: 10,
    minimumFetchIntervalHours: 1,
  }) async {
    final FirebaseRemoteConfig initialRemoteConfig =
        FirebaseRemoteConfig.instance;

    await initialRemoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: Duration(seconds: fetchTimeoutSecs),
      minimumFetchInterval: Duration(hours: minimumFetchIntervalHours),
    ));

    await initialRemoteConfig.setDefaults(defaults);
    await initialRemoteConfig.fetch();
    _remoteConfig = initialRemoteConfig;

    bool fetchActivated = await _remoteConfig.activate();
    print('[FirebaseRemoteConfig] Fetched: $fetchActivated');

    DateTime lastFetch = _remoteConfig.lastFetchTime;
    print('[FirebaseRemoteConfig] Last fetch: $lastFetch');
  }

  Map<String, RemoteConfigValue> get data => _remoteConfig.getAll();

  Map<String, dynamic> get defaults => {
        'app_version': '1.0.0',
        'app_build': '1',
        'refresh_timeout': 300000,
        'default_country_code': 'us',
        'supported_locales': 'en',
      };
}
