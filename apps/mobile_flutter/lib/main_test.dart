import 'package:flutter/material.dart';
import 'package:flutter_weather/app.dart';
import 'package:flutter_weather/app/app_config.dart';
import 'package:flutter_weather/enums/enums.dart';
import 'package:flutter_weather/storage/mock_storage.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Bloc
  HydratedBloc.storage = MockStorage();

  // Error listening
  FlutterError.onError = (FlutterErrorDetails details) async {
    print(details.exception);
    print(details.stack);
  };

  // PROD Environment Specific Configuration
  AppConfig config = AppConfig(
    flavor: Flavor.prod,
    child: WeatherApp(),
  );

  runApp(config);
}
