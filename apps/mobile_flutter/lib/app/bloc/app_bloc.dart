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
import 'package:flutter_weather/enums/wind_speed_unit.dart';
import 'package:flutter_weather/forecast/forecast.dart';
import 'package:flutter_weather/models/models.dart';
import 'package:flutter_weather/services/services.dart';
import 'package:flutter_weather/settings/settings.dart';
import 'package:http/http.dart' as http;
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sentry/sentry.dart';
import 'package:stream_transform/stream_transform.dart';

part 'app_events.dart';
part 'app_state.dart';

class AppBloc extends HydratedBloc<AppEvent, AppState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  Stream<CompassEvent>? _headingStream;
  StreamSubscription<CompassEvent>? _headingSubscription;

  final StreamTransformer<CompassEvent, CompassEvent> _debounceCompass =
      StreamTransformer<CompassEvent, CompassEvent>.fromBind(
          (Stream<CompassEvent> stream) =>
              stream.debounce(const Duration(milliseconds: 10)));

  AppBloc() : super(AppState.initial());

  AppState get initialState => AppState.initial();

  @override
  Stream<AppState> mapEventToState(
    AppEvent event,
  ) async* {
    if (event is ToggleThemeMode) {
      yield _mapToggleThemeModeToStates(event);
    } else if (event is SetUpdatePeriod) {
      yield* _mapSetUpdatePeriodToStates(event);
    } else if (event is SetPushNotification) {
      yield* _mapSetPushNotificationToStates(event);
    } else if (event is SetThemeMode) {
      yield _mapSetThemeModeToStates(event);
    } else if (event is ToggleColorTheme) {
      yield _mapToggleColorThemeToStates(event);
    } else if (event is SetColorTheme) {
      yield _mapSetColorThemeToStates(event);
    } else if (event is SetTemperatureUnit) {
      yield* _mapSetTemperatureUnitToStates(event);
    } else if (event is SetWindSpeedUnit) {
      yield* _mapSetWindSpeedUnitToStates(event);
    } else if (event is SetPressureUnit) {
      yield* _mapSetPressureUnitToStates(event);
    } else if (event is SetDistanceUnit) {
      yield* _mapSetDistanceUnitToStates(event);
    } else if (event is SetChartType) {
      yield _mapSetChartTypeToStates(event);
    } else if (event is SetHourRange) {
      yield _mapSetHourRangeToStates(event);
    } else if (event is SelectedForecastIndex) {
      yield _mapSelectedForecastIndexToStates(event);
    } else if (event is AddForecast) {
      yield* _mapAddForecastToStates(event);
    } else if (event is UpdateForecast) {
      yield* _mapUpdateForecastToStates(event);
    } else if (event is RefreshForecast) {
      yield* _mapRefreshForecastToStates(event);
    } else if (event is DeleteForecast) {
      yield* _mapDeleteForecastToStates(event);
    } else if (event is ClearCRUDStatus) {
      yield _mapClearCRUDStatusToStates(event);
    } else if (event is SetActiveForecastId) {
      yield _mapSetActiveForecastIdToState(event);
    } else if (event is ClearActiveForecastId) {
      yield _mapClearActiveForecastIdToState(event);
    } else if (event is AutoUpdateForecast) {
      yield _mapAutoUpdateForecastToState(event);
    } else if (event is SetScrollDirection) {
      yield _mapSetScrollDirectionToState(event);
    } else if (event is StreamConnectivityResult) {
      yield* _mapStreamConnectivityResultToState(event);
    } else if (event is SetConnectivityResult) {
      yield _mapSetConnectivityResultToState(event);
    } else if (event is StreamCompassEvent) {
      yield* _mapStreamCompassEventToState(event);
    } else if (event is SetCompassEvent) {
      yield _mapSetCompassEventToState(event);
    } else if (event is SetIsPremium) {
      yield _mapSetIsPremiumToStates(event);
    } else if (event is SetShowPremiumInfo) {
      yield _mapSetShowPremiumInfoToStates(event);
    } else if (event is SetShowPremiumSuccess) {
      yield _mapSetShowPremiumSuccessToStates(event);
    }
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    _headingSubscription?.cancel();
    return super.close();
  }

  AppState _mapToggleThemeModeToStates(
    ToggleThemeMode event,
  ) =>
      state.copyWith(
        themeMode: (state.themeMode == ThemeMode.dark)
            ? ThemeMode.light
            : ThemeMode.dark,
        colorTheme: false,
      );

  Stream<AppState> _mapSetUpdatePeriodToStates(
    SetUpdatePeriod event,
  ) async* {
    AppPrefs prefs = AppPrefs();
    prefs.updatePeriod = event.updatePeriod;

    String? deviceId = await getDeviceId();

    yield state.copyWith(
      updatePeriod: Nullable<UpdatePeriod?>(event.updatePeriod),
      pushNotification: (event.updatePeriod == null)
          ? Nullable<PushNotification?>(null)
          : (state.pushNotification == null)
              ? Nullable<PushNotification?>(PushNotification.off)
              : Nullable<PushNotification?>(state.pushNotification),
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

  Stream<AppState> _mapSetPushNotificationToStates(
    SetPushNotification event,
  ) async* {
    AppPrefs prefs = AppPrefs();
    prefs.pushNotification = event.pushNotification;
    prefs.pushNotificationExtras = event.pushNotificationExtras;

    if ((prefs.pushNotification != null) &&
        (prefs.pushNotification != PushNotification.off)) {
      bool accessGranted = true;

      if (prefs.pushNotification == PushNotification.currentLocation) {
        accessGranted = await requestLocationPermission();
        if (accessGranted) {
          yield* _updatePushNotificationState(event);
        } else {
          showSnackbar(
            event.context,
            AppLocalizations.of(event.context)!.locationPermissionDenied,
            messageType: MessageType.danger,
          );

          if (state.pushNotification == PushNotification.currentLocation) {
            yield state.copyWith(
              pushNotification:
                  Nullable<PushNotification?>(PushNotification.off),
              pushNotificationExtras: Nullable<NotificationExtras?>(null),
            );
          }
        }
      } else {
        yield* _updatePushNotificationState(event);
      }
    } else {
      yield* _updatePushNotificationState(event);
    }
  }

  Stream<AppState> _updatePushNotificationState(
    SetPushNotification event,
  ) async* {
    if (event.callback != null) {
      event.callback!();
    }

    yield state.copyWith(
      pushNotification: Nullable<PushNotification?>(event.pushNotification),
      pushNotificationExtras:
          Nullable<NotificationExtras?>((event.pushNotificationExtras == null)
              ? null
              : NotificationExtras.fromJson({
                  ...state.pushNotificationExtras?.toJson() ?? {},
                  ...event.pushNotificationExtras?.toJson() ?? {},
                })),
    );

    await _saveDeviceInfo(event.pushNotification);

    showSnackbar(
      event.context,
      AppLocalizations.of(event.context)!.pushNotificationUpdated,
    );
  }

  AppState _mapSetThemeModeToStates(
    SetThemeMode event,
  ) =>
      state.copyWith(
        themeMode: event.themeMode,
        colorTheme: false,
      );

  AppState _mapToggleColorThemeToStates(
    ToggleColorTheme event,
  ) =>
      state.copyWith(
        colorTheme: !state.colorTheme,
      );

  AppState _mapSetColorThemeToStates(
    SetColorTheme event,
  ) =>
      state.copyWith(
        colorTheme: event.colorTheme,
      );

  Stream<AppState> _mapSetTemperatureUnitToStates(
    SetTemperatureUnit event,
  ) async* {
    AppPrefs prefs = AppPrefs();
    prefs.temperatureUnit = event.temperatureUnit;

    yield state.copyWith(
      units: state.units.copyWith(
        temperature: event.temperatureUnit,
      ),
    );

    await _saveDeviceInfo(prefs.pushNotification);
  }

  Stream<AppState> _mapSetWindSpeedUnitToStates(
    SetWindSpeedUnit event,
  ) async* {
    AppPrefs prefs = AppPrefs();
    prefs.windSpeedUnit = event.windSpeedUnit;

    yield state.copyWith(
      units: state.units.copyWith(
        windSpeed: event.windSpeedUnit,
      ),
    );

    await _saveDeviceInfo(prefs.pushNotification);
  }

  Stream<AppState> _mapSetPressureUnitToStates(
    SetPressureUnit event,
  ) async* {
    AppPrefs prefs = AppPrefs();
    prefs.pressureUnit = event.pressureUnit;

    yield state.copyWith(
      units: state.units.copyWith(
        pressure: event.pressureUnit,
      ),
    );

    await _saveDeviceInfo(prefs.pushNotification);
  }

  Stream<AppState> _mapSetDistanceUnitToStates(
    SetDistanceUnit event,
  ) async* {
    AppPrefs prefs = AppPrefs();
    prefs.distanceUnit = event.distanceUnit;

    yield state.copyWith(
      units: state.units.copyWith(
        distance: event.distanceUnit,
      ),
    );

    await _saveDeviceInfo(prefs.pushNotification);
  }

  AppState _mapSetChartTypeToStates(
    SetChartType event,
  ) =>
      state.copyWith(
        chartType: event.chartType,
      );

  AppState _mapSetHourRangeToStates(
    SetHourRange event,
  ) {
    if (event.hourRange == state.hourRange) {
      return state;
    }

    return state.copyWith(
      hourRange: event.hourRange,
    );
  }

  AppState _mapSelectedForecastIndexToStates(
    SelectedForecastIndex event,
  ) {
    if (event.index == state.selectedForecastIndex) {
      return state;
    }

    return state.copyWith(
      selectedForecastIndex: event.index,
    );
  }

  Stream<AppState> _mapAddForecastToStates(
    AddForecast event,
  ) async* {
    yield state.copyWith(
      crudStatus: Nullable<CRUDStatus>(CRUDStatus.creating),
    );

    List<Forecast> forecasts = sortForecasts(
        List<Forecast>.from(state.forecasts) // Clone the existing state list
          ..add(event.forecast));

    yield state.copyWith(
      forecasts: forecasts,
      crudStatus: Nullable<CRUDStatus>(CRUDStatus.created),
      selectedForecastIndex: forecasts.indexWhere((Forecast forecast) =>
          (forecast.postalCode == event.forecast.postalCode)),
    );
  }

  Stream<AppState> _mapUpdateForecastToStates(
    UpdateForecast event,
  ) async* {
    yield state.copyWith(
      crudStatus: Nullable<CRUDStatus>(CRUDStatus.updating),
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

    yield state.copyWith(
      activeForecastId: Nullable<String?>(null),
      forecasts: forecasts,
      crudStatus: Nullable<CRUDStatus>(CRUDStatus.updated),
    );

    add(
      RefreshForecast(
        event.context,
        forecasts[state.selectedForecastIndex],
        state.units.temperature,
      ),
    );
  }

  Stream<AppState> _mapRefreshForecastToStates(
    RefreshForecast event,
  ) async* {
    yield state.copyWith(
      refreshStatus: Nullable<RefreshStatus>(RefreshStatus.refreshing),
      crudStatus: Nullable<CRUDStatus?>(null),
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
          isPremium: state.isPremium,
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

            yield state;
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

            yield state.copyWith(
              forecasts: forecasts,
              refreshStatus: Nullable<RefreshStatus?>(null),
              crudStatus: Nullable<CRUDStatus?>(null),
            );
          }
        } else {
          showSnackbar(
            event.context,
            AppLocalizations.of(event.context)!.refreshFailure,
            messageType: MessageType.danger,
          );

          yield state.copyWith(
            refreshStatus: Nullable<RefreshStatus?>(null),
            crudStatus: Nullable<CRUDStatus?>(null),
          );
        }
      } else {
        showSnackbar(
          event.context,
          AppLocalizations.of(event.context)!.connectivityFailure,
          messageType: MessageType.danger,
        );

        yield state.copyWith(
          refreshStatus: Nullable<RefreshStatus?>(null),
          crudStatus: Nullable<CRUDStatus?>(null),
        );
      }
    } on Exception catch (exception, stackTrace) {
      await Sentry.captureException(exception, stackTrace: stackTrace);

      showSnackbar(
        event.context,
        AppLocalizations.of(event.context)!.refreshFailure,
        messageType: MessageType.danger,
      );

      yield state.copyWith(
        refreshStatus: Nullable<RefreshStatus?>(null),
        crudStatus: Nullable<CRUDStatus?>(null),
      );
    }
  }

  Stream<AppState> _mapDeleteForecastToStates(
    DeleteForecast event,
  ) async* {
    yield state.copyWith(
      crudStatus: Nullable<CRUDStatus>(CRUDStatus.deleting),
    );

    int _forecastIndex = state.forecasts
        .indexWhere((Forecast forecast) => forecast.id == event.forecastId);

    List<Forecast> _forecasts = state.forecasts..removeAt(_forecastIndex);

    yield state.copyWith(
      activeForecastId: Nullable<String?>(null),
      colorTheme: hasForecasts(_forecasts) ? state.colorTheme : false,
      forecasts: _forecasts,
      selectedForecastIndex: (state.selectedForecastIndex > 0)
          ? (state.selectedForecastIndex - 1)
          : 0,
      crudStatus: Nullable<CRUDStatus>(CRUDStatus.deleted),
    );
  }

  AppState _mapClearCRUDStatusToStates(
    ClearCRUDStatus event,
  ) =>
      state.copyWith(crudStatus: Nullable<CRUDStatus?>(null));

  AppState _mapSetActiveForecastIdToState(
    SetActiveForecastId event,
  ) =>
      state.copyWith(
        activeForecastId: Nullable<String?>(event.forecastId),
      );

  AppState _mapClearActiveForecastIdToState(
    ClearActiveForecastId event,
  ) =>
      state.copyWith(
        activeForecastId: Nullable<String?>(null),
      );

  AppState _mapAutoUpdateForecastToState(
    AutoUpdateForecast event,
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

    return state;
  }

  AppState _mapSetScrollDirectionToState(
    SetScrollDirection event,
  ) {
    if (event.scrollDirection == state.scrollDirection) {
      return state;
    }

    return state.copyWith(
      scrollDirection: Nullable<ScrollDirection?>(event.scrollDirection),
    );
  }

  Stream<AppState> _mapStreamConnectivityResultToState(
    StreamConnectivityResult event,
  ) async* {
    _connectivitySubscription?.cancel();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
        (ConnectivityResult result) => add(SetConnectivityResult(result)));

    yield state;
  }

  AppState _mapSetConnectivityResultToState(
    SetConnectivityResult event,
  ) {
    if (event.connectivityResult == state.connectivityResult) {
      return state;
    }

    return state.copyWith(
      connectivityResult:
          Nullable<ConnectivityResult?>(event.connectivityResult),
    );
  }

  Stream<AppState> _mapStreamCompassEventToState(
    StreamCompassEvent event,
  ) async* {
    _headingSubscription?.cancel();

    if (AppConfig.isRelease()) {
      _headingStream = FlutterCompass.events;
      _headingSubscription = _headingStream
          ?.transform(_debounceCompass)
          .listen((CompassEvent event) => add(SetCompassEvent(event)));
    }

    yield state;
  }

  AppState _mapSetCompassEventToState(
    SetCompassEvent event,
  ) {
    if (event.compassEvent.heading == state.compassEvent?.heading) {
      return state;
    }

    return state.copyWith(
      compassEvent: Nullable<CompassEvent?>(event.compassEvent),
    );
  }

  AppState _mapSetIsPremiumToStates(
    SetIsPremium event,
  ) =>
      state.copyWith(
        isPremium: event.isPremium,
      );

  AppState _mapSetShowPremiumInfoToStates(
    SetShowPremiumInfo event,
  ) =>
      state.copyWith(
        showPremiumInfo: event.showPremiumInfo,
      );

  AppState _mapSetShowPremiumSuccessToStates(
    SetShowPremiumSuccess event,
  ) =>
      state.copyWith(
        showPremiumSuccess: event.showPremiumSuccess,
      );

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
