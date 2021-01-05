import 'package:flutter/cupertino.dart';
import 'package:flutter_weather/model.dart';
import 'package:weather_icons/weather_icons.dart';

num getTemperature(
  num temperature,
  TemperatureUnit unit,
) {
  switch (unit) {
    case TemperatureUnit.fahrenheit:
      return (temperature * (9 / 5) - 459.67).round();

    case TemperatureUnit.celsius:
      return (temperature - 273.15).round();

    case TemperatureUnit.kelvin:
    default:
      return temperature.round();
  }
}

String getUnitSymbol(
  TemperatureUnit unit,
) {
  switch (unit) {
    case TemperatureUnit.fahrenheit:
      return '\u2109';

    case TemperatureUnit.celsius:
      return '\u2103';

    case TemperatureUnit.kelvin:
      return '\u212A';

    default:
      return '\u00B0';
  }
}

// @see https://openweathermap.org/weather-conditions
IconData getForecastIconData(
  String iconCode,
) {
  switch (iconCode) {
    case '01d':
      return WeatherIcons.day_sunny;

    case '01n':
      return WeatherIcons.night_clear;

    case '02d':
      return WeatherIcons.day_cloudy;

    case '02n':
      return WeatherIcons.night_alt_cloudy;

    case '03d':
    case '03n':
      return WeatherIcons.cloud;

    case '04d':
    case '04n':
      return WeatherIcons.cloudy;

    case '09d':
      return WeatherIcons.day_showers;

    case '09n':
      return WeatherIcons.night_alt_showers;

    case '10d':
      return WeatherIcons.day_rain;

    case '10n':
      return WeatherIcons.night_rain;

    case '11d':
      return WeatherIcons.day_thunderstorm;

    case '11n':
      return WeatherIcons.night_alt_thunderstorm;

    case '13d':
      return WeatherIcons.day_snow;

    case '13n':
      return WeatherIcons.night_alt_snow;

    case '50d':
      return WeatherIcons.day_fog;

    case '50n':
      return WeatherIcons.night_fog;

    default:
      return WeatherIcons.day_sunny;
  }
}
