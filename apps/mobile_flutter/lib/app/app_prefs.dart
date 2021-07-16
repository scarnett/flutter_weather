import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_weather/enums/enums.dart';
import 'package:flutter_weather/models/models.dart';
import 'package:flutter_weather/settings/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String appStateKey = 'appState';
const String updatePeriodKey = 'updatePeriod';
const String pushNotificationKey = 'pushNotification';
const String pushNotificationExtrasKey = 'pushNotificationExtras';
const String temperatureUnitKey = 'temperatureUnit';
const String windSpeedUnitKey = 'windSpeedUnitKey';
const String pressureUnitKey = 'pressureUnitKey';
const String distanceUnitKey = 'distanceUnitKey';

class AppPrefs {
  static late SharedPreferences _sharedPrefs;

  factory AppPrefs() => AppPrefs._internal();

  AppPrefs._internal();

  Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }

  int get appState => _sharedPrefs.getInt(appStateKey) ?? 0;

  set appState(
    int? appState,
  ) {
    _sharedPrefs.setInt(appStateKey, appState ?? 0);
  }

  UpdatePeriod? getUpdatePeriod(
    BuildContext context,
  ) =>
      getPeriod(
        context: context,
        id: _sharedPrefs.getString(updatePeriodKey),
      ) ??
      null;

  set updatePeriod(
    UpdatePeriod? updatePeriod,
  ) {
    if (updatePeriod == null) {
      _sharedPrefs.remove(updatePeriodKey);
    } else {
      _sharedPrefs.setString(updatePeriodKey, updatePeriod.getInfo()!['id']);
    }
  }

  PushNotification? get pushNotification =>
      getPushNotification(_sharedPrefs.getString(pushNotificationKey)) ?? null;

  set pushNotification(
    PushNotification? pushNotification,
  ) {
    if (pushNotification == null) {
      _sharedPrefs.remove(pushNotificationKey);
    } else {
      _sharedPrefs.setString(
          pushNotificationKey, pushNotification.getInfo()!['id']);
    }
  }

  NotificationExtras? get pushNotificationExtras {
    String? pushNotificationExtras =
        _sharedPrefs.getString(pushNotificationExtrasKey);

    if (pushNotificationExtras == null) {
      return null;
    }

    return NotificationExtras.fromJson(pushNotificationExtras);
  }

  set pushNotificationExtras(
    NotificationExtras? pushNotificationExtras,
  ) {
    if (pushNotificationExtras == null) {
      _sharedPrefs.remove(pushNotificationExtrasKey);
    } else {
      _sharedPrefs.setString(pushNotificationExtrasKey,
          json.encode(pushNotificationExtras.toJson()));
    }
  }

  TemperatureUnit get temperatureUnit =>
      getTemperatureUnit(_sharedPrefs.getString(temperatureUnitKey));

  set temperatureUnit(
    TemperatureUnit? temperatureUnit,
  ) {
    _sharedPrefs.setString(temperatureUnitKey, temperatureUnit.toString());
  }

  WindSpeedUnit get windSpeedUnit =>
      getWindSpeedUnit(_sharedPrefs.getString(windSpeedUnitKey));

  set windSpeedUnit(
    WindSpeedUnit? speedUnit,
  ) {
    _sharedPrefs.setString(windSpeedUnitKey, speedUnit.toString());
  }

  PressureUnit get pressureUnit =>
      getPressureUnit(_sharedPrefs.getString(pressureUnitKey));

  set pressureUnit(
    PressureUnit? pressureUnit,
  ) {
    _sharedPrefs.setString(pressureUnitKey, pressureUnit.toString());
  }

  DistanceUnit get distanceUnit =>
      getDistanceUnit(_sharedPrefs.getString(distanceUnitKey));

  set distanceUnit(
    DistanceUnit? pressureUnit,
  ) {
    _sharedPrefs.setString(distanceUnitKey, distanceUnit.toString());
  }
}
