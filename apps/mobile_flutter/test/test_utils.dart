import 'package:flutter/material.dart';
import 'package:flutter_weather/app/app_config.dart';
import 'package:flutter_weather/enums/enums.dart';
import 'package:flutter_weather/localization.dart';

Widget buildFrame({
  required WidgetBuilder buildContent,
}) =>
    AppConfig(
      flavor: Flavor.dev,
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
