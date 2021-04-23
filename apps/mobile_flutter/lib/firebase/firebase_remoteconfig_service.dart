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

  Future initialise() async {
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
    await _remoteConfig!.fetch();
    await _remoteConfig!.activate();
  }

  String get appVersion => _remoteConfig!.getString('app_version');
}
