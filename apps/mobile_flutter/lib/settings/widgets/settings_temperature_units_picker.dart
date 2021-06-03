import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_weather/app/app_theme.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/enums/enums.dart';
import 'package:flutter_weather/widgets/app_radio_tile.dart';
import 'package:flutter_weather/widgets/app_ui_overlay_style.dart';

class SettingsTemperatureUnitsPicker extends StatefulWidget {
  SettingsTemperatureUnitsPicker({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsTemperatureUnitsPickerState();
}

class _SettingsTemperatureUnitsPickerState
    extends State<SettingsTemperatureUnitsPicker> {
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
    List<TemperatureUnit> temperatureUnits = TemperatureUnit.values;
    List<Widget> widgets = <Widget>[];
    TemperatureUnit _temperatureUnit =
        context.read<AppBloc>().state.units.temperature;

    for (TemperatureUnit temperatureUnit in temperatureUnits) {
      widgets.add(
        AppRadioTile<TemperatureUnit>(
          title: temperatureUnit.getText(context),
          value: temperatureUnit,
          groupValue: _temperatureUnit,
          onTap: _tapTemperatureUnit,
        ),
      );

      if ((count + 1) < temperatureUnits.length) {
        widgets.add(Divider());
      }

      count++;
    }

    return ListView(children: widgets);
  }

  void _tapTemperatureUnit(
    TemperatureUnit? temperatureUnit,
  ) =>
      context.read<AppBloc>().add(SetTemperatureUnit(temperatureUnit));
}
