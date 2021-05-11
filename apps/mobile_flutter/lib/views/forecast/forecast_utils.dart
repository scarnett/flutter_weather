import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/config.dart';
import 'package:flutter_weather/enums.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/utils/common_utils.dart';
import 'package:flutter_weather/utils/date_utils.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:weather_icons/weather_icons.dart';

Uri getCurrentApiUri(
  Map<String, dynamic> params,
) {
  params['cnt'] = '1';
  params['appid'] = AppConfig.instance.openWeatherMapApiKey;

  return Uri.https(
    AppConfig.instance.openWeatherMapApiUri!,
    AppConfig.instance.openWeatherMapApiDailyForecastPath!,
    params.cast<String, String>(),
  );
}

Uri getDailyApiUri(
  Map<String, dynamic> params, {
  int count: 7, // TODO! premium
}) {
  if (!params.containsKey('cnt')) {
    params['cnt'] = count.toString();
  }

  params['appid'] = AppConfig.instance.openWeatherMapApiKey;

  return Uri.https(
    AppConfig.instance.openWeatherMapApiUri!,
    AppConfig.instance.openWeatherMapApiDailyForecastPath!,
    params.cast<String, String>(),
  );
}

num getTemperature(
  num? temperature,
  TemperatureUnit unit,
) {
  switch (unit) {
    case TemperatureUnit.fahrenheit:
      return (temperature! * (9 / 5) - 459.67).round();

    case TemperatureUnit.celsius:
      return (temperature! - 273.15).round();

    case TemperatureUnit.kelvin:
    default:
      return temperature!.round();
  }
}

Color? getTemperatureColor(
  num? temperature,
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

Animatable<Color?>? buildForecastColorSequence(
  List<Forecast> forecastList,
) {
  List<TweenSequenceItem<Color?>> colors = <TweenSequenceItem<Color>>[];

  if (forecastList.isNotEmpty) {
    forecastList.asMap().forEach((int index, Forecast forecast) {
      Color? nextColor;
      Color? thisColor = getTemperatureColor(forecast.list!.first.temp!.day);

      int nextForecastIndex = (index + 1);
      if (nextForecastIndex < forecastList.length) {
        Forecast nextForecast = forecastList[nextForecastIndex];
        nextColor = getTemperatureColor(nextForecast.list!.first.temp!.day);
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

  if (colors.isEmpty) {
    return null;
  }

  return TweenSequence<Color?>(colors);
}

String getLocationText(
  Forecast forecast, {
  bool includePostalCode: true,
}) {
  String text = '';

  if (!forecast.cityName.isNullOrEmpty()) {
    text += '${forecast.cityName}, ';
  } else if ((forecast.city != null) && !forecast.city!.name.isNullOrEmpty()) {
    text += '${forecast.city!.name}, ';
  }

  if (includePostalCode && !forecast.postalCode.isNullOrEmpty()) {
    text += '${forecast.postalCode!.toUpperCase()}, ';
  }

  if (!forecast.countryCode.isNullOrEmpty()) {
    text += forecast.countryCode!.toUpperCase();
  } else if ((forecast.city != null) &&
      !forecast.city!.country.isNullOrEmpty()) {
    text += forecast.city!.country!.toUpperCase();
  }

  String trimmedText = text.trim();
  if (trimmedText.endsWith(',')) {
    trimmedText = trimmedText.substring(0, (trimmedText.length - 1));
  }

  return trimmedText;
}

String getLocationCurrentForecastText(
  Forecast forecast,
  TemperatureUnit temperatureUnit,
) {
  String text = '';

  if ((forecast.list != null) && (forecast.list!.length > 0)) {
    ForecastDay currentDay = forecast.list!.first;
    text += currentDay.weather!.first.description!.capitalize();

    num currentTemp =
        getTemperature(currentDay.feelsLike!.day, temperatureUnit);

    num highTemp = getTemperature(currentDay.temp!.max, temperatureUnit);
    num lowTemp = getTemperature(currentDay.temp!.min, temperatureUnit);

    // TODO! i18n
    // TODO Custom message depending on temperature and conditions
    text += '. The current temperature is ' +
        '$currentTemp${temperatureUnit.unitSymbol}. The high for today is ' +
        '$highTemp${temperatureUnit.unitSymbol} with a low of ' +
        '$lowTemp${temperatureUnit.unitSymbol}.';
  }

  return text.trim();
}

String getUnitSymbol(
  TemperatureUnit? unit,
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

// @see https://openWeatherMap.org/weather-conditions
IconData getForecastIconData(
  String? iconCode,
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
  if (_currentPage.toInt() == 1) {
    return AppLocalizations.of(context)!.country;
  }

  return AppLocalizations.of(context)!.editForecast;
}

bool canRefresh(
  AppState state, {
  int? index,
  Forecast? forecast,
}) {
  if (index != null) {
    if (!forecastIndexExists(state.forecasts, index)) {
      return false;
    }

    Forecast selectedForecast = state.forecasts[index];
    return (selectedForecast.lastUpdated == null) ||
        getNextUpdateTime(selectedForecast.lastUpdated!).isBefore(getNow());
  } else if (forecast != null) {
    return (forecast.lastUpdated == null) ||
        getNextUpdateTime(forecast.lastUpdated!).isBefore(getNow());
  }

  return false;
}

DateTime getNextUpdateTime(
  DateTime dateTime,
) =>
    dateTime.add(Duration(
      milliseconds: AppConfig.instance.refreshTimeout!,
    ));

bool hasForecasts(
  List<Forecast>? forecasts,
) =>
    (forecasts != null) && forecasts.isNotEmpty;

bool forecastIndexExists(
  List<Forecast> forecasts,
  int? index,
) {
  if (hasForecasts(forecasts) && forecasts.asMap().containsKey(index)) {
    return true;
  }

  return false;
}
