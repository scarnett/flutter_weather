import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/app_prefs.dart';
import 'package:flutter_weather/enums.dart';
import 'package:flutter_weather/theme.dart';
import 'package:flutter_weather/utils/background_utils.dart';
import 'package:flutter_weather/utils/common_utils.dart';
import 'package:flutter_weather/utils/date_utils.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/forecast_service.dart';
import 'package:flutter_weather/views/forecast/forecast_utils.dart';
import 'package:flutter_weather/views/settings/settings_enums.dart';
import 'package:flutter_weather/views/settings/settings_utils.dart';
import 'package:http/http.dart' as http;
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';

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
      yield _mapSetPushNotificationToStates(event);
    } else if (event is SetThemeMode) {
      yield _mapSetThemeModeToStates(event);
    } else if (event is ToggleColorTheme) {
      yield _mapToggleColorThemeToStates(event);
    } else if (event is SetColorTheme) {
      yield _mapSetColorThemeToStates(event);
    } else if (event is SetTemperatureUnit) {
      yield _mapSetTemperatureUnitToStates(event);
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

    if (event.updatePeriod == null) {
      prefs.pushNotification = null;

      // Stop background fetch
      await stopBackgroundFetch();
    } else if (state.pushNotification == null) {
      prefs.pushNotification = PushNotification.OFF;
    }

    if ((prefs.pushNotification != null) &&
        (prefs.pushNotification != PushNotification.OFF)) {
      restartBackgroundFetch();
    }

    yield state.copyWith(
      updatePeriod: Nullable<UpdatePeriod?>(event.updatePeriod),
      pushNotification: (event.updatePeriod == null)
          ? Nullable<PushNotification?>(null)
          : (state.pushNotification == null)
              ? Nullable<PushNotification?>(PushNotification.OFF)
              : Nullable<PushNotification?>(state.pushNotification),
    );
  }

  AppState _mapSetPushNotificationToStates(
    SetPushNotification event,
  ) {
    AppPrefs prefs = AppPrefs();
    prefs.pushNotification = event.pushNotification;
    prefs.pushNotificationExtras = event.pushNotificationExtras;

    if ((prefs.pushNotification != null) &&
        (prefs.pushNotification != PushNotification.OFF)) {
      restartBackgroundFetch();
    }

    return state.copyWith(
      pushNotification: Nullable<PushNotification?>(event.pushNotification),
      pushNotificationExtras:
          Nullable<Map<String, dynamic>?>(event.pushNotificationExtras),
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

  AppState _mapSetTemperatureUnitToStates(
    SetTemperatureUnit event,
  ) {
    AppPrefs prefs = AppPrefs();
    prefs.temperatureUnit = event.temperatureUnit;

    return state.copyWith(
      temperatureUnit: event.temperatureUnit,
    );
  }

  AppState _mapSelectedForecastIndexToStates(
    SelectedForecastIndex event,
  ) =>
      state.copyWith(
        selectedForecastIndex: event.index,
      );

  Stream<AppState> _mapAddForecastToStates(
    AddForecast event,
  ) async* {
    yield state.copyWith(
      crudStatus: Nullable<CRUDStatus>(CRUDStatus.CREATING),
    );

    // TODO! sort
    List<Forecast> forecasts =
        List<Forecast>.from(state.forecasts) // Clone the existing state list
          ..add(event.forecast);

    yield state.copyWith(
      forecasts: forecasts,
      crudStatus: Nullable<CRUDStatus>(CRUDStatus.CREATED),
      selectedForecastIndex: forecasts.indexWhere((Forecast forecast) =>
          (forecast.postalCode == event.forecast.postalCode)),
    );
  }

  Stream<AppState> _mapUpdateForecastToStates(
    UpdateForecast event,
  ) async* {
    yield state.copyWith(
      crudStatus: Nullable<CRUDStatus>(CRUDStatus.UPDATING),
    );

    List<Forecast> forecasts = List<Forecast>.from(state.forecasts);
    Forecast forecast = state.forecasts
        .firstWhere((Forecast forecast) => forecast.id == event.forecastId);

    forecasts[state.selectedForecastIndex!] = forecast.copyWith(
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
      crudStatus: Nullable<CRUDStatus>(CRUDStatus.UPDATED),
    );

    add(RefreshForecast(
      forecasts[state.selectedForecastIndex!],
      state.temperatureUnit,
    ));
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
      refreshStatus: Nullable<RefreshStatus>(RefreshStatus.REFRESHING),
    );

    Map<String, String?> lookupData = {
      'cityName': event.forecast.cityName,
      'postalCode': event.forecast.postalCode,
      'countryCode': event.forecast.countryCode,
    };

    http.Response forecastResponse = await tryLookupForecast(lookupData);
    if (forecastResponse.statusCode == 200) {
      List<Forecast> forecasts = List<Forecast>.from(state.forecasts);
      int forecastIndex = forecasts.indexWhere(
        (Forecast forecast) => forecast.postalCode == event.forecast.postalCode,
      );

      if (forecastIndex == -1) {
        // TODO! snackbar error
      }

      Forecast forecast = Forecast.fromJson(jsonDecode(forecastResponse.body));
      forecasts[forecastIndex] = forecast.copyWith(
        id: event.forecast.id,
        cityName: Nullable<String?>(event.forecast.cityName),
        postalCode: Nullable<String?>(event.forecast.postalCode),
        countryCode: Nullable<String?>(event.forecast.countryCode),
        primary: Nullable<bool?>(event.forecast.primary),
        lastUpdated: getNow(),
      );

      yield state.copyWith(
        forecasts: forecasts,
        refreshStatus: Nullable<RefreshStatus?>(null),
      );
    } else {
      // TODO! snackbar error
    }
  }

  Stream<AppState> _mapDeleteForecastToStates(
    DeleteForecast event,
  ) async* {
    yield state.copyWith(
      crudStatus: Nullable<CRUDStatus>(CRUDStatus.DELETING),
    );

    int _forecastIndex = state.forecasts
        .indexWhere((Forecast forecast) => forecast.id == event.forecastId);

    List<Forecast> _forecasts = state.forecasts..removeAt(_forecastIndex);

    yield state.copyWith(
      activeForecastId: Nullable<String?>(null),
      colorTheme: hasForecasts(_forecasts) ? state.colorTheme : false,
      forecasts: _forecasts,
      selectedForecastIndex: (state.selectedForecastIndex! > 0)
          ? (state.selectedForecastIndex! - 1)
          : 0,
      crudStatus: Nullable<CRUDStatus>(CRUDStatus.DELETED),
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

  @override
  AppState fromJson(
    Map<String, dynamic> jsonData,
  ) =>
      AppState(
        updatePeriod: getPeriod(jsonData['updatePeriod']),
        pushNotification: getPushNotification(jsonData['pushNotification']),
        pushNotificationExtras: (jsonData['pushNotificationExtras'] != null)
            ? json.decode(jsonData['pushNotificationExtras'])
            : null,
        themeMode: getThemeMode(jsonData['themeMode']),
        colorTheme: jsonData['colorTheme'],
        temperatureUnit: getTemperatureUnit(jsonData['temperatureUnit']),
        forecasts: Forecast.fromJsonList(jsonData['forecasts']),
        selectedForecastIndex: jsonData['selectedForecastIndex'],
      );

  @override
  Map<String, dynamic> toJson(
    AppState state,
  ) =>
      {
        'updatePeriod': state.updatePeriod?.info?['id'],
        'pushNotification': state.pushNotification?.info?['id'],
        'pushNotificationExtras': state.pushNotificationExtras != null
            ? json.encode(state.pushNotificationExtras)
            : null,
        'themeMode': state.themeMode.toString(),
        'colorTheme': state.colorTheme,
        'temperatureUnit': state.temperatureUnit.toString(),
        'forecasts': Forecast.toJsonList(state.forecasts),
        'selectedForecastIndex': state.selectedForecastIndex,
      };
}
