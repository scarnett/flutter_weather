import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/enums/enums.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/theme.dart';
import 'package:flutter_weather/views/forecast/forecast_utils.dart'
    as forecastUtils;
import 'package:flutter_weather/widgets/app_checkbox_tile.dart';
import 'package:flutter_weather/widgets/app_radio_tile.dart';
import 'package:flutter_weather/widgets/app_ui_overlay_style.dart';

class SettingsThemeModePicker extends StatefulWidget {
  SettingsThemeModePicker({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsThemeModePickerState();
}

class _SettingsThemeModePickerState extends State<SettingsThemeModePicker> {
  @override
  Widget build(
    BuildContext context,
  ) =>
      AppUiOverlayStyle(
        systemNavigationBarIconBrightness:
            context.watch<AppBloc>().state.colorTheme ? Brightness.dark : null,
        child: Theme(
          data: (context.watch<AppBloc>().state.themeMode == ThemeMode.dark)
              ? appDarkThemeData
              : appLightThemeData,
          child: Scaffold(
            body: _buildBody(),
            extendBody: true,
            extendBodyBehindAppBar: true,
          ),
        ),
      );

  Widget _buildBody() {
    ThemeMode themeMode = context.read<AppBloc>().state.themeMode;
    List<Widget> widgets = <Widget>[]..addAll([
        AppRadioTile<ThemeMode>(
          title: ThemeMode.light.getText(context),
          value: ThemeMode.light,
          groupValue: themeMode,
          onTap: _tapThemeMode,
        ),
        Divider(),
      ]);

    if ((themeMode == ThemeMode.light) &&
        forecastUtils.hasForecasts(context.read<AppBloc>().state.forecasts)) {
      widgets.addAll(
        [
          AppCheckboxTile(
            title: AppLocalizations.of(context)!.colorized,
            checked: context.read<AppBloc>().state.colorTheme,
            onTap: _tapColorized,
          ),
          Divider(),
        ],
      );
    }

    widgets.add(
      AppRadioTile<ThemeMode>(
        title: ThemeMode.dark.getText(context),
        value: ThemeMode.dark,
        groupValue: themeMode,
        onTap: _tapThemeMode,
      ),
    );

    return ListView(
      children: widgets,
    );
  }

  void _tapThemeMode(
    ThemeMode? themeMode,
  ) =>
      context.read<AppBloc>().add(SetThemeMode(themeMode));

  void _tapColorized(
    bool? colorized,
  ) =>
      context.read<AppBloc>().add(SetColorTheme(colorized));
}
