import 'package:flutter/material.dart';
import 'package:flutter_weather/app/app_config.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/enums/enums.dart';
import 'package:flutter_weather/forecast/forecast_extension.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/models/models.dart';
import 'package:flutter_weather/utils/common_utils.dart';
import 'package:flutter_weather/utils/date_utils.dart';
import 'package:weather_icons/weather_icons.dart';

Uri getDetailedUri(
  Map<String, dynamic> params,
) {
  params['appid'] = AppConfig.instance.openWeatherMapApiKey;

  return Uri.https(
    AppConfig.instance.openWeatherMapApiUri!,
    AppConfig.instance.openWeatherMapApiOneCallPath!,
    params.cast<String, String>(),
  );
}

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

Map<String, dynamic> buildLookupParams(
  Map<String, dynamic> lookupData,
) {
  Map<String, dynamic> params = Map<String, dynamic>();

  if (lookupData.containsKey('postalCode') &&
      (lookupData['postalCode'] != null) &&
      !(lookupData['postalCode'] as String).isNullOrEmpty()) {
    if (lookupData.containsKey('countryCode') &&
        (lookupData['countryCode'] != null) &&
        !(lookupData['countryCode'] as String).isNullOrEmpty()) {
      params['zip'] =
          '${lookupData['postalCode']},${lookupData['countryCode'].toLowerCase()}';
    } else {
      params['zip'] = lookupData['postalCode'];
    }
  } else if (lookupData.containsKey('cityName') &&
      (lookupData['cityName'] != null) &&
      !(lookupData['cityName'] as String).isNullOrEmpty()) {
    String query = lookupData['cityName'];

    if (lookupData.containsKey('stateCode') &&
        (lookupData['stateCode'] != null) &&
        !(lookupData['stateCode'] as String).isNullOrEmpty()) {
      query += ',${lookupData['stateCode']}';
    }

    if (lookupData.containsKey('countryCode') &&
        (lookupData['countryCode'] != null) &&
        !(lookupData['countryCode'] as String).isNullOrEmpty()) {
      query += ',${lookupData['countryCode']}';
    }

    params['q'] = query;
  }

  return params;
}

num getTemperature(
  num? temperature,
  TemperatureUnit unit,
) {
  if (temperature == null) {
    return 0;
  }

  switch (unit) {
    case TemperatureUnit.fahrenheit:
      return (temperature * (9 / 5) - 459.67).round();

    case TemperatureUnit.celsius:
      return (temperature - 273.15).round();

    case TemperatureUnit.kelvin:
    default:
      return temperature.toDouble().formatDecimal();
  }
}

String getTemperatureStr(
  num temperature,
  TemperatureUnit unit,
) =>
    '${temperature.round()}${getTemperatureUnitStr(unit)}';

Color getTemperatureColor(
  num temperature,
) {
  if (temperature > 100) {
    return Colors.red[900]!;
  } else if ((temperature > 90) && (temperature <= 100)) {
    return Colors.red;
  } else if ((temperature > 80) && (temperature <= 90)) {
    return Colors.deepOrange;
  } else if ((temperature > 70) && (temperature <= 80)) {
    return Colors.orange;
  } else if ((temperature > 60) && (temperature <= 70)) {
    return Colors.amber;
  } else if ((temperature > 50) && (temperature <= 60)) {
    return Colors.yellow;
  } else if ((temperature > 40) && (temperature <= 50)) {
    return Colors.lightGreen;
  } else if ((temperature > 30) && (temperature <= 40)) {
    return Colors.green;
  } else if ((temperature > 20) && (temperature <= 30)) {
    return Colors.cyan;
  } else if ((temperature > 10) && (temperature <= 20)) {
    return Colors.blue;
  } else if ((temperature > 0) && (temperature <= 10)) {
    return Colors.indigo;
  } else if ((temperature > -10) && (temperature <= 0)) {
    return Colors.purple;
  } else if ((temperature > -20) && (temperature <= -10)) {
    return Colors.deepPurple;
  } else if ((temperature > -30) && (temperature <= -20)) {
    return Colors.deepPurple[100]!;
  }

  return Colors.blueGrey[50]!;
}

String getTemperatureUnitStr(
  TemperatureUnit unit,
) {
  switch (unit) {
    case TemperatureUnit.celsius:
      return '°C';

    case TemperatureUnit.kelvin:
      return ' K';

    case TemperatureUnit.fahrenheit:
    default:
      return '°F';
  }
}

num getWindSpeed(
  num? windSpeed,
  WindSpeedUnit unit,
) {
  if (windSpeed == null) {
    return 0;
  }

  switch (unit) {
    case WindSpeedUnit.kmh:
      return (windSpeed * 1.609344).formatDecimal(decimals: 1);

    case WindSpeedUnit.ms:
      return (windSpeed / 2.2369362920544).formatDecimal(decimals: 1);

    case WindSpeedUnit.mph:
    default:
      return windSpeed.round();
  }
}

String getWindSpeedText(
  BuildContext context,
  num? windSpeed,
  WindSpeedUnit unit,
) {
  if (windSpeed == null) {
    return '0 ${unit.getText(context)}';
  }

  return '${getWindSpeed(windSpeed, unit)} ${unit.getText(context)}';
}

num getPressure(
  num? pressure,
  PressureUnit unit,
) {
  if (pressure == null) {
    return 0;
  }

  switch (unit) {
    case PressureUnit.inhg:
      return (pressure / 33.863886666667).formatDecimal(decimals: 2);

    case PressureUnit.hpa:
    default:
      return pressure.round();
  }
}

num getDistance(
  num? distance,
  DistanceUnit unit,
) {
  if (distance == null) {
    return 0;
  }

  switch (unit) {
    case DistanceUnit.km:
      return (distance * 0.001).formatDecimal(decimals: 2);

    case DistanceUnit.mi:
    default:
      return (distance * 0.00062137).formatDecimal(decimals: 2);
  }
}

String getPressureText(
  BuildContext context,
  num? pressure,
  PressureUnit unit,
) {
  if (pressure == null) {
    return '0 ${unit.getText(context)}';
  }

  return '${getPressure(pressure, unit)} ${unit.getText(context)}';
}

Animatable<Color?>? buildForecastColorSequence(
  List<Forecast> forecastList,
) {
  List<TweenSequenceItem<Color?>> colors = <TweenSequenceItem<Color?>>[];

  if (forecastList.isNotEmpty) {
    forecastList.asMap().forEach((int index, Forecast forecast) {
      Color? nextColor;
      Color? thisColor = forecast.getTemperatureColor();

      int nextForecastIndex = (index + 1);
      if (nextForecastIndex < forecastList.length) {
        Forecast nextForecast = forecastList[nextForecastIndex];
        nextColor = nextForecast.getTemperatureColor();
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

String getHumidity(
  num? humidity,
) {
  if (humidity == null) {
    return '0%';
  }

  return '${humidity.toDouble().round()}%';
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

double getScrollProgress({
  required double shrinkOffset,
  required double maxExtent,
  required double minExtent,
  double speed: 1.0,
  double clampUpper: 1.0,
  double clampLower: 0.0,
}) =>
    ((shrinkOffset * speed) / (maxExtent - minExtent))
        .clamp(clampLower, clampUpper);

double getScrollScale({
  required double shrinkOffset,
  required double maxExtent,
  required double minExtent,
  double factor: 4.0,
}) {
  double position = (getScrollProgress(
        shrinkOffset: shrinkOffset,
        maxExtent: maxExtent,
        minExtent: minExtent,
      ) /
      factor);

  return (1.0 - position);
}

/// Return wind direction relative to plane heading
double getWindDirection({
  required num windDirection,
  num? heading,
}) {
  if (heading == null) {
    return windDirection.toDouble();
  }

  return (((windDirection - heading + 180) % 360) - 180);
}

String? formatHour({
  int? dateTime,
  String format: 'h:mm',
}) {
  if (dateTime != null) {
    DateTime dt = epochToDateTime(dateTime);
    String? formatted = formatDateTime(date: dt, format: format);
    return formatted;
  }

  return null;
}
