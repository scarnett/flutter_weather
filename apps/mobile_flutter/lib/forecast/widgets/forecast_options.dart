import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/app/app_localization.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';
import 'package:flutter_weather/app/widgets/app_premium_trigger.dart';
import 'package:flutter_weather/app/widgets/widgets.dart';
import 'package:flutter_weather/forecast/forecast.dart';
import 'package:flutter_weather/models/models.dart';
import 'package:flutter_weather/settings/view/view.dart';

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
            _buildEditButton(context),
            ForecastRefresh(),
            if (!context.read<AppBloc>().state.isPremium)
              _buildPremiumButton(context),
            Expanded(child: Container()),
            AppColorThemeToggle(
              callback: () => context.read<AppBloc>().add(ToggleColorTheme()),
            ),
            AppDayNightSwitch(
              callback: () => context.read<AppBloc>().add(ToggleThemeMode()),
            ),
            _buildSettingsButton(context),
          ],
        ),
      );

  Widget _buildPremiumButton(
    BuildContext context,
  ) =>
      Tooltip(
        message: AppLocalizations.of(context)!.premium,
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            height: 40.0,
            width: 40.0,
            child: InkWell(
              borderRadius: BorderRadius.circular(40.0),
              child: AppPremiumTrigger(),
              onTap: () => {},
            ),
          ),
        ),
      );

  Widget _buildEditButton(
    BuildContext context,
  ) {
    AppState state = context.watch<AppBloc>().state;
    return !hasForecasts(state.forecasts)
        ? Container()
        : Tooltip(
            message: AppLocalizations.of(context)!.editForecast,
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                height: 40.0,
                width: 40.0,
                child: InkWell(
                  borderRadius: BorderRadius.circular(40.0),
                  child: const Icon(Icons.edit),
                  onTap: () => _tapEdit(context, state),
                ),
              ),
            ),
          );
  }

  Widget _buildSettingsButton(
    BuildContext context,
  ) =>
      Container(
        padding: EdgeInsets.only(left: 10.0),
        child: Tooltip(
          message: AppLocalizations.of(context)!.settings,
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              height: 40.0,
              width: 40.0,
              child: InkWell(
                borderRadius: BorderRadius.circular(40.0),
                child: const Icon(Icons.settings),
                onTap: () => _tapSettings(context),
              ),
            ),
          ),
        ),
      );

  void _tapEdit(
    BuildContext context,
    AppState state,
  ) {
    if (state.forecasts.length > state.selectedForecastIndex) {
      Forecast? forecast = state.forecasts[state.selectedForecastIndex];
      context.read<AppBloc>().add(SetActiveForecastId(forecast.id));
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      Navigator.push(context, ForecastFormView.route());
    }
  }

  void _tapSettings(
    BuildContext context,
  ) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    Navigator.push(context, SettingsView.route());
  }
}
