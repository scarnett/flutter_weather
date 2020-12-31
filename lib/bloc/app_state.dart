import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/model.dart';
import 'package:meta/meta.dart';

@immutable
class AppState extends Equatable {
  final ThemeMode themeMode;
  final TemperatureUnit temperatureUnit;

  AppState({
    this.themeMode: ThemeMode.light,
    this.temperatureUnit: TemperatureUnit.fahrenheit,
  });

  const AppState._({
    this.themeMode: ThemeMode.light,
    this.temperatureUnit: TemperatureUnit.fahrenheit,
  });

  const AppState.initial() : this._();

  AppState copyWith({
    ThemeMode themeMode,
    TemperatureUnit temperatureUnit,
  }) =>
      AppState._(
        themeMode: themeMode ?? this.themeMode,
        temperatureUnit: temperatureUnit ?? this.temperatureUnit,
      );

  @override
  List<Object> get props => [themeMode, temperatureUnit];

  @override
  String toString() =>
      'AppState{themeMode: $themeMode, temperatureUnit: $temperatureUnit}';
}
