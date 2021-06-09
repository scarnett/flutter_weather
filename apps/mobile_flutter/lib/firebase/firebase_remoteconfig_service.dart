import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:sentry/sentry.dart';

class FirebaseRemoteConfigService {
  late RemoteConfig _remoteConfig;

  Future initialize() async {
    try {
      await _fetchAndActivate();
    } on Exception catch (exception, stackTrace) {
      _remoteConfig = RemoteConfig
          .instance; // TODO! set the 'retry' flag in the state instead

      print('Remote config fetch throttled: $exception');
      await Sentry.captureException(exception, stackTrace: stackTrace);
    } catch (exception, stackTrace) {
      _remoteConfig = RemoteConfig
          .instance; // TODO! set the 'retry' flag in the state instead

      print('Unable to fetch remote config. Cached or default values will be '
          'used');

      await Sentry.captureException(exception, stackTrace: stackTrace);
    }
  }

  Future _fetchAndActivate() async {
    final RemoteConfig initialRemoteConfig = RemoteConfig.instance;

    await initialRemoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: Duration(minutes: 1),
      minimumFetchInterval: Duration(hours: 1),
    ));

    await initialRemoteConfig.fetch();
    _remoteConfig = initialRemoteConfig;
    bool fetchActivated = await _remoteConfig.activate();
    print('[FirebaseRemoteConfig] Fetched: $fetchActivated');

    DateTime lastFetch = _remoteConfig.lastFetchTime;
    print('[FirebaseRemoteConfig] Last fetch: $lastFetch');
  }

  Map<String, RemoteConfigValue> get data => _remoteConfig.getAll();
}
