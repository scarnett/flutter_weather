import 'package:flutter/widgets.dart';
import 'package:flutter_weather/localization.dart';

enum WindSpeedUnit {
  mph,
  kmh,
  ms,
}

extension WindSpeedUnitExtension on WindSpeedUnit {
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
    case 'WindSpeedUnit.kmh':
      return WindSpeedUnit.kmh;

    case 'WindSpeedUnit.ms':
      return WindSpeedUnit.ms;

    case 'WindSpeedUnit.mph':
    default:
      return WindSpeedUnit.mph;
  }
}
