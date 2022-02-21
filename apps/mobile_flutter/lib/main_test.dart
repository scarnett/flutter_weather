import 'package:flutter/material.dart';
import 'package:flutter_weather/app/app_config.dart';
import 'package:flutter_weather/app/app_root.dart';
import 'package:flutter_weather/app/mocks/mocks.dart';
import 'package:flutter_weather/enums/enums.dart';
import 'package:flutter_weather/models/models.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Mock Storage
  Storage storage = MockStorage();

  // TEST Environment Specific Configuration
  AppConfig config = AppConfig(
    flavor: Flavor.tst,
    config: Config.mock(),
    child: WeatherApp(),
  );

  // Error listening
  FlutterError.onError = (FlutterErrorDetails details) async {
    print(details.exception);
    print(details.stack);
  };

  HydratedBlocOverrides.runZoned(
    () => runApp(config),
    storage: storage,
  );
}
