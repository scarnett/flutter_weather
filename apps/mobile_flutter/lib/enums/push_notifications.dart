import 'package:flutter/widgets.dart';
import 'package:flutter_weather/localization.dart';

enum PushNotification {
  OFF,
  CURRENT_LOCATION,
  SAVED_LOCATION,
}

extension PushNotificationExtension on PushNotification {
  Map<String, dynamic>? getInfo({
    BuildContext? context,
  }) {
    switch (this) {
      case PushNotification.CURRENT_LOCATION:
        return {
          'id': 'current_location',
          'text': (context == null)
              ? 'Current Location'
              : AppLocalizations.of(context)!.pushNotificationCurrent,
          'subText': (context == null)
              ? 'Tap to update'
              : AppLocalizations.of(context)!.pushNotificationCurrentTap,
        };

      case PushNotification.SAVED_LOCATION:
        return {
          'id': 'saved_location',
          'text': (context == null)
              ? 'Saved Locations'
              : AppLocalizations.of(context)!.pushNotificationSaved,
        };

      case PushNotification.OFF:
      default:
        return {
          'id': 'off',
          'text': (context == null)
              ? 'Off'
              : AppLocalizations.of(context)!.pushNotificationOff,
        };
    }
  }
}
