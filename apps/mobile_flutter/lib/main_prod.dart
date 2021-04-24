import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_weather/app.dart';
import 'package:flutter_weather/bloc/app_bloc_observer.dart';
import 'package:flutter_weather/config.dart';
import 'package:flutter_weather/env_config.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase
  await Firebase.initializeApp();

  // Crashlytics
  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  }

  // Bloc
  Bloc.observer = AppBlocObserver();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getTemporaryDirectory(),
  );

  // Error listening
  FlutterError.onError = (FlutterErrorDetails details) async {
    if (EnvConfig.SENTRY_DSN != null) {
      await Sentry.captureException(
        details.exception,
        stackTrace: details.stack,
      );
    }
  };

  // PROD Environment Specific Configuration
  AppConfig config = AppConfig(
    flavor: Flavor.prod,
    child: WeatherApp(),
  );

  if (EnvConfig.SENTRY_DSN == null) {
    runApp(config);
  } else {
    await SentryFlutter.init(
      (SentryFlutterOptions options) => options
        ..dsn = EnvConfig.SENTRY_DSN
        ..environment = 'prod'
        ..useNativeBreadcrumbTracking(),
      appRunner: () => runApp(config),
    );
  }
}
