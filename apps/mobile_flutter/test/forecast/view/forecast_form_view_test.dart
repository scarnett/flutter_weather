import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_weather/app/app_keys.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';
import 'package:flutter_weather/forecast/view/forecast_form_view.dart';
import 'package:mocktail/mocktail.dart';

import '../../utils/pump_utils.dart';

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class FakeAppEvent extends Fake implements AppEvent {}

class FakeAppState extends Fake implements AppState {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeAppEvent());
    registerFallbackValue(FakeAppState());
  });

  group('SettingsVersionStatusText', () {
    late AppBloc _appBloc;

    setUp(() {
      _appBloc = MockAppBloc();
      when(() => _appBloc.state).thenReturn(AppState());
    });

    testWidgets('Should have \'Edit Forecast\' appbar text',
        (WidgetTester tester) async {
      await tester.pumpApp(
        ForecastFormView(),
        appBloc: _appBloc,
      );

      await tester.pumpAndSettle();
      expect(find.text('Edit Forecast'), findsOneWidget);
    });

    testWidgets('Should have \'Country\' appbar text',
        (WidgetTester tester) async {
      await tester.pumpApp(
        ForecastFormView(),
        appBloc: _appBloc,
      );

      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(Key(AppKeys.locationCountryKey)),
        warnIfMissed: false,
      );

      expect(find.text('Country'), findsOneWidget);
    });
  });
}
