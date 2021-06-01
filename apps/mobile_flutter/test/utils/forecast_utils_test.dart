import 'package:flutter_weather/enums.dart';
import 'package:flutter_weather/views/forecast/forecast_utils.dart';
import 'package:test/test.dart';

void main() {
  test('Should be 0', () {
    expect(getTemperature(null, TemperatureUnit.fahrenheit), 0.0);
    expect(getTemperature(null, TemperatureUnit.celsius), 0.0);
    expect(getTemperature(null, TemperatureUnit.kelvin), 0.0);
  });

  test('Should be 90F', () {
    expect(getTemperature(305.2056, TemperatureUnit.fahrenheit), 90.0); // 89.7F
    expect(getTemperature(305.2611, TemperatureUnit.fahrenheit), 90.0); // 89.8F
    expect(getTemperature(305.3167, TemperatureUnit.fahrenheit), 90.0); // 89.9F
    expect(getTemperature(305.372, TemperatureUnit.fahrenheit), 90.0); // 90.0F
    expect(getTemperature(305.4278, TemperatureUnit.fahrenheit), 90.0); // 90.1F
    expect(getTemperature(305.4833, TemperatureUnit.fahrenheit), 90.0); // 90.2F
    expect(
        getTemperature(305.50556, TemperatureUnit.fahrenheit), 90.0); // 90.24F
  });

  test('Should be 95F', () {
    expect(getTemperature(307.9833, TemperatureUnit.fahrenheit), 95.0); // 94.7F
    expect(getTemperature(308.0389, TemperatureUnit.fahrenheit), 95.0); // 94.8F
    expect(getTemperature(308.0944, TemperatureUnit.fahrenheit), 95.0); // 94.9F
    expect(getTemperature(308.15, TemperatureUnit.fahrenheit), 95.0); // 95.0F
    expect(getTemperature(308.2056, TemperatureUnit.fahrenheit), 95.0); // 95.1F
    expect(getTemperature(308.2611, TemperatureUnit.fahrenheit), 95.0); // 95.2F
    expect(
        getTemperature(308.28333, TemperatureUnit.fahrenheit), 95.0); // 95.24F
  });

  test('Should be 32C', () {
    expect(getTemperature(305.2056, TemperatureUnit.celsius), 32.0); // 89.7F
    expect(getTemperature(305.2611, TemperatureUnit.celsius), 32.0); // 89.8F
    expect(getTemperature(305.3167, TemperatureUnit.celsius), 32.0); // 89.9F
    expect(getTemperature(305.372, TemperatureUnit.celsius), 32.0); // 90.0F
    expect(getTemperature(305.4278, TemperatureUnit.celsius), 32.0); // 90.1F
    expect(getTemperature(305.4833, TemperatureUnit.celsius), 32.0); // 90.2F
    expect(getTemperature(305.50556, TemperatureUnit.celsius), 32.0); // 90.24F
  });

  test('Should be 35C', () {
    expect(getTemperature(307.9833, TemperatureUnit.celsius), 35.0); // 94.7F
    expect(getTemperature(308.0389, TemperatureUnit.celsius), 35.0); // 94.8F
    expect(getTemperature(308.0944, TemperatureUnit.celsius), 35.0); // 94.9F
    expect(getTemperature(308.15, TemperatureUnit.celsius), 35.0); // 95.0F
    expect(getTemperature(308.2056, TemperatureUnit.celsius), 35.0); // 95.1F
    expect(getTemperature(308.2611, TemperatureUnit.celsius), 35.0); // 95.2F
    expect(getTemperature(308.28333, TemperatureUnit.celsius), 35.0); // 95.24F
  });
}
