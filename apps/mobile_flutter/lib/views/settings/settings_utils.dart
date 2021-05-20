import 'package:flutter/widgets.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/views/settings/settings_enums.dart';

UpdatePeriod? getPeriod({
  BuildContext? context,
  String? id,
}) {
  if (id != null) {
    for (UpdatePeriod period in UpdatePeriod.values) {
      if (period.getInfo(context: context)?['id'] == id) {
        return period;
      }
    }
  }

  return null;
}

PushNotification? getPushNotification(
  String? id,
) {
  if (id != null) {
    for (PushNotification notification in PushNotification.values) {
      if (notification.getInfo()?['id'] == id) {
        return notification;
      }
    }
  }

  return null;
}

String getTitle(
  BuildContext context,
  num _currentPage,
) {
  if (_currentPage.toInt() == 1) {
    return AppLocalizations.of(context)!.updatePeriod;
  } else if (_currentPage.toInt() == 2) {
    return AppLocalizations.of(context)!.pushNotification;
  }

  return AppLocalizations.of(context)!.settings;
}

String? getPushNotificationText(
  BuildContext context,
  PushNotification? notification, {
  Map<String, dynamic>? extras,
}) {
  switch (notification) {
    case PushNotification.CURRENT_LOCATION:
    case PushNotification.SAVED_LOCATION:
      if (extras != null) {
        if (extras.containsKey('location')) {
          return extras['location']['name'];
        }
      }

      return null;

    case PushNotification.OFF:
      return notification?.getInfo(context: context)!['text'];

    default:
      return null;
  }
}
