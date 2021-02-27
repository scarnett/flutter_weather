import 'package:flutter/material.dart';
import 'package:flutter_weather/localization.dart';

Widget buildFrame({
  @required WidgetBuilder buildContent,
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
