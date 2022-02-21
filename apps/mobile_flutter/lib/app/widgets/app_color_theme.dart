import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/app/app_localization.dart';
import 'package:flutter_weather/app/app_theme.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';
import 'package:flutter_weather/forecast/forecast.dart';

class AppColorThemeToggle extends StatelessWidget {
  final Function callback;

  AppColorThemeToggle({
    Key? key,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) {
    AppState state = context.read<AppBloc>().state;
    return ((state.themeMode == ThemeMode.dark) ||
            !hasForecasts(state.forecasts))
        ? Container()
        : Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Tooltip(
              message: state.colorTheme
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
                      color: state.colorTheme
                          ? Colors.white
                          : AppTheme.getHintColor(state.themeMode),
                    ),
                    onTap: () => callback(),
                  ),
                ),
              ),
            ),
          );
  }
}
