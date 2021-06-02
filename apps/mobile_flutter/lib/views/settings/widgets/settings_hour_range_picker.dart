import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/enums.dart';
import 'package:flutter_weather/theme.dart';
import 'package:flutter_weather/widgets/app_radio_tile.dart';
import 'package:flutter_weather/widgets/app_ui_overlay_style.dart';

class SettingsHourRangePicker extends StatefulWidget {
  final Function(
    ForecastHourRange? hourRange,
  ) onTap;

  SettingsHourRangePicker({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsHourRangePickerState();
}

class _SettingsHourRangePickerState extends State<SettingsHourRangePicker> {
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
    List<ForecastHourRange> hourRanges = ForecastHourRange.values;
    List<Widget> widgets = <Widget>[];
    ForecastHourRange _hourRange =
        context.read<AppBloc>().state.forecastHourRange;

    for (ForecastHourRange hourRange in hourRanges) {
      widgets.add(
        AppRadioTile<ForecastHourRange>(
          title: hourRange.getText(context),
          value: hourRange,
          groupValue: _hourRange,
          onTap: _tapHourRange,
        ),
      );

      if ((count + 1) < hourRanges.length) {
        widgets.add(Divider());
      }

      count++;
    }

    return ListView(children: widgets);
  }

  void _tapHourRange(
    ForecastHourRange? hourRange,
  ) =>
      widget.onTap(hourRange ?? null);
}
