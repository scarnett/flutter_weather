import 'dart:convert';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter_weather/app_prefs.dart';
import 'package:flutter_weather/enums.dart';
import 'package:flutter_weather/notifications/notification_helper.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/forecast_service.dart';
import 'package:flutter_weather/views/settings/settings_enums.dart';
import 'package:flutter_weather/views/settings/settings_utils.dart';
import 'package:http/http.dart' as http;
import 'package:sentry/sentry.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String backgroundFetchTaskId = 'io.flutter_weather.notification';

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
        taskId: backgroundFetchTaskId,
        delay: 5000,
        periodic: false,
        forceAlarmManager: false,
        stopOnTerminate: false,
        enableHeadless: true,
      ),
    );
  }
}

Future<void> initBackgroundFetch() async {
  SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
  UpdatePeriod? updatePeriod = getPeriod(sharedPrefs.getString('updatePeriod'));
  if (updatePeriod != null) {
    await BackgroundFetch.configure(
        BackgroundFetchConfig(
          minimumFetchInterval: updatePeriod.info!['minutes'],
          stopOnTerminate: false,
          enableHeadless: true,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresStorageNotLow: false,
          requiresDeviceIdle: false,
          requiredNetworkType: NetworkType.ANY,
        ), (String taskId) async {
      AppPrefs appPrefs = AppPrefs();

      // Dont push notifications if the app is in the foreground
      if (appPrefs.appState > 0) {
        PushNotification? pushNotification =
            getPushNotification(sharedPrefs.getString('pushNotification'));

        if (pushNotification != null) {
          switch (pushNotification) {
            case PushNotification.SAVED_LOCATION:
            case PushNotification.CURRENT_LOCATION:
              Map<String, dynamic>? pushNotificationExtras =
                  json.decode(sharedPrefs.getString('pushNotificationExtras')!);

              if (pushNotificationExtras != null) {
                Map<String, dynamic> forecastInfo =
                    pushNotificationExtras['location'];

                try {
                  http.Response forecastResponse =
                      await fetchCurrentForecastByCoords(
                    longitude: forecastInfo['longitude'],
                    latitude: forecastInfo['latitude'],
                  );

                  if (forecastResponse.statusCode == 200) {
                    // TODO! check for api errors

                    pushCurrentForecastNotification(
                      Forecast.fromJson(jsonDecode(forecastResponse.body)),
                      getTemperatureUnit(
                          sharedPrefs.getString('temperatureUnit')),
                    );
                  }
                } on Exception catch (exception, stackTrace) {
                  await Sentry.captureException(exception,
                      stackTrace: stackTrace);
                }
              }

              break;

            default:
              break;
          }
        }
      }

      BackgroundFetch.finish(taskId);
    }, (String taskId) async {
      BackgroundFetch.finish(taskId);
    });
  }
}

Future<void> restartBackgroundFetch() async {
  await BackgroundFetch.stop(backgroundFetchTaskId);
  await initBackgroundFetch();
}

Future<void> stopBackgroundFetch() async {
  await BackgroundFetch.stop(backgroundFetchTaskId);
}
