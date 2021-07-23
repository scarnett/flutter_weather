part of 'app_bloc.dart';

@immutable
class AppState extends Equatable {
  final UpdatePeriod? updatePeriod;
  final PushNotification? pushNotification;
  final NotificationExtras? pushNotificationExtras;
  final ThemeMode themeMode;
  final bool colorTheme;
  final Units units;
  final ChartType chartType;
  final HourRange hourRange;
  final int selectedForecastIndex;
  final List<Forecast> forecasts;
  final String? activeForecastId;
  final RefreshStatus? refreshStatus;
  final CRUDStatus? crudStatus;
  final ScrollDirection? scrollDirection;
  final ConnectivityResult? connectivityResult;
  final CompassEvent? compassEvent;

  AppState({
    this.updatePeriod,
    this.pushNotification,
    this.pushNotificationExtras,
    this.themeMode: ThemeMode.light,
    this.colorTheme: false,
    this.units: const Units.initial(),
    this.chartType: ChartType.line,
    this.hourRange: HourRange.hours12,
    this.selectedForecastIndex: 0,
    this.forecasts: const [],
    this.activeForecastId,
    this.refreshStatus,
    this.crudStatus,
    this.scrollDirection,
    this.connectivityResult,
    this.compassEvent,
  });

  const AppState._({
    this.updatePeriod,
    this.pushNotification,
    this.pushNotificationExtras,
    this.themeMode: ThemeMode.light,
    this.colorTheme: false,
    this.units: const Units.initial(),
    this.chartType: ChartType.line,
    this.hourRange: HourRange.hours12,
    this.selectedForecastIndex: 0,
    this.forecasts: const [],
    this.activeForecastId,
    this.refreshStatus,
    this.crudStatus,
    this.scrollDirection: ScrollDirection.idle,
    this.connectivityResult,
    this.compassEvent,
  });

  const AppState.initial() : this._();

  AppState copyWith({
    Nullable<UpdatePeriod?>? updatePeriod,
    Nullable<PushNotification?>? pushNotification,
    Nullable<NotificationExtras?>? pushNotificationExtras,
    ThemeMode? themeMode,
    bool? colorTheme,
    Units? units,
    ChartType? chartType,
    HourRange? hourRange,
    int? selectedForecastIndex,
    Nullable<String>? selectedCountry,
    List<Forecast>? forecasts,
    Nullable<String?>? activeForecastId,
    Nullable<RefreshStatus?>? refreshStatus,
    Nullable<CRUDStatus?>? crudStatus,
    Nullable<ScrollDirection?>? scrollDirection,
    Nullable<ConnectivityResult?>? connectivityResult,
    Nullable<CompassEvent?>? compassEvent,
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
        units: units ?? this.units,
        chartType: chartType ?? this.chartType,
        hourRange: hourRange ?? this.hourRange,
        selectedForecastIndex:
            selectedForecastIndex ?? this.selectedForecastIndex,
        forecasts: forecasts ?? this.forecasts,
        activeForecastId: (activeForecastId == null)
            ? this.activeForecastId
            : activeForecastId.value,
        refreshStatus:
            (refreshStatus == null) ? this.refreshStatus : refreshStatus.value,
        crudStatus: (crudStatus == null) ? this.crudStatus : crudStatus.value,
        scrollDirection: (scrollDirection == null)
            ? this.scrollDirection
            : scrollDirection.value,
        connectivityResult: (connectivityResult == null)
            ? this.connectivityResult
            : connectivityResult.value,
        compassEvent:
            (compassEvent == null) ? this.compassEvent : compassEvent.value,
      );

  @override
  List<Object?> get props => [
        updatePeriod,
        pushNotification,
        pushNotificationExtras,
        themeMode,
        colorTheme,
        units,
        chartType,
        hourRange,
        selectedForecastIndex,
        forecasts,
        activeForecastId,
        refreshStatus,
        crudStatus,
        scrollDirection,
        connectivityResult,
        compassEvent,
      ];

  @override
  String toString() =>
      'AppState{updatePeriod: $updatePeriod, ' +
      'pushNotification: $pushNotification, ' +
      'pushNotificationExtras: $pushNotificationExtras, ' +
      'themeMode: $themeMode, colorTheme: $colorTheme, ' +
      'units: $units, chartType: $chartType, hourRange: $hourRange, ' +
      'selectedForecastIndex: $selectedForecastIndex, forecasts: $forecasts, ' +
      'activeForecastId: $activeForecastId, refreshStatus: $refreshStatus, ' +
      'crudStatus: $crudStatus, scrollDirection: $scrollDirection, ' +
      'connectivityResult: $connectivityResult, compassEvent: $compassEvent}';
}
