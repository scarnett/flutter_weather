import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
class AppState extends Equatable {
  final ThemeMode themeMode;

  AppState({
    this.themeMode: ThemeMode.light,
  });

  const AppState._({
    this.themeMode: ThemeMode.light,
  });

  const AppState.initial() : this._();

  AppState copyWith({
    ThemeMode themeMode,
  }) =>
      AppState._(
        themeMode: themeMode ?? this.themeMode,
      );

  @override
  List<Object> get props => [themeMode];

  @override
  String toString() => 'AppState{themeMode: $themeMode}';
}
