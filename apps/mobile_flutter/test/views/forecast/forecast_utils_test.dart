import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/forecast_utils.dart';
import 'package:test/test.dart';

void main() {
  test('Should have forecasts', () {
    List<Forecast> forecasts = []..add(
        Forecast(
          id: 'abc123',
          postalCode: '90210',
        ),
      );

    expect(hasForecasts(forecasts), true);
  });

  test('Should NOT have forecasts', () {
    expect(hasForecasts(null), false);
    expect(hasForecasts([]), false);
  });
}
