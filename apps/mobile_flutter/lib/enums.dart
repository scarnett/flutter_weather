import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_weather/localization.dart';

enum Flavor {
  dev,
  tst,
  prod,
}

enum TemperatureUnit {
  kelvin,
  celsius,
  fahrenheit,
}

enum ChartType {
  line,
  bar,
}

enum ForecastHourRange {
  hours12,
  hours24,
  hours36,
  hours48,
}

extension TemperatureUnitExtension on TemperatureUnit {
  String get units {
    switch (this) {
      case TemperatureUnit.kelvin:
        return 'standard';

      case TemperatureUnit.celsius:
        return 'metric';

      case TemperatureUnit.fahrenheit:
      default:
        return 'imperial';
    }
  }

  String get unitSymbol {
    switch (this) {
      case TemperatureUnit.kelvin:
        return 'K';

      case TemperatureUnit.celsius:
        return '\u00B0C';

      case TemperatureUnit.fahrenheit:
      default:
        return '\u00B0F';
    }
  }
}

TemperatureUnit getTemperatureUnit(
  String? temperatureUnit,
) {
  switch (temperatureUnit) {
    case 'TemperatureUnit.kelvin':
      return TemperatureUnit.kelvin;

    case 'TemperatureUnit.celsius':
      return TemperatureUnit.celsius;

    case 'TemperatureUnit.fahrenheit':
    default:
      return TemperatureUnit.fahrenheit;
  }
}

ChartType getChartType(
  String? chartType,
) {
  switch (chartType) {
    case 'ChartType.bar':
      return ChartType.bar;

    case 'ChartType.line':
    default:
      return ChartType.line;
  }
}

extension ForecastHourRangeExtension on ForecastHourRange {
  int get hours {
    switch (this) {
      case ForecastHourRange.hours24:
        return 24;

      case ForecastHourRange.hours36:
        return 36;

      case ForecastHourRange.hours48:
        return 48;

      case ForecastHourRange.hours12:
      default:
        return 12;
    }
  }

  String getText(
    BuildContext context,
  ) {
    switch (this) {
      case ForecastHourRange.hours24:
        return AppLocalizations.of(context)!.hours24;

      case ForecastHourRange.hours36:
        return AppLocalizations.of(context)!.hours36;

      case ForecastHourRange.hours48:
        return AppLocalizations.of(context)!.hours48;

      case ForecastHourRange.hours12:
      default:
        return AppLocalizations.of(context)!.hours12;
    }
  }
}

extension ThemeModeExtension on ThemeMode {
  String getText(
    BuildContext context,
  ) {
    switch (this) {
      case ThemeMode.light:
        return AppLocalizations.of(context)!.light;

      case ThemeMode.dark:
      default:
        return AppLocalizations.of(context)!.dark;
    }
  }
}

ForecastHourRange getForecastHourRange(
  String? forecastHourRange,
) {
  switch (forecastHourRange) {
    case 'ForecastHourRange.hours24':
      return ForecastHourRange.hours24;

    case 'ForecastHourRange.hours36':
      return ForecastHourRange.hours36;

    case 'ForecastHourRange.hours48':
      return ForecastHourRange.hours48;

    case 'ForecastHourRange.hours12':
    default:
      return ForecastHourRange.hours12;
  }
}

enum CRUDStatus {
  CREATING,
  CREATED,
  READING,
  READ,
  UPDATING,
  UPDATED,
  DELETING,
  DELETED,
}
