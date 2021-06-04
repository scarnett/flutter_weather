import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_weather/app/app_theme.dart';
import 'package:flutter_weather/app/widgets/widgets.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/enums/enums.dart';

class SettingsDistanceUnitsPicker extends StatefulWidget {
  SettingsDistanceUnitsPicker({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsDistanceUnitsPickerState();
}

class _SettingsDistanceUnitsPickerState
    extends State<SettingsDistanceUnitsPicker> {
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
    List<DistanceUnit> distanceUnits = DistanceUnit.values;
    List<Widget> widgets = <Widget>[];
    DistanceUnit _distanceUnit = context.read<AppBloc>().state.units.distance;

    for (DistanceUnit distanceUnit in distanceUnits) {
      widgets.add(
        AppRadioTile<DistanceUnit>(
          title: distanceUnit.getText(context),
          value: distanceUnit,
          groupValue: _distanceUnit,
          onTap: _tapDistanceUnit,
        ),
      );

      if ((count + 1) < distanceUnits.length) {
        widgets.add(Divider());
      }

      count++;
    }

    return ListView(children: widgets);
  }

  void _tapDistanceUnit(
    DistanceUnit? distanceUnit,
  ) =>
      context.read<AppBloc>().add(SetDistanceUnit(distanceUnit));
}
