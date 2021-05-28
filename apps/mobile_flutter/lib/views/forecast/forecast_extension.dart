import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_weather/enums.dart';
import 'package:flutter_weather/utils/common_utils.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/forecast_utils.dart' as utils;

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

  ForecastDaily getDayHighMax() =>
      this.details!.daily!.reduce((ForecastDaily current, ForecastDaily next) =>
          (current.temp!.max! > next.temp!.max!) ? current : next);

  ForecastDaily getDayHighMin() =>
      this.details!.daily!.reduce((ForecastDaily current, ForecastDaily next) =>
          (current.temp!.max! < next.temp!.max!) ? current : next);

  ForecastDaily getDayLowMax() =>
      this.details!.daily!.reduce((ForecastDaily current, ForecastDaily next) =>
          (current.temp!.min! > next.temp!.min!) ? current : next);

  ForecastDaily getDayLowMIn() =>
      this.details!.daily!.reduce((ForecastDaily current, ForecastDaily next) =>
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
}
