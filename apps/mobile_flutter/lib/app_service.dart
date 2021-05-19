import 'dart:convert';

import 'package:flutter_weather/config.dart';
import 'package:flutter_weather/enums.dart';
import 'package:flutter_weather/views/settings/settings_enums.dart';
import 'package:http/http.dart' as http;

Future<http.Response> savePushNotification({
  required String deviceId,
  UpdatePeriod? period,
  PushNotification? pushNotification,
  Map<String, dynamic>? pushNotificationExtras,
  TemperatureUnit? temperatureUnit,
  String? fcmToken,
}) async =>
    http.post(
      Uri.parse(AppConfig.instance.appPushNotificationsSave!),
      body: {
        'device': deviceId,
        'period': (period == null) ? null : period.getInfo()!['id'],
        'push_notification': (pushNotification == null)
            ? null
            : pushNotification.getInfo()!['id'],
        'push_notification_extras': (pushNotificationExtras == null)
            ? null
            : json.encode(pushNotificationExtras),
        'temperature_unit':
            (temperatureUnit == null) ? null : temperatureUnit.units,
        'fcm_token': (fcmToken == null) ? null : fcmToken,
      },
    );

Future<http.Response> removePushNotification({
  required String deviceId,
}) async =>
    http.post(
      Uri.parse(AppConfig.instance.appPushNotificationsRemove!),
      body: {
        'device': deviceId,
      },
    );
