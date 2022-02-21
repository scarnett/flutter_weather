import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_weather/app/app_config.dart';
import 'package:flutter_weather/app/app_localization.dart';
import 'package:flutter_weather/app/app_prefs.dart';
import 'package:flutter_weather/app/app_theme.dart';
import 'package:flutter_weather/app/utils/utils.dart';
import 'package:flutter_weather/enums/enums.dart';
import 'package:flutter_weather/enums/message_type.dart';
import 'package:flutter_weather/forecast/forecast.dart';
import 'package:flutter_weather/models/models.dart';
import 'package:flutter_weather/services/services.dart';
import 'package:flutter_weather/settings/settings.dart';
import 'package:http/http.dart' as http;
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:sentry/sentry.dart';

part 'app_events.dart';
part 'app_state.dart';

class AppBloc extends HydratedBloc<AppEvent, AppState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  Stream<CompassEvent>? _headingStream;
  StreamSubscription<CompassEvent>? _headingSubscription;

  AppBloc() : super(AppState.initial()) {
    on<ToggleThemeMode>(_onToggleThemeMode);
    on<SetUpdatePeriod>(_onSetUpdatePeriod);
    on<SetPushNotification>(_onSetPushNotification);
    on<SetThemeMode>(_onSetThemeMode);
    on<ToggleColorTheme>(_onToggleColorTheme);
    on<SetColorTheme>(_onSetColorTheme);
    on<SetTemperatureUnit>(_onSetTemperatureUnit);
    on<SetWindSpeedUnit>(_onSetWindSpeedUnit);
    on<SetPressureUnit>(_onSetPressureUnit);
    on<SetDistanceUnit>(_onSetDistanceUnit);
    on<SetChartType>(_onSetChartType);
    on<SetHourRange>(_onSetHourRange);
    on<SelectedForecastIndex>(_onSelectedForecastIndex);
    on<AddForecast>(_onAddForecast);
    on<UpdateForecast>(_onUpdateForecast);
    on<RefreshForecast>(_onRefreshForecast);
    on<DeleteForecast>(_onDeleteForecast);
    on<ClearCRUDStatus>(_onClearCRUDStatus);
    on<SetActiveForecastId>(_onSetActiveForecastIdToState);
    on<ClearActiveForecastId>(_onClearActiveForecastIdToState);
    on<AutoUpdateForecast>(_onAutoUpdateForecastToState);
    on<SetScrollDirection>(_onSetScrollDirectionToState);
    on<StreamConnectivityResult>(_onStreamConnectivityResultToState);
    on<SetConnectivityResult>(_onSetConnectivityResultToState);
    on<StreamCompassEvent>(_onStreamCompassEventToState);
    on<SetCompassEvent>(_onSetCompassEventToState);
  }

  AppState get initialState => AppState.initial();

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    _headingSubscription?.cancel();
    return super.close();
  }

  void _onToggleThemeMode(
    ToggleThemeMode event,
    Emitter<AppState> emit,
  ) =>
      emit(
        state.copyWith(
          themeMode: (state.themeMode == ThemeMode.dark)
              ? ThemeMode.light
              : ThemeMode.dark,
          colorTheme: false,
        ),
      );

  void _onSetUpdatePeriod(
    SetUpdatePeriod event,
    Emitter<AppState> emit,
  ) async {
    AppPrefs prefs = AppPrefs();
    prefs.updatePeriod = event.updatePeriod;

    String? deviceId = await getDeviceId();

    emit(
      state.copyWith(
        updatePeriod: Nullable<UpdatePeriod?>(event.updatePeriod),
        pushNotification: (event.updatePeriod == null)
            ? Nullable<PushNotification?>(null)
            : (state.pushNotification == null)
                ? Nullable<PushNotification?>(PushNotification.off)
                : Nullable<PushNotification?>(state.pushNotification),
      ),
    );

    if (event.updatePeriod == null) {
      prefs.pushNotification = null;
      await pushNotificationRemove(deviceId: deviceId);
    } else if (state.pushNotification == null) {
      prefs.pushNotification = PushNotification.off;
      await pushNotificationRemove(deviceId: deviceId);
    } else if (prefs.pushNotification != PushNotification.off) {
      await _saveDeviceInfo(prefs.pushNotification);
    }

    if (event.callback != null) {
      event.callback!();
    }

    showSnackbar(
      event.context,
      AppLocalizations.of(event.context)!.updatePeriodUpdated,
    );
  }

  void _onSetPushNotification(
    SetPushNotification event,
    Emitter<AppState> emit,
  ) async {
    AppPrefs prefs = AppPrefs();
    prefs.pushNotification = event.pushNotification;
    prefs.pushNotificationExtras = event.pushNotificationExtras;

    if ((prefs.pushNotification != null) &&
        (prefs.pushNotification != PushNotification.off)) {
      bool accessGranted = true;

      if (prefs.pushNotification == PushNotification.currentLocation) {
        accessGranted = await requestLocationPermission();
        if (accessGranted) {
          _updatePushNotificationState(event, emit);
        } else {
          showSnackbar(
            event.context,
            AppLocalizations.of(event.context)!.locationPermissionDenied,
            messageType: MessageType.danger,
          );

          if (state.pushNotification == PushNotification.currentLocation) {
            emit(
              state.copyWith(
                pushNotification:
                    Nullable<PushNotification?>(PushNotification.off),
                pushNotificationExtras: Nullable<NotificationExtras?>(null),
              ),
            );
          }
        }
      } else {
        _updatePushNotificationState(event, emit);
      }
    } else {
      _updatePushNotificationState(event, emit);
    }
  }

  void _updatePushNotificationState(
    SetPushNotification event,
    Emitter<AppState> emit,
  ) async {
    if (event.callback != null) {
      event.callback!();
    }

    emit(
      state.copyWith(
        pushNotification: Nullable<PushNotification?>(event.pushNotification),
        pushNotificationExtras:
            Nullable<NotificationExtras?>((event.pushNotificationExtras == null)
                ? null
                : NotificationExtras.fromJson({
                    ...state.pushNotificationExtras?.toJson() ?? {},
                    ...event.pushNotificationExtras?.toJson() ?? {},
                  })),
      ),
    );

    await _saveDeviceInfo(event.pushNotification);

    showSnackbar(
      event.context,
      AppLocalizations.of(event.context)!.pushNotificationUpdated,
    );
  }

  void _onSetThemeMode(
    SetThemeMode event,
    Emitter<AppState> emit,
  ) =>
      emit(
        state.copyWith(
          themeMode: event.themeMode,
          colorTheme: false,
        ),
      );

  void _onToggleColorTheme(
    ToggleColorTheme event,
    Emitter<AppState> emit,
  ) =>
      emit(
        state.copyWith(
          colorTheme: !state.colorTheme,
        ),
      );

  void _onSetColorTheme(
    SetColorTheme event,
    Emitter<AppState> emit,
  ) =>
      emit(
        state.copyWith(
          colorTheme: event.colorTheme,
        ),
      );

  void _onSetTemperatureUnit(
    SetTemperatureUnit event,
    Emitter<AppState> emit,
  ) async {
    AppPrefs prefs = AppPrefs();
    prefs.temperatureUnit = event.temperatureUnit;

    emit(
      state.copyWith(
        units: state.units.copyWith(
          temperature: event.temperatureUnit,
        ),
      ),
    );

    await _saveDeviceInfo(prefs.pushNotification);
  }

  void _onSetWindSpeedUnit(
    SetWindSpeedUnit event,
    Emitter<AppState> emit,
  ) async {
    AppPrefs prefs = AppPrefs();
    prefs.windSpeedUnit = event.windSpeedUnit;

    emit(
      state.copyWith(
        units: state.units.copyWith(
          windSpeed: event.windSpeedUnit,
        ),
      ),
    );

    await _saveDeviceInfo(prefs.pushNotification);
  }

  void _onSetPressureUnit(
    SetPressureUnit event,
    Emitter<AppState> emit,
  ) async {
    AppPrefs prefs = AppPrefs();
    prefs.pressureUnit = event.pressureUnit;

    emit(
      state.copyWith(
        units: state.units.copyWith(
          pressure: event.pressureUnit,
        ),
      ),
    );

    await _saveDeviceInfo(prefs.pushNotification);
  }

  void _onSetDistanceUnit(
    SetDistanceUnit event,
    Emitter<AppState> emit,
  ) async {
    AppPrefs prefs = AppPrefs();
    prefs.distanceUnit = event.distanceUnit;

    emit(
      state.copyWith(
        units: state.units.copyWith(
          distance: event.distanceUnit,
        ),
      ),
    );

    await _saveDeviceInfo(prefs.pushNotification);
  }

  void _onSetChartType(
    SetChartType event,
    Emitter<AppState> emit,
  ) =>
      emit(
        state.copyWith(
          chartType: event.chartType,
        ),
      );

  void _onSetHourRange(
    SetHourRange event,
    Emitter<AppState> emit,
  ) {
    if (event.hourRange != state.hourRange) {
      emit(
        state.copyWith(
          hourRange: event.hourRange,
        ),
      );
    }
  }

  void _onSelectedForecastIndex(
    SelectedForecastIndex event,
    Emitter<AppState> emit,
  ) {
    if (event.index != state.selectedForecastIndex) {
      emit(
        state.copyWith(
          selectedForecastIndex: event.index,
        ),
      );
    }
  }

  void _onAddForecast(
    AddForecast event,
    Emitter<AppState> emit,
  ) {
    emit(
      state.copyWith(
        crudStatus: Nullable<CRUDStatus>(CRUDStatus.creating),
      ),
    );

    // TODO! sort
    List<Forecast> forecasts =
        List<Forecast>.from(state.forecasts) // Clone the existing state list
          ..add(event.forecast);

    emit(
      state.copyWith(
        forecasts: forecasts,
        crudStatus: Nullable<CRUDStatus>(CRUDStatus.created),
        selectedForecastIndex: forecasts.indexWhere((Forecast forecast) =>
            (forecast.postalCode == event.forecast.postalCode)),
      ),
    );
  }

  void _onUpdateForecast(
    UpdateForecast event,
    Emitter<AppState> emit,
  ) {
    emit(
      state.copyWith(
        crudStatus: Nullable<CRUDStatus>(CRUDStatus.updating),
      ),
    );

    List<Forecast> forecasts = List<Forecast>.from(state.forecasts);
    Forecast forecast = state.forecasts
        .firstWhere((Forecast forecast) => forecast.id == event.forecastId);

    forecasts[state.selectedForecastIndex] = forecast.copyWith(
      id: event.forecastId,
      cityName: Nullable<String?>(event.forecastData['cityName']),
      postalCode: Nullable<String?>(event.forecastData['postalCode']),
      countryCode: Nullable<String?>(event.forecastData['countryCode']),
      lastUpdated: getNow(),
    );

    emit(
      state.copyWith(
        activeForecastId: Nullable<String?>(null),
        forecasts: forecasts,
        crudStatus: Nullable<CRUDStatus>(CRUDStatus.updated),
      ),
    );

    add(
      RefreshForecast(
        event.context,
        forecasts[state.selectedForecastIndex],
        state.units.temperature,
      ),
    );
  }

  void _onRefreshForecast(
    RefreshForecast event,
    Emitter<AppState> emit,
  ) async {
    emit(
      state.copyWith(
        refreshStatus: Nullable<RefreshStatus>(RefreshStatus.refreshing),
        crudStatus: Nullable<CRUDStatus?>(null),
      ),
    );

    Map<String, String?> lookupData = {
      'cityName': event.forecast.cityName,
      'postalCode': event.forecast.postalCode,
      'countryCode': event.forecast.countryCode,
    };

    try {
      http.Client httpClient = http.Client();

      if (await hasConnectivity(
        client: httpClient,
        config: AppConfig.instance.config,
        result: state.connectivityResult,
      )) {
        http.Response forecastResponse = await tryLookupForecast(
          client: httpClient,
          lookupData: lookupData,
        );

        if (forecastResponse.statusCode == 200) {
          List<Forecast> forecasts = List<Forecast>.from(state.forecasts);
          int forecastIndex = forecasts.indexWhere((Forecast forecast) =>
              forecast.postalCode == event.forecast.postalCode);

          if (forecastIndex == -1) {
            showSnackbar(
              event.context,
              AppLocalizations.of(event.context)!.refreshFailure,
              messageType: MessageType.danger,
            );
          } else {
            Forecast forecast =
                Forecast.fromJson(jsonDecode(forecastResponse.body));

            forecasts[forecastIndex] = forecast.copyWith(
              id: event.forecast.id,
              cityName: Nullable<String?>(event.forecast.cityName),
              postalCode: Nullable<String?>(event.forecast.postalCode),
              countryCode: Nullable<String?>(event.forecast.countryCode),
              lastUpdated: getNow(),
            );

            // TODO! premium
            http.Response forecastDetailsResponse = await fetchDetailedForecast(
              client: httpClient,
              longitude: forecast.city!.coord!.lon!,
              latitude: forecast.city!.coord!.lat!,
            );

            if (forecastDetailsResponse.statusCode == 200) {
              forecasts[forecastIndex] = forecasts[forecastIndex].copyWith(
                  details: Nullable<ForecastDetails?>(ForecastDetails.fromJson(
                      jsonDecode(forecastDetailsResponse.body))));
            }

            emit(
              state.copyWith(
                forecasts: forecasts,
                refreshStatus: Nullable<RefreshStatus?>(null),
                crudStatus: Nullable<CRUDStatus?>(null),
              ),
            );
          }
        } else {
          showSnackbar(
            event.context,
            AppLocalizations.of(event.context)!.refreshFailure,
            messageType: MessageType.danger,
          );

          emit(
            state.copyWith(
              refreshStatus: Nullable<RefreshStatus?>(null),
              crudStatus: Nullable<CRUDStatus?>(null),
            ),
          );
        }
      } else {
        showSnackbar(
          event.context,
          AppLocalizations.of(event.context)!.connectivityFailure,
          messageType: MessageType.danger,
        );

        emit(
          state.copyWith(
            refreshStatus: Nullable<RefreshStatus?>(null),
            crudStatus: Nullable<CRUDStatus?>(null),
          ),
        );
      }
    } on Exception catch (exception, stackTrace) {
      await Sentry.captureException(exception, stackTrace: stackTrace);

      showSnackbar(
        event.context,
        AppLocalizations.of(event.context)!.refreshFailure,
        messageType: MessageType.danger,
      );

      emit(
        state.copyWith(
          refreshStatus: Nullable<RefreshStatus?>(null),
          crudStatus: Nullable<CRUDStatus?>(null),
        ),
      );
    }
  }

  void _onDeleteForecast(
    DeleteForecast event,
    Emitter<AppState> emit,
  ) {
    emit(
      state.copyWith(
        crudStatus: Nullable<CRUDStatus>(CRUDStatus.deleting),
      ),
    );

    int _forecastIndex = state.forecasts
        .indexWhere((Forecast forecast) => forecast.id == event.forecastId);

    List<Forecast> _forecasts = state.forecasts..removeAt(_forecastIndex);

    emit(
      state.copyWith(
        activeForecastId: Nullable<String?>(null),
        colorTheme: hasForecasts(_forecasts) ? state.colorTheme : false,
        forecasts: _forecasts,
        selectedForecastIndex: (state.selectedForecastIndex > 0)
            ? (state.selectedForecastIndex - 1)
            : 0,
        crudStatus: Nullable<CRUDStatus>(CRUDStatus.deleted),
      ),
    );
  }

  void _onClearCRUDStatus(
    ClearCRUDStatus event,
    Emitter<AppState> emit,
  ) =>
      emit(
        state.copyWith(crudStatus: Nullable<CRUDStatus?>(null)),
      );

  void _onSetActiveForecastIdToState(
    SetActiveForecastId event,
    Emitter<AppState> emit,
  ) =>
      emit(
        state.copyWith(
          activeForecastId: Nullable<String?>(event.forecastId),
        ),
      );

  void _onClearActiveForecastIdToState(
    ClearActiveForecastId event,
    Emitter<AppState> emit,
  ) =>
      emit(
        state.copyWith(
          activeForecastId: Nullable<String?>(null),
        ),
      );

  void _onAutoUpdateForecastToState(
    AutoUpdateForecast event,
    Emitter<AppState> emit,
  ) {
    // If auto update is enabled then run the refresh
    if ((state.updatePeriod != null) &&
        state.forecasts.isNotEmpty &&
        (state.forecasts.length >= event.forecastIndex + 1)) {
      Forecast forecast = state.forecasts[event.forecastIndex];
      DateTime? lastUpdated = forecast.lastUpdated;
      if ((lastUpdated == null) ||
          DateTime.now().isAfter(lastUpdated.add(
              Duration(minutes: state.updatePeriod?.getInfo()!['minutes'])))) {
        add(
          RefreshForecast(
            event.context,
            state.forecasts[event.forecastIndex],
            state.units.temperature,
          ),
        );
      }
    }
  }

  void _onSetScrollDirectionToState(
    SetScrollDirection event,
    Emitter<AppState> emit,
  ) {
    if (event.scrollDirection != state.scrollDirection) {
      emit(
        state.copyWith(
          scrollDirection: Nullable<ScrollDirection?>(event.scrollDirection),
        ),
      );
    }
  }

  void _onStreamConnectivityResultToState(
    StreamConnectivityResult event,
    Emitter<AppState> emit,
  ) {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
        (ConnectivityResult result) => add(SetConnectivityResult(result)));
  }

  void _onSetConnectivityResultToState(
    SetConnectivityResult event,
    Emitter<AppState> emit,
  ) {
    if (event.connectivityResult != state.connectivityResult) {
      emit(
        state.copyWith(
          connectivityResult:
              Nullable<ConnectivityResult?>(event.connectivityResult),
        ),
      );
    }
  }

  void _onStreamCompassEventToState(
    StreamCompassEvent event,
    Emitter<AppState> emit,
  ) {
    _headingSubscription?.cancel();

    if (AppConfig.isRelease()) {
      _headingStream = FlutterCompass.events;
      _headingSubscription = _headingStream
          ?.listen((CompassEvent event) => add(SetCompassEvent(event)));
    }
  }

  void _onSetCompassEventToState(
    SetCompassEvent event,
    Emitter<AppState> emit,
  ) {
    if (event.compassEvent.heading != state.compassEvent?.heading) {
      emit(
        state.copyWith(
          compassEvent: Nullable<CompassEvent?>(event.compassEvent),
        ),
      );
    }
  }

  Future<void> _saveDeviceInfo(PushNotification? pushNotification) async {
    if ((pushNotification != null) &&
        (pushNotification != PushNotification.off)) {
      String? deviceId = await getDeviceId();
      String? token = await FirebaseMessaging.instance.getToken();

      await pushNotificationSave(
        deviceId: deviceId,
        period: state.updatePeriod,
        pushNotification: state.pushNotification,
        pushNotificationExtras: state.pushNotificationExtras,
        units: state.units,
        fcmToken: token,
      );
    } else {
      String? deviceId = await getDeviceId();
      await pushNotificationRemove(deviceId: deviceId);
    }
  }

  @override
  AppState fromJson(
    Map<String, dynamic> jsonData,
  ) =>
      AppState(
        updatePeriod: getPeriod(id: jsonData['updatePeriod']),
        pushNotification: getPushNotification(jsonData['pushNotification']),
        pushNotificationExtras: (jsonData['pushNotificationExtras'] != null)
            ? NotificationExtras.fromJson(jsonData['pushNotificationExtras'])
            : null,
        themeMode: getThemeMode(jsonData['themeMode']),
        colorTheme: jsonData['colorTheme'],
        units: Units.fromJson(jsonData['units']),
        chartType: getChartType(jsonData['chartType']),
        hourRange: getForecastHourRange(jsonData['hourRange']),
        forecasts: Forecast.fromJsonList(jsonData['forecasts']),
        selectedForecastIndex: jsonData['selectedForecastIndex'],
      );

  @override
  Map<String, dynamic> toJson(
    AppState state,
  ) =>
      {
        'updatePeriod': state.updatePeriod?.getInfo()?['id'],
        'pushNotification': state.pushNotification?.getInfo()?['id'],
        'pushNotificationExtras': (state.pushNotificationExtras != null)
            ? state.pushNotificationExtras!.toJson()
            : null,
        'themeMode': state.themeMode.toString(),
        'colorTheme': state.colorTheme,
        'units': state.units.toJson(),
        'chartType': state.chartType.toString(),
        'hourRange': state.hourRange.toString(),
        'forecasts': Forecast.toJsonList(state.forecasts),
        'selectedForecastIndex': state.selectedForecastIndex,
      };
}
