part of 'app_bloc.dart';

@immutable
class AppState extends Equatable {
  final ThemeMode themeMode;
  final bool colorTheme;
  final TemperatureUnit temperatureUnit;
  final int selectedForecastIndex;
  final List<Forecast> forecasts;
  final RefreshStatus refreshStatus;
  final CRUDStatus crudStatus;

  AppState({
    this.themeMode: ThemeMode.light,
    this.colorTheme: false,
    this.temperatureUnit: TemperatureUnit.fahrenheit,
    this.selectedForecastIndex: 0,
    this.forecasts: const [],
    this.refreshStatus,
    this.crudStatus,
  });

  const AppState._({
    this.themeMode: ThemeMode.light,
    this.colorTheme: false,
    this.temperatureUnit: TemperatureUnit.fahrenheit,
    this.selectedForecastIndex: 0,
    this.forecasts: const [],
    this.refreshStatus,
    this.crudStatus,
  });

  const AppState.initial() : this._();

  AppState copyWith({
    ThemeMode themeMode,
    bool colorTheme,
    TemperatureUnit temperatureUnit,
    int selectedForecastIndex,
    List<Forecast> forecasts,
    Nullable<RefreshStatus> refreshStatus,
    Nullable<CRUDStatus> crudStatus,
  }) =>
      AppState._(
        themeMode: themeMode ?? this.themeMode,
        colorTheme: colorTheme ?? this.colorTheme,
        temperatureUnit: temperatureUnit ?? this.temperatureUnit,
        selectedForecastIndex:
            selectedForecastIndex ?? this.selectedForecastIndex,
        forecasts: forecasts ?? this.forecasts,
        refreshStatus:
            (refreshStatus == null) ? this.refreshStatus : refreshStatus.value,
        crudStatus: (crudStatus == null) ? this.crudStatus : crudStatus.value,
      );

  @override
  List<Object> get props => [
        themeMode,
        colorTheme,
        temperatureUnit,
        selectedForecastIndex,
        forecasts,
        refreshStatus,
        crudStatus,
      ];

  @override
  String toString() =>
      'AppState{themeMode: $themeMode, colorTheme: $colorTheme, ' +
      'temperatureUnit: $temperatureUnit, ' +
      'selectedForecastIndex: $selectedForecastIndex, ' +
      'forecasts: $forecasts, refreshStatus: $refreshStatus, ' +
      'crudStatus: $crudStatus}';
}
