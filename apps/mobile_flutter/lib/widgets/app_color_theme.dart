import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/theme.dart';
import 'package:flutter_weather/views/forecast/forecast_utils.dart';

class AppColorThemeToggle extends StatefulWidget {
  final AppBloc bloc;

  AppColorThemeToggle({
    Key? key,
    required this.bloc,
  }) : super(key: key);

  @override
  _AppColorThemeToggleState createState() => _AppColorThemeToggleState();
}

class _AppColorThemeToggleState extends State<AppColorThemeToggle> {
  @override
  Widget build(
    BuildContext context,
  ) =>
      (widget.bloc.state.themeMode == ThemeMode.dark) ||
              !hasForecasts(widget.bloc.state.forecasts)
          ? Container()
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Tooltip(
                message: widget.bloc.state.colorTheme
                    ? AppLocalizations.of(context)!.colorThemeDisable
                    : AppLocalizations.of(context)!.colorThemeEnable,
                child: Material(
                  type: MaterialType.transparency,
                  child: Container(
                    height: 40.0,
                    width: 40.0,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(40.0),
                      child: Icon(
                        Icons.brightness_7,
                        color: widget.bloc.state.colorTheme
                            ? Colors.white
                            : AppTheme.getHintColor(
                                widget.bloc.state.themeMode),
                      ),
                      onTap: _tapToggleColorTheme,
                    ),
                  ),
                ),
              ),
            );

  void _tapToggleColorTheme() => widget.bloc.add(ToggleColorTheme());
}
