import 'package:flutter/material.dart';
import 'package:flutter_weather/app.dart';
import 'package:flutter_weather/config.dart';
import 'package:flutter_weather/storage/mock_storage.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Bloc
  HydratedBloc.storage = MockStorage();

  // PROD Environment Specific Configuration
  AppConfig config = AppConfig(
    flavor: Flavor.prod,
    child: WeatherApp(),
  );

  runApp(config);
}
