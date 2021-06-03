import 'package:flutter/widgets.dart';
import 'package:flutter_weather/app/app_localization.dart';

enum WindSpeedUnit {
  kmh,
  mph,
  ms,
}

extension WindSpeedUnitExtension on WindSpeedUnit {
  String get units {
    switch (this) {
      case WindSpeedUnit.kmh:
        return 'kmh';

      case WindSpeedUnit.ms:
        return 'ms';

      case WindSpeedUnit.mph:
      default:
        return 'mph';
    }
  }

  String getText(
    BuildContext context,
  ) {
    switch (this) {
      case WindSpeedUnit.kmh:
        return AppLocalizations.of(context)!.speedKmh;

      case WindSpeedUnit.ms:
        return AppLocalizations.of(context)!.speedMs;

      case WindSpeedUnit.mph:
      default:
        return AppLocalizations.of(context)!.speedMph;
    }
  }
}

WindSpeedUnit getWindSpeedUnit(
  String? windSpeedUnit,
) {
  switch (windSpeedUnit) {
    case 'kmh':
      return WindSpeedUnit.kmh;

    case 'ms':
      return WindSpeedUnit.ms;

    case 'mph':
    default:
      return WindSpeedUnit.mph;
  }
}
