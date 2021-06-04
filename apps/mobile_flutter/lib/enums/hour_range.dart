import 'package:flutter/widgets.dart';
import 'package:flutter_weather/app/app_localization.dart';

enum HourRange {
  hours12,
  hours24,
  hours36,
  hours48,
}

extension HourRangeExtension on HourRange {
  int get hours {
    switch (this) {
      case HourRange.hours24:
        return 24;

      case HourRange.hours36:
        return 36;

      case HourRange.hours48:
        return 48;

      case HourRange.hours12:
      default:
        return 12;
    }
  }

  String getText(
    BuildContext context,
  ) {
    switch (this) {
      case HourRange.hours24:
        return AppLocalizations.of(context)!.hours24;

      case HourRange.hours36:
        return AppLocalizations.of(context)!.hours36;

      case HourRange.hours48:
        return AppLocalizations.of(context)!.hours48;

      case HourRange.hours12:
      default:
        return AppLocalizations.of(context)!.hours12;
    }
  }
}

HourRange getForecastHourRange(
  String? hourRange,
) {
  switch (hourRange) {
    case 'HourRange.hours24':
      return HourRange.hours24;

    case 'HourRange.hours36':
      return HourRange.hours36;

    case 'HourRange.hours48':
      return HourRange.hours48;

    case 'HourRange.hours12':
    default:
      return HourRange.hours12;
  }
}
