import 'package:flutter/widgets.dart';
import 'package:flutter_weather/localization.dart';

enum SpeedUnit {
  mph,
  kmh,
  ms,
}

extension SpeedUnitExtension on SpeedUnit {
  String getText(
    BuildContext context,
  ) {
    switch (this) {
      case SpeedUnit.kmh:
        return AppLocalizations.of(context)!.speedKmh;

      case SpeedUnit.ms:
        return AppLocalizations.of(context)!.speedMs;

      case SpeedUnit.mph:
      default:
        return AppLocalizations.of(context)!.speedMph;
    }
  }
}

SpeedUnit getSpeedUnit(
  String? speedUnit,
) {
  switch (speedUnit) {
    case 'SpeedUnit.kmh':
      return SpeedUnit.kmh;

    case 'SpeedUnit.ms':
      return SpeedUnit.ms;

    case 'SpeedUnit.mph':
    default:
      return SpeedUnit.mph;
  }
}
