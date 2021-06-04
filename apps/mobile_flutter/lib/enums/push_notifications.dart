import 'package:flutter/widgets.dart';
import 'package:flutter_weather/app/app_localization.dart';

enum PushNotification {
  off,
  currentLocation,
  savedLocation,
}

extension PushNotificationExtension on PushNotification {
  Map<String, dynamic>? getInfo({
    BuildContext? context,
  }) {
    switch (this) {
      case PushNotification.currentLocation:
        return {
          'id': 'current_location',
          'text': (context == null)
              ? 'Current Location'
              : AppLocalizations.of(context)!.pushNotificationCurrent,
          'subText': (context == null)
              ? 'Tap to update'
              : AppLocalizations.of(context)!.pushNotificationCurrentTap,
        };

      case PushNotification.savedLocation:
        return {
          'id': 'saved_location',
          'text': (context == null)
              ? 'Saved Locations'
              : AppLocalizations.of(context)!.pushNotificationSaved,
        };

      case PushNotification.off:
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
