import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart' as ft;
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/views/settings/widgets/settings_version_status_text.dart';
import 'package:mockito/mockito.dart';
import 'package:package_info/package_info.dart';
import '../../../test_utils.dart';

class MockAppBloc extends MockBloc<AppState> implements AppBloc {}

void main() {
  ft.TestWidgetsFlutterBinding.ensureInitialized();

  AppBloc _bloc;

  ft.setUpAll(() {
    _bloc = MockAppBloc();
  });

  ft.tearDownAll(() {
    _bloc.close();
  });

  ft.testWidgets('Should have \'Latest\' version text',
      (ft.WidgetTester tester) async {
    when(_bloc.state).thenReturn(AppState());

    await tester.pumpWidget(
      buildFrame(
        buildContent: (BuildContext context) => SettingsVersionStatusText(
          bloc: _bloc,
          packageInfo: PackageInfo(version: '1.0.0'),
        ),
      ),
    );

    await tester.pumpAndSettle();
    ft.expect(ft.find.text('Latest'), ft.findsOneWidget);
  });

  ft.testWidgets('Should have \'Update Available\' version text',
      (ft.WidgetTester tester) async {
    when(_bloc.state).thenReturn(AppState().copyWith(appVersion: '1.0.1'));

    await tester.pumpWidget(
      buildFrame(
        buildContent: (BuildContext context) => SettingsVersionStatusText(
          bloc: _bloc,
          packageInfo: PackageInfo(version: '1.0.0'),
        ),
      ),
    );

    await tester.pumpAndSettle();
    ft.expect(ft.find.text('Update Available'), ft.findsOneWidget);
  });

  ft.testWidgets('Should have \'Beta\' version text',
      (ft.WidgetTester tester) async {
    when(_bloc.state).thenReturn(AppState().copyWith(appVersion: '1.0.0'));

    await tester.pumpWidget(
      buildFrame(
        buildContent: (BuildContext context) => SettingsVersionStatusText(
          bloc: _bloc,
          packageInfo: PackageInfo(version: '1.0.1'),
        ),
      ),
    );

    await tester.pumpAndSettle();
    ft.expect(ft.find.text('Beta'), ft.findsOneWidget);
  });

  ft.testWidgets('Should have EMPTY version text',
      (ft.WidgetTester tester) async {
    when(_bloc.state).thenReturn(AppState());

    await tester.pumpWidget(
      buildFrame(
        buildContent: (BuildContext context) => SettingsVersionStatusText(
          bloc: _bloc,
          packageInfo: PackageInfo(version: 'unknown'),
        ),
      ),
    );

    await tester.pumpAndSettle();
    ft.expect(ft.find.text(''), ft.findsOneWidget);
  });
}