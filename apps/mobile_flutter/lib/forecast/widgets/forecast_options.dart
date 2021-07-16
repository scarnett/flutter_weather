import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';
import 'package:flutter_weather/app/widgets/widgets.dart';
import 'package:flutter_weather/forecast/forecast.dart';

class ForecastOptions extends StatelessWidget {
  static final double height = 50.0;

  @override
  Widget build(
    BuildContext context,
  ) =>
      Container(
        height: (ForecastOptions.height + MediaQuery.of(context).padding.top),
        padding: EdgeInsets.only(
          left: 10.0,
          right: 10.0,
          top: MediaQuery.of(context).padding.top,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ForecastEditButton(),
            ForecastRefresh(),
            Expanded(child: Container()),
            AppColorThemeToggle(
              callback: () => context.read<AppBloc>().add(ToggleColorTheme()),
            ),
            AppDayNightSwitch(
              callback: () => context.read<AppBloc>().add(ToggleThemeMode()),
            ),
            ForecastSettingsButton(),
          ],
        ),
      );
}
