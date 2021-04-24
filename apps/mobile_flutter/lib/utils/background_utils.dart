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
      // Fetch forecasts
      for (Forecast forecast in bloc.state.forecasts) {
        if (canRefresh(bloc.state, forecast: forecast)) {
          bloc.add(RefreshForecast(forecast, bloc.state.temperatureUnit));
        }
      }

      BackgroundFetch.finish(taskId);
    }, (String taskId) async {
      BackgroundFetch.finish(taskId);
    });
  }
}
