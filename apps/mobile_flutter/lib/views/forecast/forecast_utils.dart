import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/env_config.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/model.dart';
import 'package:flutter_weather/utils/common_utils.dart';
import 'package:flutter_weather/utils/date_utils.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:weather_icons/weather_icons.dart';

Uri getApiUri(
  Map<String, dynamic> params, {
  int count: 10,
}) {
  if (!params.containsKey('cnt')) {
    params['cnt'] = count.toString();
  }

  params['appid'] = EnvConfig.OPENWEATHERMAP_API_KEY;

  return Uri.https(
    EnvConfig.OPENWEATHERMAP_API_URI,
    EnvConfig.OPENWEATHERMAP_API_DAILY_PATH,
    params.cast<String, String>(),
  );
}

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

Color getTemperatureColor(
  num temperature,
) {
  num _temperature = getTemperature(temperature, TemperatureUnit.fahrenheit);
  if (_temperature > 100) {
    return Colors.red[900];
  } else if ((_temperature > 90) && (_temperature <= 100)) {
    return Colors.red;
  } else if ((_temperature > 80) && (_temperature <= 90)) {
    return Colors.deepOrange;
  } else if ((_temperature > 70) && (_temperature <= 80)) {
    return Colors.orange;
  } else if ((_temperature > 60) && (_temperature <= 70)) {
    return Colors.amber;
  } else if ((_temperature > 50) && (_temperature <= 60)) {
    return Colors.yellow;
  } else if ((_temperature > 40) && (_temperature <= 50)) {
    return Colors.lightGreen;
  } else if ((_temperature > 30) && (_temperature <= 40)) {
    return Colors.green;
  } else if ((_temperature > 20) && (_temperature <= 30)) {
    return Colors.cyan;
  } else if ((_temperature > 10) && (_temperature <= 20)) {
    return Colors.blue;
  } else if ((_temperature > 0) && (_temperature <= 10)) {
    return Colors.indigo;
  } else if ((_temperature > -10) && (_temperature <= 0)) {
    return Colors.purple;
  } else if ((_temperature > -20) && (_temperature <= -10)) {
    return Colors.deepPurple;
  } else if ((_temperature > -30) && (_temperature <= -20)) {
    return Colors.deepPurple[100];
  }

  return Colors.blueGrey[50];
}

Animatable<Color> buildForecastColorSequence(
  List<Forecast> forecastList,
) {
  List<TweenSequenceItem<Color>> colors = List<TweenSequenceItem<Color>>();

  if ((forecastList != null) && forecastList.isNotEmpty) {
    forecastList.asMap().forEach((int index, Forecast forecast) {
      Color nextColor;
      Color thisColor = getTemperatureColor(forecast.list.first.temp.day);

      int nextForecastIndex = (index + 1);
      if (nextForecastIndex < forecastList.length) {
        Forecast nextForecast = forecastList[nextForecastIndex];
        nextColor = getTemperatureColor(nextForecast.list.first.temp.day);
      } else {
        nextColor = thisColor;
      }

      colors.add(TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          begin: thisColor,
          end: nextColor,
        ),
      ));
    });
  }

  if ((colors == null) || colors.isEmpty) {
    return null;
  }

  return TweenSequence<Color>(colors);
}

String getLocationText(
  Forecast forecast,
) {
  String text = '';

  if (!forecast.postalCode.isNullOrEmpty()) {
    text += '${forecast.postalCode.toUpperCase()}, ';
  }

  if (!forecast.countryCode.isNullOrEmpty()) {
    text += '${forecast.countryCode.toUpperCase()}';
  }

  return text.trim();
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

String getTitle(
  BuildContext context,
  num _currentPage,
) {
  if ((_currentPage != null) && (_currentPage.toInt() == 1)) {
    return AppLocalizations.of(context).country;
  }

  return AppLocalizations.of(context).editForecast;
}

bool canRefresh(
  AppState state,
) {
  if (!forecastIndexExists(state.forecasts, state.selectedForecastIndex)) {
    return false;
  }

  Forecast selectedForecast = state.forecasts[state.selectedForecastIndex];
  return (selectedForecast == null) ||
      (selectedForecast.lastUpdated == null) ||
      getNextUpdateTime(selectedForecast.lastUpdated).isBefore(getNow());
}

DateTime getNextUpdateTime(
  DateTime dateTime,
) =>
    dateTime.add(Duration(milliseconds: EnvConfig.REFRESH_TIMEOUT));

bool hasForecasts(
  List<Forecast> forecasts,
) =>
    (forecasts != null) && forecasts.isNotEmpty;

bool forecastIndexExists(
  List<Forecast> forecasts,
  int index,
) {
  if (hasForecasts(forecasts) && forecasts.asMap().containsKey(index)) {
    return true;
  }

  return false;
}
