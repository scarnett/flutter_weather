import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_weather/app/app_config.dart';
import 'package:flutter_weather/app/app_prefs.dart';
import 'package:flutter_weather/app/app_root.dart';
import 'package:flutter_weather/app/bloc/app_bloc_observer.dart';
import 'package:flutter_weather/app/utils/utils.dart';
import 'package:flutter_weather/enums/enums.dart';
import 'package:flutter_weather/models/models.dart';
import 'package:flutter_weather/services/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> _firebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async =>
    await Firebase.initializeApp();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase
  await Firebase.initializeApp();

  // Messaging
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Crashlytics
  await FirebaseCrashlytics.instance
      .setCrashlyticsCollectionEnabled(!kDebugMode);

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

  // DEV Environment Specific Configuration
  AppConfig appConfig = AppConfig(
    flavor: Flavor.dev,
    config: Config.fromRemoteConfig(remoteConfig.data),
    child: WeatherApp(),
  );

  // Error listening
  FlutterError.onError = (FlutterErrorDetails details) async {
    if (appConfig.config.sentryDsn.isNullOrEmpty()) {
      print(details.exceptionAsString());
      print(details.stack.toString());
    } else {
      await Sentry.captureException(
        details.exceptionAsString(),
        stackTrace: details.stack.toString(),
      );
    }
  };

  if (appConfig.config.sentryDsn.isNullOrEmpty()) {
    runApp(appConfig);
  } else {
    await SentryFlutter.init(
      (SentryFlutterOptions options) => options
        ..diagnosticLevel = SentryLevel.debug
        ..dsn = appConfig.config.sentryDsn
        ..environment = 'dev',
      appRunner: () => runApp(appConfig),
    );
  }
}
