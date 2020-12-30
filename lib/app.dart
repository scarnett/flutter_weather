import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/config.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/theme.dart';
import 'package:flutter_weather/views/forecast/forecast_view.dart';

class WeatherApp extends StatelessWidget {
  WeatherApp({
    Key key,
  }) : super(key: key) {
    // Status bar configuration
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.background,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
    ));

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
        create: (BuildContext context) => AppBloc(),
        child: DispatcherAppView(),
      );
}

class DispatcherAppView extends StatefulWidget {
  @override
  _DispatcherAppViewState createState() => _DispatcherAppViewState();
}

class _DispatcherAppViewState extends State<DispatcherAppView> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

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
            theme: ThemeData.light(), // TODO! appThemeData
            darkTheme: ThemeData.dark(),
            themeMode: state.themeMode,
            debugShowCheckedModeBanner: AppConfig.isDebug(context),
            localizationsDelegates: [
              AppLocalizationsDelegate(),
            ],
            navigatorKey: _navigatorKey,
            home: ForecastView(),
          ),
        ),
      );
}
