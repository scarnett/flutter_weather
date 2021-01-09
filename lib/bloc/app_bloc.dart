import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/model.dart';
import 'package:flutter_weather/theme.dart';
import 'package:flutter_weather/utils/common_utils.dart';
import 'package:flutter_weather/utils/date_utils.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/forecast_service.dart';
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

  Stream<AppState> _mapUpdateForecastToStates(
    UpdateForecast event,
  ) async* {
    yield state.copyWith(
      crudStatus: Nullable<CRUDStatus>(CRUDStatus.UPDATING),
    );

    List<Forecast> forecasts =
        ((state.forecasts == null) ? [] : List<Forecast>.from(state.forecasts));

    Forecast _forecast = state.forecasts
        .firstWhere((Forecast forecast) => forecast.id == event.forecastId);

    forecasts[state.selectedForecastIndex] = _forecast.copyWith(
      cityName: Nullable<String>(event.forecastData['cityName']),
      postalCode: Nullable<String>(event.forecastData['postalCode']),
      countryCode: Nullable<String>(event.forecastData['countryCode']),
      lastUpdated: getNow(),
    );

    yield state.copyWith(
      activeForecastId: Nullable<String>(null),
      forecasts: forecasts,
      crudStatus: Nullable<CRUDStatus>(CRUDStatus.UPDATED),
    );
  }

  Stream<AppState> _mapRefreshForecastToStates(
    RefreshForecast event,
  ) async* {
    yield state.copyWith(
      refreshStatus: Nullable<RefreshStatus>(RefreshStatus.REFRESHING),
    );

    Map<String, String> lookupData = {
      'cityName': event.forecast.cityName,
      'postalCode': event.forecast.postalCode,
      'countryCode': event.forecast.countryCode,
    };

    http.Response forecastResponse = await tryLookupForecast(lookupData);
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
        cityName: Nullable<String>(event.forecast.cityName),
        postalCode: Nullable<String>(event.forecast.postalCode),
        countryCode: Nullable<String>(event.forecast.countryCode),
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
      activeForecastId: Nullable<String>(null),
      forecasts: _forecasts,
      selectedForecastIndex: (state.selectedForecastIndex > 0)
          ? (state.selectedForecastIndex - 1)
          : 0,
      crudStatus: Nullable<CRUDStatus>(CRUDStatus.DELETED),
    );
  }

  AppState _mapClearCRUDStatusToStates(
    ClearCRUDStatus event,
  ) =>
      state.copyWith(crudStatus: Nullable<CRUDStatus>(null));

  AppState _mapSetActiveForecastIdToState(
    SetActiveForecastId event,
  ) =>
      state.copyWith(
        activeForecastId: Nullable<String>(event.forecastId),
      );

  AppState _mapClearActiveForecastIdToState(
    ClearActiveForecastId event,
  ) =>
      state.copyWith(
        activeForecastId: Nullable<String>(null),
      );

  @override
  AppState fromJson(
    Map<String, dynamic> json,
  ) =>
      AppState(
        themeMode: getThemeMode(json['themeMode']),
        colorTheme: json['colorTheme'],
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
        'colorTheme': state.colorTheme,
        'temperatureUnit': state.temperatureUnit.toString(),
        'forecasts': Forecast.toJsonList(state.forecasts),
        'selectedForecastIndex': state.selectedForecastIndex,
      };
}
