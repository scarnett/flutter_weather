import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/config.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/theme.dart';
import 'package:flutter_weather/views/forecast/forecast_view.dart';
import 'package:flutter_weather/views/settings/widgets/settings_enums.dart';

class WeatherApp extends StatelessWidget {
  WeatherApp({
    Key? key,
  }) : super(key: key) {
    // Set the orientation to portrait only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(
    BuildContext context,
  ) =>
      BlocProvider(
        create: (BuildContext context) =>
            AppBloc()..add(GetCurrentAppVersion()),
        child: FlutterWeatherAppView(),
      );
}

class FlutterWeatherAppView extends StatefulWidget {
  @override
  _FlutterWeatherAppViewState createState() => _FlutterWeatherAppViewState();
}

class _FlutterWeatherAppViewState extends State<FlutterWeatherAppView> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  ThemeData? _themeData;

  @override
  void initState() {
    super.initState();
    initPlatformState();
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
              BlocListener<AppBloc, AppState>(
            listener: _blocListener,
            child: MaterialApp(
              title: AppLocalizations.appTitle,
              theme: _themeData,
              darkTheme: appDarkThemeData,
              themeMode: state.themeMode,
              debugShowCheckedModeBanner: AppConfig.isDebug(context),
              localizationsDelegates: [
                AppLocalizationsDelegate(),
                FallbackCupertinoLocalisationsDelegate(),
              ],
              navigatorKey: _navigatorKey,
              home: ForecastView(),
            ),
          ),
        ),
      );

  Future<void> initPlatformState() async {
    AppState state = context.read<AppBloc>().state;
    UpdatePeriod? updatePeriod = state.updatePeriod;
    if (updatePeriod != null) {
      int status = await BackgroundFetch.configure(
          BackgroundFetchConfig(
            minimumFetchInterval: updatePeriod.info!['minutes'],
            stopOnTerminate: false,
            enableHeadless: true,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresStorageNotLow: false,
            requiresDeviceIdle: false,
            requiredNetworkType: NetworkType.NONE,
          ), (String taskId) async {
        // Event received
        // TODO! Fetch forecasts
        BackgroundFetch.finish(taskId);
      }, (String taskId) async {
        // Task timed out
        BackgroundFetch.finish(taskId);
      });
    }

    if (!mounted) return;
  }

  void _blocListener(
    BuildContext context,
    AppState state,
  ) =>
      setState(() {
        if (state.activeForecastId != null) {
          _themeData = appLightThemeData;
        } else {
          _themeData =
              state.colorTheme! ? appColorThemeData : appLightThemeData;
        }
      });
}
