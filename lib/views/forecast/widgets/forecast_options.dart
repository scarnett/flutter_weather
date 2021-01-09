import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/theme.dart';
import 'package:flutter_weather/views/forecast/forecast_form_view.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/forecast_utils.dart';
import 'package:flutter_weather/views/settings/settings_view.dart';
import 'package:flutter_weather/widgets/app_day_night_switch.dart';

class ForecastOptions extends StatefulWidget {
  ForecastOptions();

  @override
  _ForecastOptionsState createState() => _ForecastOptionsState();
}

class _ForecastOptionsState extends State<ForecastOptions>
    with TickerProviderStateMixin {
  Animation _refreshAnimation;
  AnimationController _refreshAnimationController;

  @override
  void initState() {
    super.initState();

    _refreshAnimationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    _refreshAnimation =
        Tween(begin: 0.0, end: pi + pi).animate(_refreshAnimationController);
  }

  @override
  void dispose() {
    _refreshAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) =>
      BlocListener<AppBloc, AppState>(
        listener: _blocListener,
        child: Container(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 20.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _buildEditButton(),
              _buildRefreshButton(),
              Expanded(child: Container()),
              _buildColorThemeButton(),
              AppDayNightSwitch(bloc: context.watch<AppBloc>()),
              _buildSettingsButton(),
            ],
          ),
        ),
      );

  void _blocListener(
    BuildContext context,
    AppState state,
  ) {
    if (state.refreshStatus == RefreshStatus.REFRESHING) {
      _refreshAnimationController
        ..reset()
        ..forward();
    }
  }

  Widget _buildEditButton() {
    AppState state = context.watch<AppBloc>().state;
    return (state.forecasts == null) || state.forecasts.isEmpty
        ? Container()
        : Tooltip(
            message: AppLocalizations.of(context).editForecast,
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

  Widget _buildColorThemeButton() {
    AppState state = context.watch<AppBloc>().state;
    return (state.themeMode == ThemeMode.dark) ||
            (state.forecasts == null) ||
            state.forecasts.isEmpty
        ? Container()
        : Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Tooltip(
              message: state.colorTheme
                  ? AppLocalizations.of(context).colorThemeDisable
                  : AppLocalizations.of(context).colorThemeEnable,
              child: Material(
                type: MaterialType.transparency,
                child: Container(
                  height: 40.0,
                  width: 40.0,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(40.0),
                    child: Icon(
                      Icons.brightness_7,
                      color: state.colorTheme
                          ? Colors.white
                          : AppTheme.getHintColor(state.themeMode),
                    ),
                    onTap: _tapToggleColorTheme,
                  ),
                ),
              ),
            ),
          );
  }

  Widget _buildRefreshButton() {
    AppState state = context.watch<AppBloc>().state;
    return (!canRefresh(state) ||
            (state.forecasts == null) ||
            state.forecasts.isEmpty)
        ? Container()
        : Tooltip(
            message: AppLocalizations.of(context).refreshForecast,
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                height: 40.0,
                width: 40.0,
                child: InkWell(
                  borderRadius: BorderRadius.circular(40.0),
                  child: AnimatedBuilder(
                    animation: _refreshAnimationController,
                    builder: (BuildContext context, Widget child) =>
                        Transform.rotate(
                      angle: _refreshAnimation.value,
                      child: child,
                    ),
                    child: Icon(Icons.refresh),
                  ),
                  onTap: () => _tapRefresh(state),
                ),
              ),
            ),
          );
  }

  Widget _buildSettingsButton() => Container(
        padding: EdgeInsets.only(left: 10.0),
        child: Tooltip(
          message: AppLocalizations.of(context).settings,
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
    Forecast forecast = state.forecasts[state.selectedForecastIndex];
    if (forecast != null) {
      context.read<AppBloc>().add(SetActiveForecastId(forecast.id));
      Navigator.push(context, ForecastFormView.route());
    }
  }

  void _tapRefresh(
    AppState state,
  ) =>
      context.read<AppBloc>().add(RefreshForecast(
            state.forecasts[state.selectedForecastIndex],
            context.read<AppBloc>().state.temperatureUnit,
          ));

  void _tapToggleColorTheme() =>
      context.read<AppBloc>().add(ToggleColorTheme());

  void _tapSettings() => Navigator.push(context, SettingsView.route());
}
