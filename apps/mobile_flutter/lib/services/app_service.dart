import 'dart:convert';

import 'package:flutter_weather/config.dart';
import 'package:flutter_weather/enums/enums.dart';
import 'package:flutter_weather/models/models.dart';
import 'package:http/http.dart' as http;

Future<http.Response?> savePushNotification({
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
    Uri.parse(AppConfig.instance.appPushNotificationsSave!),
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

Future<http.Response?> removePushNotification({
  required String? deviceId,
}) async {
  if (deviceId == null) {
    return null;
  }

  return http.post(
    Uri.parse(AppConfig.instance.appPushNotificationsRemove!),
    body: {
      'device': deviceId,
    },
  );
}