import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart' as ft;
import 'package:flutter_weather/app/bloc/bloc.dart';
import 'package:flutter_weather/forecast/forecast.dart';
import 'package:flutter_weather/lookup/lookup.dart';
import 'package:mockito/mockito.dart';

import '../../test_utils.dart';

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class MockLookupBloc extends MockBloc<LookupEvent, LookupState>
    implements LookupBloc {}

void main() {
  ft.TestWidgetsFlutterBinding.ensureInitialized();

  late AppBloc _appBloc;
  late LookupBloc _lookupBloc;

  ft.setUpAll(() {
    _appBloc = MockAppBloc();
    _lookupBloc = MockLookupBloc();
  });

  ft.tearDownAll(() {
    _appBloc.close();
    _lookupBloc.close();
  });

  ft.testWidgets('Should have \'Add Forecast\' appbar text',
      (ft.WidgetTester tester) async {
    when(_appBloc.state).thenReturn(AppState());

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _appBloc),
          BlocProvider.value(value: _lookupBloc),
        ],
        child: buildFrame(
          buildContent: (BuildContext context) => LookupView(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    ft.expect(ft.find.text('Add Forecast'), ft.findsOneWidget);
  });

  ft.testWidgets('Should have \'Country\' appbar text',
      (ft.WidgetTester tester) async {
    when(_appBloc.state).thenReturn(AppState());

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _appBloc),
          BlocProvider.value(value: _lookupBloc),
        ],
        child: buildFrame(
          buildContent: (BuildContext context) => ForecastFormView(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(ft.find.byKey(Key('country')));
    await tester.pumpAndSettle();
    ft.expect(ft.find.text('Country'), ft.findsOneWidget);
  });
}
