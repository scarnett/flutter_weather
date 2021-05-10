import 'package:flutter/widgets.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/forecast_utils.dart';
import 'package:flutter_weather/views/settings/settings_enums.dart';

UpdatePeriod? getPeriod(
  String? id,
) {
  if (id != null) {
    for (UpdatePeriod period in UpdatePeriod.values) {
      if (period.info?['id'] == id) {
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
      if (notification.info?['id'] == id) {
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
  PushNotification? notification, {
  Map<String, dynamic>? extras,
}) {
  switch (notification) {
    case PushNotification.SAVED_LOCATION:
      if (extras != null) {
        if (extras.containsKey('forecast')) {
          return getLocationText(Forecast.fromJson(extras['forecast']));
        }
      }

      return null;

    case PushNotification.CURRENT_LOCATION:
    case PushNotification.OFF:
      return notification?.info!['text'];

    default:
      return null;
  }
}
