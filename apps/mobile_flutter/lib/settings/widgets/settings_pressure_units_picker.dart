import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_weather/app/app_theme.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';
import 'package:flutter_weather/app/widgets/widgets.dart';
import 'package:flutter_weather/enums/enums.dart';

class SettingsPressureUnitsPicker extends StatefulWidget {
  SettingsPressureUnitsPicker({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsPressureUnitsPickerState();
}

class _SettingsPressureUnitsPickerState
    extends State<SettingsPressureUnitsPicker> {
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
    List<PressureUnit> pressureUnits = PressureUnit.values;
    List<Widget> widgets = <Widget>[];
    PressureUnit _pressureUnit = context.read<AppBloc>().state.units.pressure;

    for (PressureUnit pressureUnit in pressureUnits) {
      widgets.add(
        AppRadioTile<PressureUnit>(
          title: pressureUnit.getText(context),
          value: pressureUnit,
          groupValue: _pressureUnit,
          onTap: _tapPressureUnit,
        ),
      );

      if ((count + 1) < pressureUnits.length) {
        widgets.add(Divider());
      }

      count++;
    }

    return ListView(children: widgets);
  }

  void _tapPressureUnit(
    PressureUnit? pressureUnit,
  ) =>
      context.read<AppBloc>().add(SetPressureUnit(pressureUnit));
}
