import 'package:background_fetch/background_fetch.dart';
import 'package:flutter_weather/notifications/notification_helper.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';

Future<void> initBackgroundFetchHeadlessTask(
  HeadlessTask task,
) async {
  String taskId = task.taskId;

  if (task.timeout) {
    BackgroundFetch.finish(taskId);
    return;
  }

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

  // TODO!
  pushLocalForecastNotification(Forecast());

  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // UpdatePeriod? updatePeriod = getPeriod(prefs.getString('updatePeriod'));
  // if (updatePeriod != null) {
  //   PushNotification? pushNotification =
  //       getPushNotification(prefs.getString('pushNotification'));

  //   if ((pushNotification != null) &&
  //       (pushNotification == PushNotification.SAVED_LOCATION)) {
  //     Map<String, dynamic>? pushNotificationExtras =
  //         json.decode(prefs.getString('pushNotificationExtras')!);

  //     String? notificationForecastId = pushNotificationExtras?['objectId'];
  //     // TODO! push notification here - notificationForecastId
  //     pushLocalForecastNotification(Forecast());
  //   } else {
  //     // TODO! push to current location
  //     pushLocalForecastNotification(Forecast());
  //   }
  // }
}

Future<void> initBackgroundFetch() async {
  int status = await BackgroundFetch.configure(
      BackgroundFetchConfig(
        minimumFetchInterval: 15, // TODO!
        stopOnTerminate: false,
        enableHeadless: true,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresStorageNotLow: false,
        requiresDeviceIdle: false,
        requiredNetworkType: NetworkType.ANY,
      ), (String taskId) async {
    print('[BackgroundFetch] Event received $taskId');
    // pushLocalForecastNotification(Forecast()); // TODO!
    BackgroundFetch.finish(taskId);
  }, (String taskId) async {
    print('[BackgroundFetch] TASK TIMEOUT taskId: $taskId');
    BackgroundFetch.finish(taskId);
  });

  print('[BackgroundFetch] configure success: $status');
}
