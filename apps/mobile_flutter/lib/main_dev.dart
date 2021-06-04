import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_weather/app/app_config.dart';
import 'package:flutter_weather/app/app_prefs.dart';
import 'package:flutter_weather/app/app_root.dart';
import 'package:flutter_weather/app/utils/utils.dart';
import 'package:flutter_weather/bloc/app_bloc_observer.dart';
import 'package:flutter_weather/enums/enums.dart';
import 'package:flutter_weather/firebase/firebase_remoteconfig_service.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> _firebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {
  await Firebase.initializeApp();
  // TODO!
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase
  await Firebase.initializeApp();

  // Messaging
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Crashlytics
  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  }

  // Remote configuration
  final FirebaseRemoteConfigService remoteConfig =
      FirebaseRemoteConfigService();

  await remoteConfig.initialize();

  // Bloc
  Bloc.observer = AppBlocObserver();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getTemporaryDirectory(),
  );

  // await HydratedBloc.storage.clear();

  // Preferences
  await AppPrefs().init();

  // Error listening
  FlutterError.onError = (FlutterErrorDetails details) async {
    if (remoteConfig.sentryDsn.isNullOrEmpty()) {
      print(details.exception);
      print(details.stack);
    } else {
      await Sentry.captureException(
        details.exception,
        stackTrace: details.stack,
      );
    }
  };

  // DEV Environment Specific Configuration
  AppConfig config = AppConfig(
    flavor: Flavor.dev,
    appVersion: remoteConfig.appVersion,
    appBuild: remoteConfig.appBuild,
    appPushNotificationsSave: remoteConfig.appPushNotificationsSave,
    appPushNotificationsRemove: remoteConfig.appPushNotificationsRemove,
    openWeatherMapApiKey: remoteConfig.openWeatherMapApiKey,
    openWeatherMapApiUri: remoteConfig.openWeatherMapApiUri,
    openWeatherMapApiDailyForecastPath:
        remoteConfig.openWeatherMapApiDailyForecastPath,
    openWeatherMapApiOneCallPath: remoteConfig.openWeatherMapApiOneCallPath,
    refreshTimeout: remoteConfig.refreshTimeout,
    defaultCountryCode: remoteConfig.defaultCountryCode,
    supportedLocales: remoteConfig.supportedLocales,
    privacyPolicyUrl: remoteConfig.privacyPolicyUrl,
    githubUrl: remoteConfig.githubUrl,
    sentryDsn: remoteConfig.sentryDsn,
    child: WeatherApp(),
  );

  if (remoteConfig.sentryDsn.isNullOrEmpty()) {
    runApp(config);
  } else {
    await SentryFlutter.init(
      (SentryFlutterOptions options) => options
        ..dsn = remoteConfig.sentryDsn
        ..environment = 'dev',
      appRunner: () {
        runApp(config);
      },
    );
  }
}
