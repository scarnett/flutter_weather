import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/views/settings/widgets/settings_version_status_text.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:package_info/package_info.dart';

void mockPackageInfo() {
  const MethodChannel('plugins.flutter.io/package_info')
      .setMockMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'getAll') {
      return <String, dynamic>{
        'appName': 'Flutter Weather',
        'packageName': 'io.flutter_weather.dev',
        'version': '1.0.0',
        'buildNumber': '532436901'
      };
    }

    return null;
  });
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  mockPackageInfo();

  AppBloc bloc;

  final GetIt getIt = GetIt.instance;

  setUpAll(() {
    bloc = getIt<AppBloc>();
    when(bloc.state).thenReturn(AppState());
  });

  testWidgets('SettingsVersionStatusText has version status text',
      (WidgetTester tester) async {
    whenListen(
        bloc,
        Stream.fromIterable([
          AppState(),
          AppState().copyWith(
            appVersion: '1.0.0',
          ),
        ]));

    await tester.pumpWidget(SettingsVersionStatusText(
      bloc: bloc,
      packageInfo: await PackageInfo.fromPlatform(),
    ));

    await tester.pump();

    bloc.close();
  });
}
