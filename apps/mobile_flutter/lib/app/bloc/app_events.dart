part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];

  @override
  String toString() => 'AppEvent{}';
}

class GetRemoteConfig extends AppEvent {
  const GetRemoteConfig();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'GetRemoteConfig{}';
}

class ToggleThemeMode extends AppEvent {
  const ToggleThemeMode();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'ToggleThemeMode{}';
}

class SetUpdatePeriod extends AppEvent {
  final BuildContext context;
  final UpdatePeriod? updatePeriod;
  final Function? callback;

  const SetUpdatePeriod({
    required this.context,
    this.updatePeriod,
    this.callback,
  });

  @override
  List<Object?> get props => [updatePeriod];

  @override
  String toString() => 'SetUpdatePeriod{updatePeriod: $updatePeriod}';
}

class SetPushNotification extends AppEvent {
  final BuildContext context;
  final PushNotification? pushNotification;
  final NotificationExtras? pushNotificationExtras;
  final Function? callback;

  const SetPushNotification({
    required this.context,
    this.pushNotification,
    this.pushNotificationExtras,
    this.callback,
  });

  @override
  List<Object?> get props => [
        pushNotification,
        pushNotificationExtras,
      ];

  @override
  String toString() =>
      'SetPushNotification{pushNotification: $pushNotification, ' +
      'pushNotificationExtras: $pushNotificationExtras}';
}

class SetThemeMode extends AppEvent {
  final ThemeMode? themeMode;

  const SetThemeMode(
    this.themeMode,
  );

  @override
  List<Object?> get props => [themeMode];

  @override
  String toString() => 'SetThemeMode{themeMode: $themeMode}';
}

class ToggleColorTheme extends AppEvent {
  const ToggleColorTheme();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'ToggleColorTheme{}';
}

class SetColorTheme extends AppEvent {
  final bool? colorTheme;

  const SetColorTheme(
    this.colorTheme,
  );

  @override
  List<Object?> get props => [colorTheme];

  @override
  String toString() => 'SetColorTheme{colorTheme: $colorTheme}';
}

class SetTemperatureUnit extends AppEvent {
  final TemperatureUnit? temperatureUnit;

  const SetTemperatureUnit(
    this.temperatureUnit,
  );

  @override
  List<Object?> get props => [temperatureUnit];

  @override
  String toString() => 'SetTemperatureUnit{temperatureUnit: $temperatureUnit}';
}

class SetWindSpeedUnit extends AppEvent {
  final WindSpeedUnit? windSpeedUnit;

  const SetWindSpeedUnit(
    this.windSpeedUnit,
  );

  @override
  List<Object?> get props => [windSpeedUnit];

  @override
  String toString() => 'SetWindSpeedUnit{windSpeedUnit: $windSpeedUnit}';
}

class SetPressureUnit extends AppEvent {
  final PressureUnit? pressureUnit;

  const SetPressureUnit(
    this.pressureUnit,
  );

  @override
  List<Object?> get props => [pressureUnit];

  @override
  String toString() => 'SetPressureUnit{pressureUnit: $pressureUnit}';
}

class SetDistanceUnit extends AppEvent {
  final DistanceUnit? distanceUnit;

  const SetDistanceUnit(
    this.distanceUnit,
  );

  @override
  List<Object?> get props => [distanceUnit];

  @override
  String toString() => 'SetDistanceUnit{distanceUnit: $distanceUnit}';
}

class SetChartType extends AppEvent {
  final ChartType? chartType;

  const SetChartType(
    this.chartType,
  );

  @override
  List<Object?> get props => [chartType];

  @override
  String toString() => 'SetChartType{chartType: $chartType}';
}

class SetHourRange extends AppEvent {
  final HourRange? hourRange;

  const SetHourRange(
    this.hourRange,
  );

  @override
  List<Object?> get props => [hourRange];

  @override
  String toString() => 'SetHourRange{hourRange: $hourRange}';
}

class AddForecast extends AppEvent {
  final Forecast forecast;

  const AddForecast(
    this.forecast,
  );

  @override
  List<Object> get props => [forecast];

  @override
  String toString() => 'AddForecast{forecast: $forecast}';
}

class UpdateForecast extends AppEvent {
  final BuildContext context;
  final String? forecastId;
  final Map<String, dynamic> forecastData;

  const UpdateForecast(
    this.context,
    this.forecastId,
    this.forecastData,
  );

  @override
  List<Object?> get props => [
        forecastId,
        forecastData,
      ];

  @override
  String toString() =>
      'UpdateForecast{forecastId: $forecastId, forecastData: $forecastData}';
}

class RefreshForecast extends AppEvent {
  final BuildContext context;
  final Forecast forecast;
  final TemperatureUnit temperatureUnit;

  const RefreshForecast(
    this.context,
    this.forecast,
    this.temperatureUnit,
  );

  @override
  List<Object> get props => [
        forecast,
        temperatureUnit,
      ];

  @override
  String toString() =>
      'RefreshForecast{forecast: $forecast, temperatureUnit: $temperatureUnit}';
}

class DeleteForecast extends AppEvent {
  final String? forecastId;

  const DeleteForecast(
    this.forecastId,
  );

  @override
  List<Object?> get props => [forecastId];

  @override
  String toString() => 'DeleteForecast{forecastId: $forecastId}';
}

class SelectedForecastIndex extends AppEvent {
  final int index;

  const SelectedForecastIndex(
    this.index,
  );

  @override
  List<Object> get props => [index];

  @override
  String toString() => 'SelectedForecastIndex{index: $index}';
}

class SetActiveForecastId extends AppEvent {
  final String? forecastId;

  const SetActiveForecastId(
    this.forecastId,
  );

  @override
  List<Object?> get props => [forecastId];

  @override
  String toString() => 'SetActiveForecastId{forecastId: $forecastId}';
}

class ClearActiveForecastId extends AppEvent {
  const ClearActiveForecastId();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'ClearActiveForecastId{}';
}

class AutoUpdateForecast extends AppEvent {
  final BuildContext context;
  final int forecastIndex;

  const AutoUpdateForecast(
    this.context,
    this.forecastIndex,
  );

  @override
  List<Object> get props => [
        context,
        forecastIndex,
      ];

  @override
  String toString() => 'AutoUpdateForecast{forecastIndex: $forecastIndex}';
}

class ClearCRUDStatus extends AppEvent {
  const ClearCRUDStatus();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'ClearCRUDStatus{}';
}

class SetScrollDirection extends AppEvent {
  final ScrollDirection scrollDirection;

  const SetScrollDirection(
    this.scrollDirection,
  );

  @override
  List<Object?> get props => [scrollDirection];

  @override
  String toString() => 'SetScrollDirection{scrollDirection: $scrollDirection}';
}

class StreamConnectivityResult extends AppEvent {
  @override
  List<Object?> get props => [];
}

class SetConnectivityResult extends AppEvent {
  final ConnectivityResult connectivityResult;

  const SetConnectivityResult(
    this.connectivityResult,
  );

  @override
  List<Object?> get props => [connectivityResult];

  @override
  String toString() =>
      'SetConnectivityResult{connectivityResult: $connectivityResult}';
}

class StreamCompassEvent extends AppEvent {
  @override
  List<Object?> get props => [];

  @override
  String toString() => 'StreamConnectivityResult{}';
}

class SetIsPremium extends AppEvent {
  final bool? isPremium;

  const SetIsPremium(
    this.isPremium,
  );

  @override
  List<Object?> get props => [isPremium];

  @override
  String toString() => 'SetIsPremium{isPremium: $isPremium}';
}

class SetShowPremiumInfo extends AppEvent {
  final bool? showPremiumInfo;

  const SetShowPremiumInfo(
    this.showPremiumInfo,
  );

  @override
  List<Object?> get props => [showPremiumInfo];

  @override
  String toString() => 'SetShowPremiumInfo{showPremiumInfo: $showPremiumInfo}';
}

class SetShowPremiumSuccess extends AppEvent {
  final bool? showPremiumSuccess;

  const SetShowPremiumSuccess(
    this.showPremiumSuccess,
  );

  @override
  List<Object?> get props => [showPremiumSuccess];

  @override
  String toString() =>
      'SetShowPremiumSuccess{showPremiumSuccess: $showPremiumSuccess}';
}

class SetCompassEvent extends AppEvent {
  final CompassEvent compassEvent;

  const SetCompassEvent(
    this.compassEvent,
  );

  @override
  List<Object?> get props => [compassEvent];
}
