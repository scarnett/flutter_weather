import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/views/forecast/forecast_form_view.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/forecast_utils.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_refresh.dart';
import 'package:flutter_weather/views/settings/settings_view.dart';
import 'package:flutter_weather/widgets/app_color_theme.dart';
import 'package:flutter_weather/widgets/app_day_night_switch.dart';

class ForecastOptions extends StatefulWidget {
  static final double height = 50.0;

  @override
  _ForecastOptionsState createState() => _ForecastOptionsState();
}

class _ForecastOptionsState extends State<ForecastOptions> {
  @override
  Widget build(
    BuildContext context,
  ) =>
      Container(
        height: (ForecastOptions.height + MediaQuery.of(context).padding.top),
        padding: EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          top: MediaQuery.of(context).padding.top,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _buildEditButton(),
            ForecastRefresh(),
            Expanded(child: Container()),
            AppColorThemeToggle(
              forecasts: context.watch<AppBloc>().state.forecasts,
              themeMode: context.watch<AppBloc>().state.themeMode,
              colorTheme: context.watch<AppBloc>().state.colorTheme,
              callback: () => context.read<AppBloc>().add(ToggleColorTheme()),
            ),
            AppDayNightSwitch(
              themeMode: context.watch<AppBloc>().state.themeMode,
              colorTheme: context.watch<AppBloc>().state.colorTheme,
              callback: () => context.read<AppBloc>().add(ToggleThemeMode()),
            ),
            _buildSettingsButton(),
          ],
        ),
      );

  Widget _buildEditButton() {
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
                  child: Icon(Icons.edit),
                  onTap: () => _tapEdit(state),
                ),
              ),
            ),
          );
  }

  Widget _buildSettingsButton() => Container(
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
                child: Icon(Icons.settings),
                onTap: _tapSettings,
              ),
            ),
          ),
        ),
      );

  void _tapEdit(
    AppState state,
  ) {
    if (state.forecasts.length > state.selectedForecastIndex) {
      Forecast? forecast = state.forecasts[state.selectedForecastIndex];
      context.read<AppBloc>().add(SetActiveForecastId(forecast.id));
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      Navigator.push(context, ForecastFormView.route());
    }
  }

  void _tapSettings() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    Navigator.push(context, SettingsView.route());
  }
}
