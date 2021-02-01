import 'package:firebase_remote_config/firebase_remote_config.dart';

class FirebaseRemoteConfigService {
  final RemoteConfig _remoteConfig;

  FirebaseRemoteConfigService({
    RemoteConfig remoteConfig,
  }) : _remoteConfig = remoteConfig;

  static FirebaseRemoteConfigService _instance;
  static Future<FirebaseRemoteConfigService> getInstance() async {
    if (_instance == null) {
      _instance = FirebaseRemoteConfigService(
        remoteConfig: await RemoteConfig.instance,
      );
    }

    return _instance;
  }

  Future initialise() async {
    try {
      await _fetchAndActivate();
    } on FetchThrottledException catch (exception) {
      // Fetch throttled.
      print('Remote config fetch throttled: $exception');
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be '
          'used');
    }
  }

  Future _fetchAndActivate() async {
    await _remoteConfig.fetch();
    await _remoteConfig.activateFetched();
  }

  String get appVersion => _remoteConfig.getString('app_version');
}
