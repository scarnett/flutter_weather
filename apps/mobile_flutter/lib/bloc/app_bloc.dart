import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_weather/app_prefs.dart';
import 'package:flutter_weather/app_service.dart';
import 'package:flutter_weather/enums/enums.dart';
import 'package:flutter_weather/enums/wind_speed_unit.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/models/models.dart';
import 'package:flutter_weather/theme.dart';
import 'package:flutter_weather/utils/common_utils.dart';
import 'package:flutter_weather/utils/date_utils.dart';
import 'package:flutter_weather/utils/device_utils.dart';
import 'package:flutter_weather/utils/geolocator_utils.dart';
import 'package:flutter_weather/utils/snackbar_utils.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/forecast_service.dart';
import 'package:flutter_weather/views/forecast/forecast_utils.dart';
import 'package:flutter_weather/views/settings/settings_utils.dart';
import 'package:http/http.dart' as http;
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sentry/sentry.dart';

part 'app_events.dart';
part 'app_state.dart';

class AppBloc extends HydratedBloc<AppEvent, AppState> {
  AppBloc() : super(AppState.initial());

  AppState get initialState => AppState.initial();

  @override
  Stream<AppState> mapEventToState(
    AppEvent event,
  ) async* {
    if (event is ToggleThemeMode) {
      yield _mapToggleThemeModeToStates(event);
    } else if (event is SetUpdatePeriod) {
      yield* _mapSetUpdatePeriodToStates(event);
    } else if (event is SetPushNotification) {
      yield* _mapSetPushNotificationToStates(event);
    } else if (event is SetThemeMode) {
      yield _mapSetThemeModeToStates(event);
    } else if (event is ToggleColorTheme) {
      yield _mapToggleColorThemeToStates(event);
    } else if (event is SetColorTheme) {
      yield _mapSetColorThemeToStates(event);
    } else if (event is SetTemperatureUnit) {
      yield* _mapSetTemperatureUnitToStates(event);
    } else if (event is SetWindSpeedUnit) {
      yield* _mapSetWindSpeedUnitToStates(event);
    } else if (event is SetChartType) {
      yield _mapSetChartTypeToStates(event);
    } else if (event is SetHourRange) {
      yield _mapSetHourRangeToStates(event);
    } else if (event is SelectedForecastIndex) {
      yield _mapSelectedForecastIndexToStates(event);
    } else if (event is AddForecast) {
      yield* _mapAddForecastToStates(event);
    } else if (event is UpdateForecast) {
      yield* _mapUpdateForecastToStates(event);
    } else if (event is RemovePrimaryStatus) {
      yield* _mapRemovePrimaryStatusToStates(event);
    } else if (event is RefreshForecast) {
      yield* _mapRefreshForecastToStates(event);
    } else if (event is DeleteForecast) {
      yield* _mapDeleteForecastToStates(event);
    } else if (event is ClearCRUDStatus) {
      yield _mapClearCRUDStatusToStates(event);
    } else if (event is SetActiveForecastId) {
      yield _mapSetActiveForecastIdToState(event);
    } else if (event is ClearActiveForecastId) {
      yield _mapClearActiveForecastIdToState(event);
    } else if (event is SetScrollDirection) {
      yield _mapScrollDirectionToState(event);
    }
  }

  AppState _mapToggleThemeModeToStates(
    ToggleThemeMode event,
  ) =>
      state.copyWith(
        themeMode: (state.themeMode == ThemeMode.dark)
            ? ThemeMode.light
            : ThemeMode.dark,
        colorTheme: false,
      );

  Stream<AppState> _mapSetUpdatePeriodToStates(
    SetUpdatePeriod event,
  ) async* {
    AppPrefs prefs = AppPrefs();
    prefs.updatePeriod = event.updatePeriod;

    String? deviceId = await getDeviceId();

    yield state.copyWith(
      updatePeriod: Nullable<UpdatePeriod?>(event.updatePeriod),
      pushNotification: (event.updatePeriod == null)
          ? Nullable<PushNotification?>(null)
          : (state.pushNotification == null)
              ? Nullable<PushNotification?>(PushNotification.off)
              : Nullable<PushNotification?>(state.pushNotification),
    );

    if (event.updatePeriod == null) {
      prefs.pushNotification = null;
      await removePushNotification(deviceId: deviceId);
    } else if (state.pushNotification == null) {
      prefs.pushNotification = PushNotification.off;
      await removePushNotification(deviceId: deviceId);
    } else if (prefs.pushNotification != PushNotification.off) {
      String? token = await FirebaseMessaging.instance.getToken();

      await savePushNotification(
        deviceId: deviceId,
        period: event.updatePeriod ?? null,
        pushNotification: state.pushNotification ?? null,
        pushNotificationExtras: state.pushNotificationExtras ?? null,
        units: state.units,
        fcmToken: token,
      );
    }

    if (event.callback != null) {
      event.callback!();
    }

    showSnackbar(
      event.context,
      AppLocalizations.of(event.context)!.updatePeriodUpdated,
    );
  }

  Stream<AppState> _mapSetPushNotificationToStates(
    SetPushNotification event,
  ) async* {
    AppPrefs prefs = AppPrefs();
    prefs.pushNotification = event.pushNotification;
    prefs.pushNotificationExtras = event.pushNotificationExtras;

    if ((prefs.pushNotification != null) &&
        (prefs.pushNotification != PushNotification.off)) {
      bool accessGranted = true;

      if (prefs.pushNotification == PushNotification.currentLocation) {
        accessGranted = await requestLocationPermission();
        if (accessGranted) {
          yield* _updatePushNotificationState(event);
        } else {
          showSnackbar(
            event.context,
            AppLocalizations.of(event.context)!.locationPermissionDenied,
          );

          if (state.pushNotification == PushNotification.currentLocation) {
            yield state.copyWith(
              pushNotification:
                  Nullable<PushNotification?>(PushNotification.off),
              pushNotificationExtras: Nullable<Map<String, dynamic>?>(null),
            );
          }
        }
      } else {
        yield* _updatePushNotificationState(event);
      }
    } else {
      yield* _updatePushNotificationState(event);
    }
  }

  Stream<AppState> _updatePushNotificationState(
    SetPushNotification event,
  ) async* {
    if (event.callback != null) {
      event.callback!();
    }

    yield state.copyWith(
      pushNotification: Nullable<PushNotification?>(event.pushNotification),
      pushNotificationExtras:
          Nullable<Map<String, dynamic>?>(event.pushNotificationExtras),
    );

    String? deviceId = await getDeviceId();

    if ((event.pushNotification != null) &&
        (event.pushNotification != PushNotification.off)) {
      String? token = await FirebaseMessaging.instance.getToken();

      await savePushNotification(
        deviceId: deviceId,
        period: state.updatePeriod,
        pushNotification: state.pushNotification,
        pushNotificationExtras: state.pushNotificationExtras,
        units: state.units,
        fcmToken: token,
      );
    } else {
      await removePushNotification(deviceId: deviceId);
    }

    showSnackbar(
      event.context,
      AppLocalizations.of(event.context)!.pushNotificationUpdated,
    );
  }

  AppState _mapSetThemeModeToStates(
    SetThemeMode event,
  ) =>
      state.copyWith(
        themeMode: event.themeMode,
        colorTheme: false,
      );

  AppState _mapToggleColorThemeToStates(
    ToggleColorTheme event,
  ) =>
      state.copyWith(
        colorTheme: !state.colorTheme,
      );

  AppState _mapSetColorThemeToStates(
    SetColorTheme event,
  ) =>
      state.copyWith(
        colorTheme: event.colorTheme,
      );

  Stream<AppState> _mapSetTemperatureUnitToStates(
    SetTemperatureUnit event,
  ) async* {
    AppPrefs prefs = AppPrefs();
    prefs.temperatureUnit = event.temperatureUnit;

    yield state.copyWith(
      units: state.units.copyWith(
        temperature: event.temperatureUnit,
      ),
    );

    if ((prefs.pushNotification != null) &&
        (prefs.pushNotification != PushNotification.off)) {
      String? deviceId = await getDeviceId();
      String? token = await FirebaseMessaging.instance.getToken();

      await savePushNotification(
        deviceId: deviceId,
        period: state.updatePeriod,
        pushNotification: state.pushNotification,
        pushNotificationExtras: state.pushNotificationExtras,
        units: state.units,
        fcmToken: token,
      );
    }
  }

  Stream<AppState> _mapSetWindSpeedUnitToStates(
    SetWindSpeedUnit event,
  ) async* {
    AppPrefs prefs = AppPrefs();
    prefs.windSpeedUnit = event.windSpeedUnit;

    yield state.copyWith(
      units: state.units.copyWith(
        windSpeed: event.windSpeedUnit,
      ),
    );

    if ((prefs.pushNotification != null) &&
        (prefs.pushNotification != PushNotification.off)) {
      String? deviceId = await getDeviceId();
      String? token = await FirebaseMessaging.instance.getToken();

      await savePushNotification(
        deviceId: deviceId,
        period: state.updatePeriod,
        pushNotification: state.pushNotification,
        pushNotificationExtras: state.pushNotificationExtras,
        units: state.units,
        fcmToken: token,
      );
    }
  }

  AppState _mapSetChartTypeToStates(
    SetChartType event,
  ) =>
      state.copyWith(
        chartType: event.chartType,
      );

  AppState _mapSetHourRangeToStates(
    SetHourRange event,
  ) {
    if (event.hourRange == state.hourRange) {
      return state;
    }

    return state.copyWith(
      hourRange: event.hourRange,
    );
  }

  AppState _mapSelectedForecastIndexToStates(
    SelectedForecastIndex event,
  ) {
    if (event.index == state.selectedForecastIndex) {
      return state;
    }

    return state.copyWith(
      selectedForecastIndex: event.index,
    );
  }

  Stream<AppState> _mapAddForecastToStates(
    AddForecast event,
  ) async* {
    yield state.copyWith(
      crudStatus: Nullable<CRUDStatus>(CRUDStatus.creating),
    );

    // TODO! sort
    List<Forecast> forecasts =
        List<Forecast>.from(state.forecasts) // Clone the existing state list
          ..add(event.forecast);

    yield state.copyWith(
      forecasts: forecasts,
      crudStatus: Nullable<CRUDStatus>(CRUDStatus.created),
      selectedForecastIndex: forecasts.indexWhere((Forecast forecast) =>
          (forecast.postalCode == event.forecast.postalCode)),
    );
  }

  Stream<AppState> _mapUpdateForecastToStates(
    UpdateForecast event,
  ) async* {
    yield state.copyWith(
      crudStatus: Nullable<CRUDStatus>(CRUDStatus.updating),
    );

    List<Forecast> forecasts = List<Forecast>.from(state.forecasts);
    Forecast forecast = state.forecasts
        .firstWhere((Forecast forecast) => forecast.id == event.forecastId);

    forecasts[state.selectedForecastIndex] = forecast.copyWith(
      id: event.forecastId,
      cityName: Nullable<String?>(event.forecastData['cityName']),
      postalCode: Nullable<String?>(event.forecastData['postalCode']),
      countryCode: Nullable<String?>(event.forecastData['countryCode']),
      primary: Nullable<bool?>(event.forecastData['primary']),
      lastUpdated: getNow(),
    );

    yield state.copyWith(
      activeForecastId: Nullable<String?>(null),
      forecasts: forecasts,
      crudStatus: Nullable<CRUDStatus>(CRUDStatus.updated),
    );

    add(
      RefreshForecast(
        event.context,
        forecasts[state.selectedForecastIndex],
        state.units.temperature,
      ),
    );
  }

  Stream<AppState> _mapRemovePrimaryStatusToStates(
    RemovePrimaryStatus event,
  ) async* {
    List<Forecast> forecasts = List<Forecast>.from(state.forecasts);
    int forecastIndex = state.forecasts
        .indexWhere((Forecast forecast) => forecast.id == event.forecast.id);

    forecasts[forecastIndex] = event.forecast.copyWith(
      primary: Nullable<bool>(false),
    );

    yield state.copyWith(
      forecasts: forecasts,
    );
  }

  Stream<AppState> _mapRefreshForecastToStates(
    RefreshForecast event,
  ) async* {
    yield state.copyWith(
      refreshStatus: Nullable<RefreshStatus>(RefreshStatus.refreshing),
    );

    Map<String, String?> lookupData = {
      'cityName': event.forecast.cityName,
      'postalCode': event.forecast.postalCode,
      'countryCode': event.forecast.countryCode,
    };

    try {
      http.Response forecastResponse = await tryLookupForecast(lookupData);
      if (forecastResponse.statusCode == 200) {
        List<Forecast> forecasts = List<Forecast>.from(state.forecasts);
        int forecastIndex = forecasts.indexWhere((Forecast forecast) =>
            forecast.postalCode == event.forecast.postalCode);

        if (forecastIndex == -1) {
          showSnackbar(
            event.context,
            AppLocalizations.of(event.context)!.refreshFailure,
          );

          yield state;
        } else {
          Forecast forecast =
              Forecast.fromJson(jsonDecode(forecastResponse.body));

          forecasts[forecastIndex] = forecast.copyWith(
            id: event.forecast.id,
            cityName: Nullable<String?>(event.forecast.cityName),
            postalCode: Nullable<String?>(event.forecast.postalCode),
            countryCode: Nullable<String?>(event.forecast.countryCode),
            primary: Nullable<bool?>(event.forecast.primary),
            lastUpdated: getNow(),
          );

          // TODO! premium
          http.Response forecastDetailsResponse = await fetchDetailedForecast(
            longitude: forecast.city!.coord!.lon!,
            latitude: forecast.city!.coord!.lat!,
          );

          if (forecastDetailsResponse.statusCode == 200) {
            forecasts[forecastIndex] = forecasts[forecastIndex].copyWith(
                details: Nullable<ForecastDetails?>(ForecastDetails.fromJson(
                    jsonDecode(forecastDetailsResponse.body))));
          }

          yield state.copyWith(
            forecasts: forecasts,
            refreshStatus: Nullable<RefreshStatus?>(null),
          );
        }
      } else {
        showSnackbar(
          event.context,
          AppLocalizations.of(event.context)!.refreshFailure,
        );

        yield state;
      }
    } on Exception catch (exception, stackTrace) {
      await Sentry.captureException(exception, stackTrace: stackTrace);

      showSnackbar(
        event.context,
        AppLocalizations.of(event.context)!.refreshFailure,
      );

      yield state;
    }
  }

  Stream<AppState> _mapDeleteForecastToStates(
    DeleteForecast event,
  ) async* {
    yield state.copyWith(
      crudStatus: Nullable<CRUDStatus>(CRUDStatus.deleting),
    );

    int _forecastIndex = state.forecasts
        .indexWhere((Forecast forecast) => forecast.id == event.forecastId);

    List<Forecast> _forecasts = state.forecasts..removeAt(_forecastIndex);

    yield state.copyWith(
      activeForecastId: Nullable<String?>(null),
      colorTheme: hasForecasts(_forecasts) ? state.colorTheme : false,
      forecasts: _forecasts,
      selectedForecastIndex: (state.selectedForecastIndex > 0)
          ? (state.selectedForecastIndex - 1)
          : 0,
      crudStatus: Nullable<CRUDStatus>(CRUDStatus.deleted),
    );
  }

  AppState _mapClearCRUDStatusToStates(
    ClearCRUDStatus event,
  ) =>
      state.copyWith(crudStatus: Nullable<CRUDStatus?>(null));

  AppState _mapSetActiveForecastIdToState(
    SetActiveForecastId event,
  ) =>
      state.copyWith(
        activeForecastId: Nullable<String?>(event.forecastId),
      );

  AppState _mapClearActiveForecastIdToState(
    ClearActiveForecastId event,
  ) =>
      state.copyWith(
        activeForecastId: Nullable<String?>(null),
      );

  AppState _mapScrollDirectionToState(
    SetScrollDirection event,
  ) {
    if (event.scrollDirection == state.scrollDirection) {
      return state;
    }

    return state.copyWith(
      scrollDirection: Nullable<ScrollDirection?>(event.scrollDirection),
    );
  }

  @override
  AppState fromJson(
    Map<String, dynamic> jsonData,
  ) =>
      AppState(
        updatePeriod: getPeriod(id: jsonData['updatePeriod']),
        pushNotification: getPushNotification(jsonData['pushNotification']),
        pushNotificationExtras: (jsonData['pushNotificationExtras'] != null)
            ? json.decode(jsonData['pushNotificationExtras'])
            : null,
        themeMode: getThemeMode(jsonData['themeMode']),
        colorTheme: jsonData['colorTheme'],
        units: Units.fromJson(jsonData['units']),
        chartType: getChartType(jsonData['chartType']),
        hourRange: getForecastHourRange(jsonData['hourRange']),
        forecasts: Forecast.fromJsonList(jsonData['forecasts']),
        selectedForecastIndex: jsonData['selectedForecastIndex'],
      );

  @override
  Map<String, dynamic> toJson(
    AppState state,
  ) =>
      {
        'updatePeriod': state.updatePeriod?.getInfo()?['id'],
        'pushNotification': state.pushNotification?.getInfo()?['id'],
        'pushNotificationExtras': state.pushNotificationExtras != null
            ? json.encode(state.pushNotificationExtras)
            : null,
        'themeMode': state.themeMode.toString(),
        'colorTheme': state.colorTheme,
        'units': state.units.toJson(),
        'chartType': state.chartType.toString(),
        'hourRange': state.hourRange.toString(),
        'forecasts': Forecast.toJsonList(state.forecasts),
        'selectedForecastIndex': state.selectedForecastIndex,
      };
}
