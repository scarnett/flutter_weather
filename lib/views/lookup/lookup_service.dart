import 'package:flutter_weather/env_config.dart';
import 'package:flutter_weather/views/lookup/bloc/lookup_bloc.dart';
import 'package:http/http.dart' as http;

Future<http.Response> tryLookupForecast(
  LookupForecast event,
) async =>
    http.get(EnvConfig.OPENWEATHERMAP_API_FORECAST_URL +
        '?zip=${event.postalCode},${event.countryCode.toLowerCase()}&' +
        'appid=${EnvConfig.OPENWEATHERMAP_API_KEY}');
