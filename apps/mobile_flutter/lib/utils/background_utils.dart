import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/forecast_utils.dart';
import 'package:flutter_weather/views/settings/widgets/settings_enums.dart';

Future<void> initBackgroundFetch(
  BuildContext context,
) async {
  AppBloc bloc = context.read<AppBloc>();
  UpdatePeriod? updatePeriod = bloc.state.updatePeriod;
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
          requiredNetworkType: NetworkType.NONE,
        ), (String taskId) async {
      String? notificationForecastId;

      if ((bloc.state.pushNotification != null) &&
          (bloc.state.pushNotification == PushNotification.SAVED_LOCATION)) {
        notificationForecastId = bloc.state.pushNotificationExtras?['objectId'];
      }

      // Fetch forecasts
      for (Forecast forecast in bloc.state.forecasts) {
        if (canRefresh(bloc.state, forecast: forecast)) {
          bool push = (notificationForecastId == forecast.id);

          bloc.add(RefreshForecast(
            forecast,
            bloc.state.temperatureUnit,
            push: push,
          ));
        }
      }

      BackgroundFetch.finish(taskId);
    }, (String taskId) async {
      BackgroundFetch.finish(taskId);
    });
  }
}
