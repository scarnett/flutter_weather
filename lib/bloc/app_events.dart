import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/model.dart';

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
