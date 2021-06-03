import 'package:flutter/widgets.dart';
import 'package:flutter_weather/localization.dart';

enum PressureUnit {
  hpa,
  inhg,
}

extension PressureUnitExtension on PressureUnit {
  String get units {
    switch (this) {
      case PressureUnit.hpa:
        return 'hpa';

      case PressureUnit.inhg:
      default:
        return 'inhg';
    }
  }

  String getText(
    BuildContext context,
  ) {
    switch (this) {
      case PressureUnit.hpa:
        return AppLocalizations.of(context)!.pressureHpa;

      case PressureUnit.inhg:
      default:
        return AppLocalizations.of(context)!.pressureInhg;
    }
  }
}

PressureUnit getPressureUnit(
  String? pressureUnit,
) {
  switch (pressureUnit) {
    case 'hpa':
      return PressureUnit.hpa;

    case 'inhg':
    default:
      return PressureUnit.inhg;
  }
}
