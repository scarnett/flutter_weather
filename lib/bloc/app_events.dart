import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/model.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class ToggleThemeMode extends AppEvent {
  const ToggleThemeMode();

  @override
  List<Object> get props => [];
}

class SetThemeMode extends AppEvent {
  final ThemeMode themeMode;

  const SetThemeMode(
    this.themeMode,
  );

  @override
  List<Object> get props => [themeMode];
}

class SetTemperatureUnit extends AppEvent {
  final TemperatureUnit temperatureUnit;

  const SetTemperatureUnit(
    this.temperatureUnit,
  );

  @override
  List<Object> get props => [temperatureUnit];
}

class AddForecast extends AppEvent {
  final Forecast forecast;

  const AddForecast(
    this.forecast,
  );

  @override
  List<Object> get props => [forecast];
}

class RefreshForecast extends AppEvent {
  final Forecast forecast;
  final TemperatureUnit temperatureUnit;

  const RefreshForecast(
    this.forecast,
    this.temperatureUnit,
  );

  @override
  List<Object> get props => [forecast, temperatureUnit];
}

class SelectedForecastIndex extends AppEvent {
  final int index;

  const SelectedForecastIndex(
    this.index,
  );

  @override
  List<Object> get props => [index];
}

class ClearCRUDStatus extends AppEvent {
  const ClearCRUDStatus();

  @override
  List<Object> get props => [];
}
