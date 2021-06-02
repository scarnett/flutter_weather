import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/enums/enums.dart';
import 'package:flutter_weather/theme.dart';
import 'package:flutter_weather/widgets/app_radio_tile.dart';
import 'package:flutter_weather/widgets/app_ui_overlay_style.dart';

class SettingsSpeedUnitsPicker extends StatefulWidget {
  SettingsSpeedUnitsPicker({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsSpeedUnitsPickerState();
}

class _SettingsSpeedUnitsPickerState extends State<SettingsSpeedUnitsPicker> {
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
    List<SpeedUnit> speedUnits = SpeedUnit.values;
    List<Widget> widgets = <Widget>[];
    SpeedUnit _temperatureUnit = context.read<AppBloc>().state.speedUnit;

    for (SpeedUnit speedUnit in speedUnits) {
      widgets.add(
        AppRadioTile<SpeedUnit>(
          title: speedUnit.getText(context),
          value: speedUnit,
          groupValue: _temperatureUnit,
          onTap: _tapSpeedUnit,
        ),
      );

      if ((count + 1) < speedUnits.length) {
        widgets.add(Divider());
      }

      count++;
    }

    return ListView(children: widgets);
  }

  void _tapSpeedUnit(
    SpeedUnit? speedUnit,
  ) =>
      context.read<AppBloc>().add(SetSpeedUnit(speedUnit));
}
