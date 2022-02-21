import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_weather/app/app_theme.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';
import 'package:flutter_weather/app/widgets/widgets.dart';
import 'package:flutter_weather/enums/enums.dart';

class SettingsWindSpeedUnitsPicker extends StatefulWidget {
  SettingsWindSpeedUnitsPicker({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsWindSpeedUnitsPickerState();
}

class _SettingsWindSpeedUnitsPickerState
    extends State<SettingsWindSpeedUnitsPicker> {
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
    int count = 0;
    List<WindSpeedUnit> windSpeedUnits = WindSpeedUnit.values;
    List<Widget> widgets = <Widget>[];
    WindSpeedUnit _windSpeedUnit =
        context.read<AppBloc>().state.units.windSpeed;

    for (WindSpeedUnit windSpeedUnit in windSpeedUnits) {
      widgets.add(
        AppRadioTile<WindSpeedUnit>(
          title: windSpeedUnit.getText(context),
          value: windSpeedUnit,
          groupValue: _windSpeedUnit,
          onTap: _tapWindSpeedUnit,
        ),
      );

      if ((count + 1) < windSpeedUnits.length) {
        widgets.add(Divider());
      }

      count++;
    }

    return ListView(children: widgets);
  }

  void _tapWindSpeedUnit(
    WindSpeedUnit? windSpeedUnit,
  ) =>
      context.read<AppBloc>().add(SetWindSpeedUnit(windSpeedUnit));
}
