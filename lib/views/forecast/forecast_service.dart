import 'package:flutter_weather/env_config.dart';
import 'package:flutter_weather/model.dart';
import 'package:http/http.dart' as http;

Future<http.Response> tryLookupForecast(
  String postalCode,
  String countryCode,
  TemperatureUnit temperatureUnit,
) async =>
    http.get(EnvConfig.OPENWEATHERMAP_API_FORECAST_URL +
        '?zip=$postalCode,${countryCode.toLowerCase()}' +
        '&units=${temperatureUnit.units}' +
        '&appid=${EnvConfig.OPENWEATHERMAP_API_KEY}');
