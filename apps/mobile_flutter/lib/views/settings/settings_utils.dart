import 'package:flutter/widgets.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/views/settings/widgets/settings_enums.dart';

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
      return extras?['objectText'];

    case PushNotification.CURRENT_LOCATION:
    case PushNotification.OFF:
      return notification?.info!['text'];

    default:
      return null;
  }
}
