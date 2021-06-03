import 'package:flutter_weather/enums/enums.dart';
import 'package:flutter_weather/views/forecast/forecast_utils.dart';
import 'package:test/test.dart';

void main() {
  test('Temperature should be 0', () {
    expect(getTemperature(null, TemperatureUnit.fahrenheit), 0.0);
    expect(getTemperature(null, TemperatureUnit.celsius), 0.0);
    expect(getTemperature(null, TemperatureUnit.kelvin), 0.0);
  });

  test('Temperature should be 90F', () {
    expect(getTemperature(305.2056, TemperatureUnit.fahrenheit), 90.0); // 89.7F
    expect(getTemperature(305.2611, TemperatureUnit.fahrenheit), 90.0); // 89.8F
    expect(getTemperature(305.3167, TemperatureUnit.fahrenheit), 90.0); // 89.9F
    expect(getTemperature(305.372, TemperatureUnit.fahrenheit), 90.0); // 90.0F
    expect(getTemperature(305.4278, TemperatureUnit.fahrenheit), 90.0); // 90.1F
    expect(getTemperature(305.4833, TemperatureUnit.fahrenheit), 90.0); // 90.2F
    expect(
        getTemperature(305.50556, TemperatureUnit.fahrenheit), 90.0); // 90.24F
  });

  test('Temperature should be 95F', () {
    expect(getTemperature(307.9833, TemperatureUnit.fahrenheit), 95.0); // 94.7F
    expect(getTemperature(308.0389, TemperatureUnit.fahrenheit), 95.0); // 94.8F
    expect(getTemperature(308.0944, TemperatureUnit.fahrenheit), 95.0); // 94.9F
    expect(getTemperature(308.15, TemperatureUnit.fahrenheit), 95.0); // 95.0F
    expect(getTemperature(308.2056, TemperatureUnit.fahrenheit), 95.0); // 95.1F
    expect(getTemperature(308.2611, TemperatureUnit.fahrenheit), 95.0); // 95.2F
    expect(
        getTemperature(308.28333, TemperatureUnit.fahrenheit), 95.0); // 95.24F
  });

  test('Temperature should be 32C', () {
    expect(getTemperature(305.2056, TemperatureUnit.celsius), 32.0); // 89.7F
    expect(getTemperature(305.2611, TemperatureUnit.celsius), 32.0); // 89.8F
    expect(getTemperature(305.3167, TemperatureUnit.celsius), 32.0); // 89.9F
    expect(getTemperature(305.372, TemperatureUnit.celsius), 32.0); // 90.0F
    expect(getTemperature(305.4278, TemperatureUnit.celsius), 32.0); // 90.1F
    expect(getTemperature(305.4833, TemperatureUnit.celsius), 32.0); // 90.2F
    expect(getTemperature(305.50556, TemperatureUnit.celsius), 32.0); // 90.24F
  });

  test('Temperature should be 35C', () {
    expect(getTemperature(307.9833, TemperatureUnit.celsius), 35.0); // 94.7F
    expect(getTemperature(308.0389, TemperatureUnit.celsius), 35.0); // 94.8F
    expect(getTemperature(308.0944, TemperatureUnit.celsius), 35.0); // 94.9F
    expect(getTemperature(308.15, TemperatureUnit.celsius), 35.0); // 95.0F
    expect(getTemperature(308.2056, TemperatureUnit.celsius), 35.0); // 95.1F
    expect(getTemperature(308.2611, TemperatureUnit.celsius), 35.0); // 95.2F
    expect(getTemperature(308.28333, TemperatureUnit.celsius), 35.0); // 95.24F
  });

  test('Temperature should be in Kelvin', () {
    expect(getTemperature(305.2056, TemperatureUnit.kelvin), 305.21); // 89.7F
    expect(getTemperature(305.2611, TemperatureUnit.kelvin), 305.26); // 89.8F
    expect(getTemperature(305.3167, TemperatureUnit.kelvin), 305.32); // 89.9F
    expect(getTemperature(305.372, TemperatureUnit.kelvin), 305.37); // 90.0F
    expect(getTemperature(305.4278, TemperatureUnit.kelvin), 305.43); // 90.1F
    expect(getTemperature(305.4833, TemperatureUnit.kelvin), 305.48); // 90.2F
    expect(getTemperature(305.50556, TemperatureUnit.kelvin), 305.51); // 90.24F
  });

  test('Temperature should be in Kelvin', () {
    expect(getTemperature(307.9833, TemperatureUnit.kelvin), 307.98); // 94.7F
    expect(getTemperature(308.0389, TemperatureUnit.kelvin), 308.04); // 94.8F
    expect(getTemperature(308.0944, TemperatureUnit.kelvin), 308.09); // 94.9F
    expect(getTemperature(308.15, TemperatureUnit.kelvin), 308.15); // 95.0F
    expect(getTemperature(308.2056, TemperatureUnit.kelvin), 308.21); // 95.1F
    expect(getTemperature(308.2611, TemperatureUnit.kelvin), 308.26); // 95.2F
    expect(getTemperature(308.28333, TemperatureUnit.kelvin), 308.28); // 95.24F
  });

  test('Wind speed should be 0', () {
    expect(getWindSpeed(null, WindSpeedUnit.mph), 0.0);
    expect(getWindSpeed(null, WindSpeedUnit.kmh), 0.0);
    expect(getWindSpeed(null, WindSpeedUnit.ms), 0.0);
  });

  test('Wind speed should be 10 mph', () {
    expect(getWindSpeed(10.0, WindSpeedUnit.mph), 10.0); // 10mph
  });

  test('Wind speed should be 16 km/h', () {
    expect(getWindSpeed(10.0, WindSpeedUnit.kmh), 16.1); // 10mph
  });

  test('Wind speed should be 4.5 m/s', () {
    expect(getWindSpeed(10.0, WindSpeedUnit.ms), 4.5); // 10mph
  });

  test('Pressure should be 0', () {
    expect(getPressure(null, PressureUnit.hpa), 0.0);
    expect(getPressure(null, PressureUnit.inhg), 0.0);
  });

  test('Pressure should be 1003 hPa', () {
    expect(getPressure(1003, PressureUnit.hpa), 1003); // 29.62 inHg
  });

  test('Pressure should be 29.62 inHg', () {
    expect(getPressure(1003, PressureUnit.inhg), 29.62); // 29.62 inHg
  });
}
