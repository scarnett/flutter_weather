import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/app/app_config.dart';
import 'package:flutter_weather/app/app_localization.dart';
import 'package:flutter_weather/app/app_prefs.dart';
import 'package:flutter_weather/app/app_theme.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';
import 'package:flutter_weather/forecast/forecast.dart';

class WeatherApp extends StatelessWidget {
  WeatherApp({
    Key? key,
  }) : super(key: key) {
    // Set the orientation to portrait only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    if (WidgetsBinding.instance?.lifecycleState == AppLifecycleState.resumed) {
      // Set the initial appstate (resumed) in the shared prefs
      AppPrefs prefs = AppPrefs();
      prefs.appState = 0;
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) =>
      BlocProvider(
        create: (BuildContext context) => AppBloc()
          ..add(StreamConnectivityResult())
          ..add(StreamCompassEvent()),
        child: FlutterWeatherAppView(),
      );
}

class FlutterWeatherAppView extends StatefulWidget {
  @override
  _FlutterWeatherAppViewState createState() => _FlutterWeatherAppViewState();
}

class _FlutterWeatherAppViewState extends State<FlutterWeatherAppView>
    with WidgetsBindingObserver {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) =>
      Container(
        child: BlocBuilder<AppBloc, AppState>(
          builder: (
            BuildContext context,
            AppState state,
          ) =>
              MaterialApp(
            title: AppLocalizations.appTitle,
            theme: _getThemeData(state),
            darkTheme: appDarkThemeData,
            themeMode: state.themeMode,
            debugShowCheckedModeBanner: AppConfig.isDebug(),
            localizationsDelegates: [
              AppLocalizationsDelegate(),
              FallbackCupertinoLocalisationsDelegate(),
            ],
            navigatorKey: _navigatorKey,
            home: ForecastView(),
          ),
        ),
      );

  @override
  void didChangeAppLifecycleState(
    AppLifecycleState state,
  ) {
    AppPrefs prefs = AppPrefs();
    prefs.appState = state.index;

    // switch (state) {
    //   case AppLifecycleState.resumed:
    //   case AppLifecycleState.inactive:
    //   case AppLifecycleState.paused:
    //   case AppLifecycleState.detached:
    //     break;
    // }
  }

  ThemeData? _getThemeData(
    AppState state,
  ) {
    if (state.activeForecastId != null) {
      return appLightThemeData;
    }

    return state.colorTheme ? appColorThemeData : appLightThemeData;
  }
}
