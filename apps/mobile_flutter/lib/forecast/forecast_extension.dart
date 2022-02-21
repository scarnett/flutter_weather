import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_weather/app/utils/utils.dart';
import 'package:flutter_weather/enums/enums.dart';
import 'package:flutter_weather/forecast/forecast.dart' as utils;
import 'package:flutter_weather/models/models.dart';

extension ForecastExtension on Forecast {
  Color getTemperatureColor() {
    num? temperature = this.list!.first.temp!.day;
    num _temperature =
        utils.getTemperature(temperature, TemperatureUnit.fahrenheit);
    return utils.getTemperatureColor(_temperature);
  }

  String getLocationText({
    bool includeCityName: true,
    bool includePostalCode: true,
    bool includeCountryCode: true,
  }) {
    String text = '';

    if (includeCityName) {
      if (!this.cityName.isNullOrEmpty()) {
        text += '${this.cityName}, ';
      } else if ((this.city != null) && !this.city!.name.isNullOrEmpty()) {
        text += '${this.city!.name}, ';
      }
    }

    if (includePostalCode && !this.postalCode.isNullOrEmpty()) {
      text += '${this.postalCode!.toUpperCase()}, ';
    }

    if (includeCountryCode) {
      if (!this.countryCode.isNullOrEmpty()) {
        text += this.countryCode!.toUpperCase();
      } else if ((this.city != null) && !this.city!.country.isNullOrEmpty()) {
        text += this.city!.country!.toUpperCase();
      }
    }

    String trimmedText = text.trim();
    if (trimmedText.isNotEmpty && trimmedText.endsWith(',')) {
      trimmedText = trimmedText.substring(0, (trimmedText.length - 1));
    }

    return trimmedText;
  }

  List<ForecastDaily> filterDays({
    required bool isPremium,
  }) {
    int maxTemps = utils.getDailyForecastCount(isPremium);
    if (maxTemps > this.details!.daily!.length) {
      return this.details!.daily!;
    }

    return this.details!.daily!.sublist(0, maxTemps).toList();
  }

  ForecastDaily getDayHighMax({
    required bool isPremium,
  }) =>
      filterDays(isPremium: isPremium).reduce(
          (ForecastDaily current, ForecastDaily next) =>
              (current.temp!.max! > next.temp!.max!) ? current : next);

  ForecastDaily getDayHighMin({
    required bool isPremium,
  }) =>
      filterDays(isPremium: isPremium).reduce(
          (ForecastDaily current, ForecastDaily next) =>
              (current.temp!.max! < next.temp!.max!) ? current : next);

  ForecastDaily getDayLowMax({
    required bool isPremium,
  }) =>
      filterDays(isPremium: isPremium).reduce(
          (ForecastDaily current, ForecastDaily next) =>
              (current.temp!.min! > next.temp!.min!) ? current : next);

  ForecastDaily getDayLowMin({
    required bool isPremium,
  }) =>
      filterDays(isPremium: isPremium).reduce(
          (ForecastDaily current, ForecastDaily next) =>
              (current.temp!.min! < next.temp!.min!) ? current : next);

  List<Color> getDayHighTemperatureColors() => this
      .details!
      .daily!
      .map((ForecastDaily day) => utils.getTemperatureColor(day.temp!.max!))
      .toList();

  List<Color> getDayLowTemperatureColors() => this
      .details!
      .daily!
      .map((ForecastDaily day) => utils.getTemperatureColor(day.temp!.min!))
      .toList();

  bool hasAlerts() => ((this.details?.alerts?.length ?? 0) > 0);
}
