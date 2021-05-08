import 'dart:convert';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter_weather/views/settings/settings_enums.dart';
import 'package:flutter_weather/views/settings/settings_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initBackgroundFetchHeadlessTask(
  HeadlessTask task,
) async {
  String taskId = task.taskId;

  if (task.timeout) {
    BackgroundFetch.finish(taskId);
    return;
  }

  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (taskId == 'flutter_background_fetch') {
    BackgroundFetch.scheduleTask(
      TaskConfig(
        taskId: 'io.flutter_weather.notification',
        delay: 5000,
        periodic: false,
        forceAlarmManager: false,
        stopOnTerminate: false,
        enableHeadless: true,
      ),
    );
  }

  UpdatePeriod? updatePeriod = getPeriod(prefs.getString('updatePeriod'));
  if (updatePeriod != null) {
    await BackgroundFetch.configure(
        BackgroundFetchConfig(
          minimumFetchInterval: 15, // TODO! updatePeriod.info!['minutes'],
          stopOnTerminate: false,
          enableHeadless: true,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresStorageNotLow: false,
          requiresDeviceIdle: false,
          requiredNetworkType: NetworkType.NONE,
        ), (String taskId) async {
      String? notificationForecastId;
      PushNotification? pushNotification =
          getPushNotification(prefs.getString('pushNotification'));

      if ((pushNotification != null) &&
          (pushNotification == PushNotification.SAVED_LOCATION)) {
        Map<String, dynamic>? pushNotificationExtras =
            json.decode(prefs.getString('pushNotificationExtras')!);

        notificationForecastId = pushNotificationExtras?['objectId'];
      }

      // TODO! push notification here - notificationForecastId

      BackgroundFetch.finish(taskId);
    }, (String taskId) async {
      BackgroundFetch.finish(taskId);
    });
  }
}
