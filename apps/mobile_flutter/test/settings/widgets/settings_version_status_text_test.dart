import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';
import 'package:flutter_weather/settings/settings.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info/package_info.dart';

import '../../utils/pump_utils.dart';

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class FakeAppEvent extends Fake implements AppEvent {}

class FakeAppState extends Fake implements AppState {}

void main() {
  setUpAll(() {
    registerFallbackValue<AppEvent>(FakeAppEvent());
    registerFallbackValue<AppState>(FakeAppState());
  });

  group('SettingsVersionStatusText', () {
    late AppBloc _appBloc;

    setUp(() {
      _appBloc = MockAppBloc();
      when(() => _appBloc.state).thenReturn(AppState());
    });

    testWidgets('Should have \'Latest\' version text',
        (WidgetTester tester) async {
      await tester.pumpApp(
        SettingsVersionStatusText(
          packageInfo: PackageInfo(
            version: '1.5.0',
            appName: 'flutter_weather',
            buildNumber: '1',
            packageName: 'io.flutter_weather.tst',
          ),
        ),
        appBloc: _appBloc,
      );

      await tester.pumpAndSettle();
      expect(find.text('Latest'), findsOneWidget);
    });

    testWidgets('Should have \'Update Available\' version text',
        (WidgetTester tester) async {
      await tester.pumpApp(
        SettingsVersionStatusText(
          packageInfo: PackageInfo(
            version: '1.0.0',
            appName: 'flutter_weather',
            buildNumber: '1',
            packageName: 'io.flutter_weather.tst',
          ),
        ),
        appBloc: _appBloc,
      );

      await tester.pumpAndSettle();
      expect(find.text('Update Available'), findsOneWidget);
    });

    testWidgets('Should have \'Beta\' version text',
        (WidgetTester tester) async {
      await tester.pumpApp(
        SettingsVersionStatusText(
          packageInfo: PackageInfo(
            version: '1.5.1',
            appName: 'flutter_weather',
            buildNumber: '1',
            packageName: 'io.flutter_weather.tst',
          ),
        ),
        appBloc: _appBloc,
      );

      await tester.pumpAndSettle();
      expect(find.text('Beta'), findsOneWidget);
    });

    testWidgets('Should have EMPTY version text', (WidgetTester tester) async {
      await tester.pumpApp(
        SettingsVersionStatusText(
          packageInfo: PackageInfo(
            version: 'unknown',
            appName: 'unknown',
            buildNumber: 'unknown',
            packageName: 'unknown',
          ),
        ),
        appBloc: _appBloc,
      );

      await tester.pumpAndSettle();
      expect(find.text(''), findsOneWidget);
    });
  });
}
