import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/views/lookup/lookup_utils.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockAppLocalizations extends Mock implements AppLocalizations {
  String get addForecast => 'Add Forecast';
  String get country => 'Country';
}

void main() {
  late AppLocalizations _localizations;

  setUp(() {
    _localizations = MockAppLocalizations();
  });

  test('Should have NOT have a title', () {
    expect(getTitle(null, null), null);
  });

  test('Should have \'add forecast\' title', () {
    expect(getTitle(_localizations, 0), 'Add Forecast');
  });

  test('Should have \'add forecast\' title', () {
    expect(getTitle(_localizations, null), 'Add Forecast');
  });

  test('Should have \'country\' title', () {
    expect(getTitle(_localizations, 1), 'Country');
  });
}
