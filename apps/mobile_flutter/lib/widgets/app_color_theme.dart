import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/theme.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/forecast_utils.dart';

class AppColorThemeToggle extends StatefulWidget {
  final List<Forecast> forecasts;
  final ThemeMode themeMode;
  final bool colorTheme;
  final Function callback;

  AppColorThemeToggle({
    Key? key,
    required this.forecasts,
    required this.themeMode,
    required this.colorTheme,
    required this.callback,
  }) : super(key: key);

  @override
  _AppColorThemeToggleState createState() => _AppColorThemeToggleState();
}

class _AppColorThemeToggleState extends State<AppColorThemeToggle> {
  @override
  Widget build(
    BuildContext context,
  ) =>
      (widget.themeMode == ThemeMode.dark) || !hasForecasts(widget.forecasts)
          ? Container()
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Tooltip(
                message: widget.colorTheme
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
                        color: widget.colorTheme
                            ? Colors.white
                            : AppTheme.getHintColor(widget.themeMode),
                      ),
                      onTap: () => widget.callback(),
                    ),
                  ),
                ),
              ),
            );
}
