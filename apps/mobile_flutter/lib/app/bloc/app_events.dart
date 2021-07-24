part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

class GetRemoteConfig extends AppEvent {
  const GetRemoteConfig();

  @override
  List<Object> get props => [];
}

class ToggleThemeMode extends AppEvent {
  const ToggleThemeMode();

  @override
  List<Object> get props => [];
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
}

class SetThemeMode extends AppEvent {
  final ThemeMode? themeMode;

  const SetThemeMode(
    this.themeMode,
  );

  @override
  List<Object?> get props => [themeMode];
}

class ToggleColorTheme extends AppEvent {
  const ToggleColorTheme();

  @override
  List<Object> get props => [];
}

class SetColorTheme extends AppEvent {
  final bool? colorTheme;

  const SetColorTheme(
    this.colorTheme,
  );

  @override
  List<Object?> get props => [colorTheme];
}

class SetTemperatureUnit extends AppEvent {
  final TemperatureUnit? temperatureUnit;

  const SetTemperatureUnit(
    this.temperatureUnit,
  );

  @override
  List<Object?> get props => [temperatureUnit];
}

class SetWindSpeedUnit extends AppEvent {
  final WindSpeedUnit? windSpeedUnit;

  const SetWindSpeedUnit(
    this.windSpeedUnit,
  );

  @override
  List<Object?> get props => [windSpeedUnit];
}

class SetPressureUnit extends AppEvent {
  final PressureUnit? pressureUnit;

  const SetPressureUnit(
    this.pressureUnit,
  );

  @override
  List<Object?> get props => [pressureUnit];
}

class SetDistanceUnit extends AppEvent {
  final DistanceUnit? distanceUnit;

  const SetDistanceUnit(
    this.distanceUnit,
  );

  @override
  List<Object?> get props => [distanceUnit];
}

class SetChartType extends AppEvent {
  final ChartType? chartType;

  const SetChartType(
    this.chartType,
  );

  @override
  List<Object?> get props => [chartType];
}

class SetHourRange extends AppEvent {
  final HourRange? hourRange;

  const SetHourRange(
    this.hourRange,
  );

  @override
  List<Object?> get props => [hourRange];
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
  final BuildContext context;
  final String? forecastId;
  final Map<String, dynamic> forecastData;

  const UpdateForecast(
    this.context,
    this.forecastId,
    this.forecastData,
  );

  @override
  List<Object?> get props => [forecastId, forecastData];
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
}

class DeleteForecast extends AppEvent {
  final String? forecastId;

  const DeleteForecast(
    this.forecastId,
  );

  @override
  List<Object?> get props => [forecastId];
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
  final String? forecastId;

  const SetActiveForecastId(
    this.forecastId,
  );

  @override
  List<Object?> get props => [forecastId];
}

class ClearActiveForecastId extends AppEvent {
  const ClearActiveForecastId();

  @override
  List<Object> get props => [];
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
}

class ClearCRUDStatus extends AppEvent {
  const ClearCRUDStatus();

  @override
  List<Object> get props => [];
}

class SetScrollDirection extends AppEvent {
  final ScrollDirection scrollDirection;

  const SetScrollDirection(
    this.scrollDirection,
  );

  @override
  List<Object?> get props => [scrollDirection];
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
}

class StreamCompassEvent extends AppEvent {
  @override
  List<Object?> get props => [];
}

class SetCompassEvent extends AppEvent {
  final CompassEvent compassEvent;

  const SetCompassEvent(
    this.compassEvent,
  );

  @override
  List<Object?> get props => [compassEvent];
}
