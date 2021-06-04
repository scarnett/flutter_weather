import 'package:flutter/widgets.dart';
import 'package:flutter_weather/app/app_localization.dart';

enum TemperatureUnit {
  celsius,
  fahrenheit,
  kelvin,
}

extension TemperatureUnitExtension on TemperatureUnit {
  String get units {
    switch (this) {
      case TemperatureUnit.celsius:
        return 'metric';

      case TemperatureUnit.kelvin:
        return 'standard';

      case TemperatureUnit.fahrenheit:
      default:
        return 'imperial';
    }
  }

  String get unitSymbol {
    switch (this) {
      case TemperatureUnit.celsius:
        return '\u00B0C';

      case TemperatureUnit.kelvin:
        return 'K';

      case TemperatureUnit.fahrenheit:
      default:
        return '\u00B0F';
    }
  }

  String getText(
    BuildContext context,
  ) {
    switch (this) {
      case TemperatureUnit.celsius:
        return AppLocalizations.of(context)!.celsius;

      case TemperatureUnit.kelvin:
        return AppLocalizations.of(context)!.kelvin;

      case TemperatureUnit.fahrenheit:
      default:
        return AppLocalizations.of(context)!.fahrenheit;
    }
  }
}

TemperatureUnit getTemperatureUnit(
  String? temperatureUnit,
) {
  switch (temperatureUnit) {
    case 'celsius':
      return TemperatureUnit.celsius;

    case 'kelvin':
      return TemperatureUnit.kelvin;

    case 'fahrenheit':
    default:
      return TemperatureUnit.fahrenheit;
  }
}
