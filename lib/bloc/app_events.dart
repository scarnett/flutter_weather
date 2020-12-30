import 'package:equatable/equatable.dart';

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
