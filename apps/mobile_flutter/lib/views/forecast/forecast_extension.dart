import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_weather/enums.dart';
import 'package:flutter_weather/utils/common_utils.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/forecast_utils.dart';

extension ForecastExtension on Forecast {
  Color getTemperatureColor() {
    num? temperature = this.list!.first.temp!.day;
    num _temperature = getTemperature(temperature, TemperatureUnit.fahrenheit);
    if (_temperature > 100) {
      return Colors.red[900]!;
    } else if ((_temperature > 90) && (_temperature <= 100)) {
      return Colors.red;
    } else if ((_temperature > 80) && (_temperature <= 90)) {
      return Colors.deepOrange;
    } else if ((_temperature > 70) && (_temperature <= 80)) {
      return Colors.orange;
    } else if ((_temperature > 60) && (_temperature <= 70)) {
      return Colors.amber;
    } else if ((_temperature > 50) && (_temperature <= 60)) {
      return Colors.yellow;
    } else if ((_temperature > 40) && (_temperature <= 50)) {
      return Colors.lightGreen;
    } else if ((_temperature > 30) && (_temperature <= 40)) {
      return Colors.green;
    } else if ((_temperature > 20) && (_temperature <= 30)) {
      return Colors.cyan;
    } else if ((_temperature > 10) && (_temperature <= 20)) {
      return Colors.blue;
    } else if ((_temperature > 0) && (_temperature <= 10)) {
      return Colors.indigo;
    } else if ((_temperature > -10) && (_temperature <= 0)) {
      return Colors.purple;
    } else if ((_temperature > -20) && (_temperature <= -10)) {
      return Colors.deepPurple;
    } else if ((_temperature > -30) && (_temperature <= -20)) {
      return Colors.deepPurple[100]!;
    }

    return Colors.blueGrey[50]!;
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
}
