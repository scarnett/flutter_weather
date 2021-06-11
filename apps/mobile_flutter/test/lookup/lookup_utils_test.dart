import 'package:flutter_weather/app/app_localization.dart';
import 'package:flutter_weather/lookup/lookup.dart';
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
    expect(getLookupTitle(null, null), '');
  });

  test('Should have \'add forecast\' title', () {
    expect(getLookupTitle(_localizations, 0), 'Add Forecast');
  });

  test('Should have \'add forecast\' title', () {
    expect(getLookupTitle(_localizations, null), 'Add Forecast');
  });

  test('Should have \'country\' title', () {
    expect(getLookupTitle(_localizations, 1), 'Country');
  });
}
