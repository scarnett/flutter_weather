import 'dart:convert';

import 'package:flutter_weather/app/app_config.dart';
import 'package:flutter_weather/enums/enums.dart';
import 'package:flutter_weather/models/models.dart';
import 'package:http/http.dart' as http;

Future<http.Response?> pushNotificationSave({
  required String? deviceId,
  UpdatePeriod? period,
  PushNotification? pushNotification,
  Map<String, dynamic>? pushNotificationExtras,
  Units? units,
  String? fcmToken,
}) async {
  if (deviceId == null) {
    return null;
  }

  return http.post(
    Uri.parse(AppConfig.instance.config.appPushNotificationsSave),
    body: {
      'device': deviceId,
      'period': (period == null) ? null : period.getInfo()!['id'],
      'pushNotification':
          (pushNotification == null) ? null : pushNotification.getInfo()!['id'],
      'pushNotificationExtras': (pushNotificationExtras == null)
          ? null
          : json.encode(pushNotificationExtras),
      'units': (units == null) ? null : json.encode(units.toJson()),
      'fcmToken': (fcmToken == null) ? null : fcmToken,
    },
  );
}

Future<http.Response?> pushNotificationRemove({
  required String? deviceId,
}) async {
  if (deviceId == null) {
    return null;
  }

  return http.post(
    Uri.parse(AppConfig.instance.config.appPushNotificationsRemove),
    body: {
      'device': deviceId,
    },
  );
}
