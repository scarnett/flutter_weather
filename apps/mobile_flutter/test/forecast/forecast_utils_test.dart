import 'package:flutter_weather/forecast/forecast.dart';
import 'package:flutter_weather/models/models.dart';
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

  test('Should scrub the weather alert description', () {
    String description = '...HEAT ADVISORY REMAINS IN EFFECT FROM 1 PM ' +
        'THIS AFTERNOON TO\n8 PM CDT THIS EVENING...\n* WHAT...Heat index ' +
        'values of 105 to 109 degrees expected.\n* WHERE...Creek, Okfuskee, ' +
        'Okmulgee, McIntosh, Pittsburg,\nLatimer, Pushmataha, and Choctaw ' +
        'Counties.\n* WHEN...From 1 PM to 8 PM CDT Thursday.\n* IMPACTS...' +
        'The combination of hot temperatures and high\nhumidity will combine ' +
        'to create a dangerous situation in which\nheat illnesses are ' +
        'possible.';

    expect(
      scrubAlertDescription(description),
      [
        {
          'label': null,
          'text': 'HEAT ADVISORY REMAINS IN EFFECT FROM 1 PM THIS ' +
              'AFTERNOON TO 8 PM CDT THIS EVENING'
        },
        {
          'label': 'WHAT',
          'text': 'Heat index values of 105 to 109 degrees expected.'
        },
        {
          'label': 'WHERE',
          'text': 'Creek, Okfuskee, Okmulgee, McIntosh, Pittsburg, ' +
              'Latimer, Pushmataha, and Choctaw Counties.'
        },
        {
          'label': 'WHEN',
          'text': 'From 1 PM to 8 PM CDT Thursday.',
        },
        {
          'label': 'IMPACTS',
          'text': 'The combination of hot temperatures and high humidity ' +
              'will combine to create a dangerous situation in which heat ' +
              'illnesses are possible.'
        }
      ],
    );
  });
}
