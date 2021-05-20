part of 'app_bloc.dart';

@immutable
class AppState extends Equatable {
  final UpdatePeriod? updatePeriod;
  final PushNotification? pushNotification;
  final Map<String, dynamic>? pushNotificationExtras;
  final ThemeMode themeMode;
  final bool colorTheme;
  final TemperatureUnit temperatureUnit;
  final int selectedForecastIndex;
  final List<Forecast> forecasts;
  final String? activeForecastId;
  final RefreshStatus? refreshStatus;
  final CRUDStatus? crudStatus;

  AppState({
    this.updatePeriod,
    this.pushNotification,
    this.pushNotificationExtras,
    this.themeMode: ThemeMode.light,
    this.colorTheme: false,
    this.temperatureUnit: TemperatureUnit.fahrenheit,
    this.selectedForecastIndex: 0,
    this.forecasts: const [],
    this.activeForecastId,
    this.refreshStatus,
    this.crudStatus,
  });

  const AppState._({
    this.updatePeriod,
    this.pushNotification,
    this.pushNotificationExtras,
    this.themeMode: ThemeMode.light,
    this.colorTheme: false,
    this.temperatureUnit: TemperatureUnit.fahrenheit,
    this.selectedForecastIndex: 0,
    this.forecasts: const [],
    this.activeForecastId,
    this.refreshStatus,
    this.crudStatus,
  });

  const AppState.initial() : this._();

  AppState copyWith({
    Nullable<UpdatePeriod?>? updatePeriod,
    Nullable<PushNotification?>? pushNotification,
    Nullable<Map<String, dynamic>?>? pushNotificationExtras,
    ThemeMode? themeMode,
    bool? colorTheme,
    TemperatureUnit? temperatureUnit,
    int? selectedForecastIndex,
    Nullable<String>? selectedCountry,
    List<Forecast>? forecasts,
    Nullable<String?>? activeForecastId,
    Nullable<RefreshStatus?>? refreshStatus,
    Nullable<CRUDStatus?>? crudStatus,
  }) =>
      AppState._(
        updatePeriod:
            (updatePeriod == null) ? this.updatePeriod : updatePeriod.value,
        pushNotification: (pushNotification == null)
            ? this.pushNotification
            : pushNotification.value,
        pushNotificationExtras: (pushNotificationExtras == null)
            ? this.pushNotificationExtras
            : pushNotificationExtras.value,
        themeMode: themeMode ?? this.themeMode,
        colorTheme: colorTheme ?? this.colorTheme,
        temperatureUnit: temperatureUnit ?? this.temperatureUnit,
        selectedForecastIndex:
            selectedForecastIndex ?? this.selectedForecastIndex,
        forecasts: forecasts ?? this.forecasts,
        activeForecastId: (activeForecastId == null)
            ? this.activeForecastId
            : activeForecastId.value,
        refreshStatus:
            (refreshStatus == null) ? this.refreshStatus : refreshStatus.value,
        crudStatus: (crudStatus == null) ? this.crudStatus : crudStatus.value,
      );

  @override
  List<Object?> get props => [
        updatePeriod,
        pushNotification,
        pushNotificationExtras,
        themeMode,
        colorTheme,
        temperatureUnit,
        selectedForecastIndex,
        forecasts,
        activeForecastId,
        refreshStatus,
        crudStatus,
      ];

  @override
  String toString() =>
      'AppState{updatePeriod: $updatePeriod, ' +
      'pushNotification: $pushNotification, ' +
      'pushNotificationExtras: $pushNotificationExtras, ' +
      'themeMode: $themeMode, colorTheme: $colorTheme, ' +
      'temperatureUnit: $temperatureUnit, ' +
      'selectedForecastIndex: $selectedForecastIndex, forecasts: $forecasts, ' +
      'activeForecastId: $activeForecastId, refreshStatus: $refreshStatus, ' +
      'crudStatus: $crudStatus}';
}
