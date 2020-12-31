import 'package:flutter/material.dart';
import 'package:flutter_weather/bloc/app_events.dart';
import 'package:flutter_weather/bloc/app_state.dart';
import 'package:flutter_weather/model.dart';
import 'package:flutter_weather/theme.dart';
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

  @override
  AppState fromJson(
    Map<String, dynamic> json,
  ) =>
      AppState(
        themeMode: getThemeMode(json['themeMode']),
        temperatureUnit: getTemperatureUnit(json['temperatureUnit']),
      );

  @override
  Map<String, dynamic> toJson(
    AppState state,
  ) =>
      {
        'themeMode': state.themeMode.toString(),
        'temperatureUnit': state.temperatureUnit.toString(),
      };
}
