part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

class GetCurrentAppVersion extends AppEvent {
  const GetCurrentAppVersion();

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

class ToggleColorTheme extends AppEvent {
  const ToggleColorTheme();

  @override
  List<Object> get props => [];
}

class SetColorTheme extends AppEvent {
  final bool colorTheme;

  const SetColorTheme(
    this.colorTheme,
  );

  @override
  List<Object> get props => [colorTheme];
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

class UpdateForecast extends AppEvent {
  final String forecastId;
  final Map<String, dynamic> forecastData;

  const UpdateForecast(
    this.forecastId,
    this.forecastData,
  );

  @override
  List<Object> get props => [forecastId, forecastData];
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

class DeleteForecast extends AppEvent {
  final String forecastId;

  const DeleteForecast(
    this.forecastId,
  );

  @override
  List<Object> get props => [forecastId];
}

class SelectedForecastIndex extends AppEvent {
  final int index;

  const SelectedForecastIndex(
    this.index,
  );

  @override
  List<Object> get props => [index];
}

class SetActiveForecastId extends AppEvent {
  final String forecastId;

  const SetActiveForecastId(
    this.forecastId,
  );

  @override
  List<Object> get props => [forecastId];
}

class ClearActiveForecastId extends AppEvent {
  const ClearActiveForecastId();

  @override
  List<Object> get props => [];
}

class ClearCRUDStatus extends AppEvent {
  const ClearCRUDStatus();

  @override
  List<Object> get props => [];
}
