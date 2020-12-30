import 'package:flutter/material.dart';
import 'package:flutter_weather/bloc/app_events.dart';
import 'package:flutter_weather/bloc/app_state.dart';
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

  @override
  AppState fromJson(
    Map<String, dynamic> json,
  ) =>
      AppState(
        themeMode: getThemeMode(json['themeMode']),
      );

  @override
  Map<String, dynamic> toJson(
    AppState state,
  ) =>
      {
        'themeMode': state.themeMode.toString(),
      };
}
