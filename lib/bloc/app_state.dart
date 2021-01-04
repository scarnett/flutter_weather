import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/model.dart';
import 'package:flutter_weather/utils/common_utils.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:meta/meta.dart';

@immutable
class AppState extends Equatable {
  final ThemeMode themeMode;
  final TemperatureUnit temperatureUnit;
  final int selectedForecastIndex;
  final List<Forecast> forecasts;
  final RefreshStatus refreshStatus;

  AppState({
    this.themeMode: ThemeMode.light,
    this.temperatureUnit: TemperatureUnit.fahrenheit,
    this.selectedForecastIndex = 0,
    this.forecasts,
    this.refreshStatus,
  });

  const AppState._({
    this.themeMode: ThemeMode.light,
    this.temperatureUnit: TemperatureUnit.fahrenheit,
    this.selectedForecastIndex = 0,
    this.forecasts,
    this.refreshStatus,
  });

  const AppState.initial() : this._();

  AppState copyWith({
    ThemeMode themeMode,
    TemperatureUnit temperatureUnit,
    int selectedForecastIndex,
    List<Forecast> forecasts,
    Nullable<RefreshStatus> refreshStatus,
  }) =>
      AppState._(
        themeMode: themeMode ?? this.themeMode,
        temperatureUnit: temperatureUnit ?? this.temperatureUnit,
        selectedForecastIndex:
            selectedForecastIndex ?? this.selectedForecastIndex,
        forecasts: forecasts ?? this.forecasts,
        refreshStatus:
            (refreshStatus == null) ? this.refreshStatus : refreshStatus.value,
      );

  @override
  List<Object> get props => [
        themeMode,
        temperatureUnit,
        selectedForecastIndex,
        forecasts,
        refreshStatus,
      ];

  @override
  String toString() =>
      'AppState{themeMode: $themeMode, temperatureUnit: $temperatureUnit, ' +
      'selectedForecastIndex: $selectedForecastIndex, ' +
      'forecasts: $forecasts, refreshStatus: $refreshStatus}';
}
