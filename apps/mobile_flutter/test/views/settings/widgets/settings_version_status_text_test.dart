import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/injection/injection.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/views/settings/widgets/settings_version_status_text.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart' as _injectable;
import 'package:mockito/mockito.dart';
import 'package:package_info/package_info.dart';

Widget buildFrame({
  WidgetBuilder buildContent,
}) =>
    MaterialApp(
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        FallbackCupertinoLocalisationsDelegate(),
      ],
      onGenerateRoute: (RouteSettings settings) => MaterialPageRoute<void>(
        builder: (BuildContext context) => buildContent(context),
      ),
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  AppBloc bloc;

  final GetIt getIt = GetIt.instance;

  setUpAll(() {
    configureInjections(_injectable.Environment.test);
    bloc = getIt<AppBloc>();
  });

  testWidgets('Should have \'Latest\' version text',
      (WidgetTester tester) async {
    when(bloc.state).thenReturn(AppState());

    await tester.pumpWidget(
      buildFrame(
        buildContent: (BuildContext context) => SettingsVersionStatusText(
          bloc: bloc,
          packageInfo: PackageInfo(version: '1.0.0'),
        ),
      ),
    );

    await tester.pump();
    expect(find.text('Latest'), findsOneWidget);
    bloc.close();
  });

  testWidgets('Should have \'Update Available\' version text',
      (WidgetTester tester) async {
    when(bloc.state).thenReturn(AppState().copyWith(appVersion: '1.0.1'));

    await tester.pumpWidget(
      buildFrame(
        buildContent: (BuildContext context) => SettingsVersionStatusText(
          bloc: bloc,
          packageInfo: PackageInfo(version: '1.0.0'),
        ),
      ),
    );

    await tester.pump();
    expect(find.text('Update Available'), findsOneWidget);
    bloc.close();
  });

  testWidgets('Should have \'Beta\' version text', (WidgetTester tester) async {
    when(bloc.state).thenReturn(AppState().copyWith(appVersion: '1.0.0'));

    await tester.pumpWidget(
      buildFrame(
        buildContent: (BuildContext context) => SettingsVersionStatusText(
          bloc: bloc,
          packageInfo: PackageInfo(version: '1.0.1'),
        ),
      ),
    );

    await tester.pump();
    expect(find.text('Beta'), findsOneWidget);
    bloc.close();
  });

  testWidgets('Should have EMPTY version text', (WidgetTester tester) async {
    when(bloc.state).thenReturn(AppState());

    await tester.pumpWidget(
      buildFrame(
        buildContent: (BuildContext context) => SettingsVersionStatusText(
          bloc: bloc,
          packageInfo: PackageInfo(version: 'unknown'),
        ),
      ),
    );

    await tester.pump();
    expect(find.text(''), findsOneWidget);
    bloc.close();
  });
}
