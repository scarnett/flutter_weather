import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_weather/bloc/app_events.dart';
import 'package:flutter_weather/bloc/app_state.dart';
import 'package:flutter_weather/model.dart';
import 'package:flutter_weather/theme.dart';
import 'package:flutter_weather/utils/common_utils.dart';
import 'package:flutter_weather/utils/date_utils.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/forecast_service.dart';
import 'package:http/http.dart' as http;
import 'package:hydrated_bloc/hydrated_bloc.dart';

class AppBloc extends HydratedBloc<AppEvent, AppState> {
  AppBloc() : super(AppState.initial());

  AppState get initialState => AppState.initial();

  @override
  Stream<AppState> mapEventToState(
    AppEvent event,
  ) async* {
    if (event is ToggleThemeMode) {
      yield _mapToggleThemeModeToStates(event);
    } else if (event is SetThemeMode) {
      yield _mapSetThemeModeToStates(event);
    } else if (event is SetTemperatureUnit) {
      yield _mapSetTemperatureUnitToStates(event);
    } else if (event is SelectedForecastIndex) {
      yield _mapSelectedForecastIndexToStates(event);
    } else if (event is AddForecast) {
      yield* _mapAddForecastToStates(event);
    } else if (event is RefreshForecast) {
      yield* _mapRefreshForecastToStates(event);
    } else if (event is ClearCRUDStatus) {
      yield _mapClearCRUDStatusToStates(event);
    }
  }

  AppState _mapToggleThemeModeToStates(
    ToggleThemeMode event,
  ) =>
      state.copyWith(
        themeMode: (state.themeMode == ThemeMode.dark)
            ? ThemeMode.light
            : ThemeMode.dark,
      );

  AppState _mapSetThemeModeToStates(
    SetThemeMode event,
  ) =>
      state.copyWith(
        themeMode: event.themeMode,
      );

  AppState _mapSetTemperatureUnitToStates(
    SetTemperatureUnit event,
  ) =>
      state.copyWith(
        temperatureUnit: event.temperatureUnit,
      );

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
    List<Forecast> forecasts = ((state.forecasts == null)
        ? []
        : List<Forecast>.from(state.forecasts)) // Clone the existing state list
      ..add(event.forecast);

    yield state.copyWith(
      forecasts: forecasts,
      crudStatus: Nullable<CRUDStatus>(CRUDStatus.CREATED),
      selectedForecastIndex: forecasts.indexWhere((Forecast forecast) =>
          (forecast.postalCode == event.forecast.postalCode)),
    );
  }

  Stream<AppState> _mapRefreshForecastToStates(
    RefreshForecast event,
  ) async* {
    yield state.copyWith(
      refreshStatus: Nullable<RefreshStatus>(RefreshStatus.REFRESHING),
    );

    http.Response forecastResponse = await tryLookupForecast(
      event.forecast.postalCode,
      event.forecast.countryCode,
    );

    if (forecastResponse.statusCode == 200) {
      List<Forecast> forecasts = ((state.forecasts == null)
          ? []
          : List<Forecast>.from(state.forecasts));

      int forecastIndex = forecasts.indexWhere(
        (Forecast forecast) => forecast.postalCode == event.forecast.postalCode,
      );

      if (forecastIndex == -1) {
        // TODO! snackbar error
      }

      Forecast _forecast = Forecast.fromJson(jsonDecode(forecastResponse.body));
      forecasts[forecastIndex] = _forecast.copyWith(
        postalCode: event.forecast.postalCode,
        countryCode: event.forecast.countryCode,
        lastUpdated: getNow(),
      );

      yield state.copyWith(
        forecasts: forecasts,
        refreshStatus: Nullable<RefreshStatus>(null),
      );
    } else {
      // TODO! snackbar error
    }
  }

  AppState _mapClearCRUDStatusToStates(
    ClearCRUDStatus event,
  ) =>
      state.copyWith(crudStatus: Nullable<CRUDStatus>(null));

  @override
  AppState fromJson(
    Map<String, dynamic> json,
  ) =>
      AppState(
        themeMode: getThemeMode(json['themeMode']),
        temperatureUnit: getTemperatureUnit(json['temperatureUnit']),
        forecasts: Forecast.fromJsonList(json['forecasts']),
        selectedForecastIndex: json['selectedForecastIndex'],
      );

  @override
  Map<String, dynamic> toJson(
    AppState state,
  ) =>
      {
        'themeMode': state.themeMode.toString(),
        'temperatureUnit': state.temperatureUnit.toString(),
        'forecasts': Forecast.toJsonList(state.forecasts),
        'selectedForecastIndex': state.selectedForecastIndex,
      };
}
