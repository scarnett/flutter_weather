import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart' as ft;
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/views/forecast/forecast_form_view.dart';
import 'package:mockito/mockito.dart';
import '../../test_utils.dart';

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

void main() {
  ft.TestWidgetsFlutterBinding.ensureInitialized();

  late AppBloc _bloc;

  ft.setUpAll(() {
    _bloc = MockAppBloc();
  });

  ft.tearDownAll(() {
    _bloc.close();
  });

  ft.testWidgets('Should have \'Edit Forecast\' appbar text',
      (ft.WidgetTester tester) async {
    when(_bloc.state).thenReturn(AppState());

    await tester.pumpWidget(
      BlocProvider.value(
        value: _bloc,
        child: buildFrame(
          buildContent: (BuildContext context) => ForecastFormView(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    ft.expect(ft.find.text('Edit Forecast'), ft.findsOneWidget);
  });

  ft.testWidgets('Should have \'Country\' appbar text',
      (ft.WidgetTester tester) async {
    when(_bloc.state).thenReturn(AppState());

    await tester.pumpWidget(
      BlocProvider.value(
        value: _bloc,
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
