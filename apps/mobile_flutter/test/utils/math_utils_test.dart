import 'package:flutter_weather/enums/enums.dart';
import 'package:flutter_weather/forecast/forecast_utils.dart';
import 'package:flutter_weather/utils/math_utils.dart';
import 'package:test/test.dart';

void main() {
  test('Should be 90', () {
    expect(round5(number: 85.0), 90.0);
    expect(round5(number: 86.0), 90.0);
    expect(round5(number: 87.0), 90.0);
    expect(round5(number: 88.0), 90.0);
    expect(round5(number: 89.0), 90.0);
    expect(round5(number: 91.0), 90.0);
  });

  test('Should be 95', () {
    expect(round5(number: 90.0), 95.0);
    expect(round5(number: 91.0), 95.0);
    expect(round5(number: 92.0), 95.0);
    expect(round5(number: 93.0), 95.0);
    expect(round5(number: 94.0), 95.0);

    num temp = getTemperature(305.372, TemperatureUnit.fahrenheit); // 90.0F
    expect(round5(number: temp), 95.0);

    temp = getTemperature(305.928, TemperatureUnit.fahrenheit); // 91.0F
    expect(round5(number: temp), 95.0);

    temp = getTemperature(306.483, TemperatureUnit.fahrenheit); // 92.0F
    expect(round5(number: temp), 95.0);

    temp = getTemperature(307.039, TemperatureUnit.fahrenheit); // 93.0F
    expect(round5(number: temp), 95.0);

    temp = getTemperature(307.594, TemperatureUnit.fahrenheit); // 94.0F
    expect(round5(number: temp), 95.0);
  });

  test('Should be 100', () {
    expect(round5(number: 95.0), 100.0);
  });
}
