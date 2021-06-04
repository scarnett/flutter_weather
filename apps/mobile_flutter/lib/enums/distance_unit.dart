import 'package:flutter/widgets.dart';
import 'package:flutter_weather/app/app_localization.dart';

enum DistanceUnit {
  km,
  mi,
}

extension DistanceUnitExtension on DistanceUnit {
  String get units {
    switch (this) {
      case DistanceUnit.km:
        return 'km';

      case DistanceUnit.mi:
      default:
        return 'mi';
    }
  }

  String getText(
    BuildContext context,
  ) {
    switch (this) {
      case DistanceUnit.km:
        return AppLocalizations.of(context)!.distanceKm;

      case DistanceUnit.mi:
      default:
        return AppLocalizations.of(context)!.distanceMi;
    }
  }
}

DistanceUnit getDistanceUnit(
  String? distanceUnit,
) {
  switch (distanceUnit) {
    case 'km':
      return DistanceUnit.km;

    case 'mi':
    default:
      return DistanceUnit.mi;
  }
}
