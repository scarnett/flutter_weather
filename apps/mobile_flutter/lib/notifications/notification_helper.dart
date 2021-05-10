import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_weather/enums.dart';
import 'package:flutter_weather/notifications/notification_model.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/forecast_utils.dart';
import 'package:rxdart/subjects.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

NotificationAppLaunchDetails? notificationAppLaunchDetails;

final BehaviorSubject<WeatherNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<WeatherNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

Future<void> initLocalNotifications() async {
  notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
    onDidReceiveLocalNotification: (
      int id,
      String? title,
      String? body,
      String? payload,
    ) async {
      didReceiveLocalNotificationSubject.add(
        WeatherNotification(
          id: id,
          title: title!,
          body: body!,
          payload: payload!,
        ),
      );
    },
  );

  InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onSelectNotification: (String? payload) async {
      if (payload != null) {
        debugPrint('notification payload: ' + payload);
      }

      selectNotificationSubject.add(payload!);
    },
  );

  await requestIOSPermissions();
}

Future<void> pushCurrentForecastNotification(
  Forecast forecast,
  TemperatureUnit temperatureUnit,
) async {
  String channelName = getLocationText(forecast);
  String channelDescription =
      getLocationCurrentForecastText(forecast, temperatureUnit);

  final BigTextStyleInformation bigTextStyleInfo = BigTextStyleInformation(
    channelDescription,
    contentTitle: channelName,
    htmlFormatContentTitle: true,
  );

  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'flutterWeatherForecast',
    channelName,
    channelDescription,
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
    styleInformation: bigTextStyleInfo,
    icon: 'app_icon',
  );

  IOSNotificationDetails iOSPlatformChannelSpecifics = IOSNotificationDetails();
  NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics,
  );

  await flutterLocalNotificationsPlugin.show(
    0,
    channelName,
    channelDescription,
    platformChannelSpecifics,
    payload: 'notification_tapped',
  );
}

Future<void> turnOffNotification() async {
  await flutterLocalNotificationsPlugin.cancelAll();
}

Future<void> requestIOSPermissions() async {
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
}
