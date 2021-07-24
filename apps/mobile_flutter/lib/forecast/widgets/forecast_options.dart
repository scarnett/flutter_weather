import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';
import 'package:flutter_weather/app/widgets/widgets.dart';
import 'package:flutter_weather/forecast/forecast.dart';

class ForecastOptions extends StatefulWidget {
  static final double height = 50.0;

  ForecastOptions({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ForecastOptionsState();
}

class _ForecastOptionsState extends State<ForecastOptions> {
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
            if (!context.read<AppBloc>().state.isPremium)
              ForecastPremiumButton(),
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
