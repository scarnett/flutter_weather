import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_weather/app/app_theme.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';
import 'package:flutter_weather/app/widgets/widgets.dart';
import 'package:flutter_weather/enums/enums.dart';
import 'package:flutter_weather/forecast/forecast.dart';

class SettingsHourRangePicker extends StatefulWidget {
  SettingsHourRangePicker({
    Key? key,
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
    List<HourRange> hourRanges = HourRange.values;
    List<Widget> widgets = <Widget>[];
    HourRange _hourRange = context.read<AppBloc>().state.hourRange;

    for (HourRange hourRange in hourRanges) {
      widgets.add(
        AppRadioTile<HourRange>(
          title: hourRange.getText(context),
          value: hourRange,
          groupValue: _hourRange,
          onTap: (HourRange? range) =>
              tapHourRange(context.read<AppBloc>(), range),
        ),
      );

      if ((count + 1) < hourRanges.length) {
        widgets.add(Divider());
      }

      count++;
    }

    return ListView(children: widgets);
  }
}
