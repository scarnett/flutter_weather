import 'package:flutter/widgets.dart';
import 'package:flutter_weather/localization.dart';

enum UpdatePeriod {
  hour1,
  hour2,
  hour3,
  hour4,
  hour5,
}

extension UpdatePeriodExtension on UpdatePeriod {
  Map<String, dynamic>? getInfo({
    BuildContext? context,
  }) {
    switch (this) {
      case UpdatePeriod.hour1:
        return {
          'id': '1hr',
          'text': (context == null)
              ? '1 hour'
              : AppLocalizations.of(context)!.updatePeriod1hr,
          'minutes': 60,
        };

      case UpdatePeriod.hour2:
        return {
          'id': '2hrs',
          'text': (context == null)
              ? '2 hours'
              : AppLocalizations.of(context)!.updatePeriod2hr,
          'minutes': 120,
        };

      case UpdatePeriod.hour3:
        return {
          'id': '3hrs',
          'text': (context == null)
              ? '3 hours'
              : AppLocalizations.of(context)!.updatePeriod3hr,
          'minutes': 180,
        };

      case UpdatePeriod.hour4:
        return {
          'id': '4hrs',
          'text': (context == null)
              ? '4 hours'
              : AppLocalizations.of(context)!.updatePeriod4hr,
          'minutes': 240,
        };

      case UpdatePeriod.hour5:
        return {
          'id': '5hrs',
          'text': (context == null)
              ? '5 hours'
              : AppLocalizations.of(context)!.updatePeriod5hr,
          'minutes': 300,
        };

      default:
        return null;
    }
  }
}
