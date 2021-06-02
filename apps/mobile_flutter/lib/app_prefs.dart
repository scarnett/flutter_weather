import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_weather/enums/enums.dart';
import 'package:flutter_weather/views/settings/settings_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String appStateKey = 'appState';
const String updatePeriodKey = 'updatePeriod';
const String pushNotificationKey = 'pushNotification';
const String pushNotificationExtrasKey = 'pushNotificationExtras';
const String temperatureUnitKey = 'temperatureUnit';

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

  Map<String, dynamic>? get pushNotificationExtras {
    String? pushNotificationExtras =
        _sharedPrefs.getString(pushNotificationExtrasKey);

    if (pushNotificationExtras == null) {
      return null;
    }

    return json.decode(pushNotificationExtras);
  }

  set pushNotificationExtras(
    Map<String, dynamic>? pushNotificationExtras,
  ) {
    _sharedPrefs.setString(
        pushNotificationExtrasKey, json.encode(pushNotificationExtras));
  }

  TemperatureUnit get temperatureUnit =>
      getTemperatureUnit(_sharedPrefs.getString(temperatureUnitKey));

  set temperatureUnit(
    TemperatureUnit? temperatureUnit,
  ) {
    _sharedPrefs.setString(temperatureUnitKey, temperatureUnit.toString());
  }
}
