import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_weather/app/app_keys.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';
import 'package:flutter_weather/forecast/bloc/forecast_form_bloc.dart';
import 'package:flutter_weather/forecast/view/forecast_form_view.dart';
import 'package:flutter_weather/lookup/lookup.dart';
import 'package:mocktail/mocktail.dart';

import '../../utils/pump_utils.dart';

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class MockLookupBloc extends MockBloc<LookupEvent, LookupState>
    implements LookupBloc {}

class MockForecastFormBloc
    extends MockBloc<FormBlocEvent, FormBlocState<String, String>>
    implements ForecastFormBloc {}

class FakeAppEvent extends Fake implements AppEvent {}

class FakeAppState extends Fake implements AppState {}

class FakeLookupEvent extends Fake implements LookupEvent {}

class FakeLookupState extends Fake implements LookupState {}

class FakeFormBlocState extends Fake implements FormBlocState<String, String> {}

class FakeFormBlocEvent extends Fake implements FormBlocEvent {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeFormBlocState());
    registerFallbackValue(FakeFormBlocEvent());
    registerFallbackValue(FakeAppEvent());
    registerFallbackValue(FakeAppState());
    registerFallbackValue(FakeLookupEvent());
    registerFallbackValue(FakeLookupState());
  });

  group('LookupView', () {
    late ForecastFormBloc _forecastFormBloc;
    late AppBloc _appBloc;
    late LookupBloc _lookupBloc;

    setUp(() {
      _forecastFormBloc = MockForecastFormBloc();
      _appBloc = MockAppBloc();
      _lookupBloc = MockLookupBloc();

      when(() => _forecastFormBloc.state).thenReturn(FakeFormBlocState());
      when(() => _appBloc.state).thenReturn(AppState());
      when(() => _lookupBloc.state).thenReturn(LookupState());
    });

    testWidgets('Should have \'Add Forecast\' appbar text',
        (WidgetTester tester) async {
      await tester.pumpApp(
        LookupView(),
        forecastFormBloc: _forecastFormBloc,
        appBloc: _appBloc,
        lookupBloc: _lookupBloc,
      );

      await tester.pumpAndSettle();
      expect(find.text('Add Forecast'), findsOneWidget);
    });

    testWidgets('Should have \'Country\' appbar text',
        (WidgetTester tester) async {
      await tester.pumpApp(
        ForecastFormView(),
        forecastFormBloc: _forecastFormBloc,
        appBloc: _appBloc,
        lookupBloc: _lookupBloc,
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
