import 'package:flutter/material.dart';
import 'package:flutter_weather/app/app_config.dart';
import 'package:flutter_weather/app/app_localization.dart';
import 'package:flutter_weather/enums/enums.dart';

Widget buildFrame({
  required WidgetBuilder buildContent,
}) =>
    AppConfig(
      flavor: Flavor.dev,
      appVersion: '1.5.0',
      appBuild: '1',
      supportedLocales: 'en',
      child: MaterialApp(
        localizationsDelegates: [
          AppLocalizationsDelegate(),
          FallbackCupertinoLocalisationsDelegate(),
        ],
        onGenerateRoute: (RouteSettings settings) => MaterialPageRoute<void>(
          builder: (BuildContext context) => buildContent(context),
        ),
      ),
    );
