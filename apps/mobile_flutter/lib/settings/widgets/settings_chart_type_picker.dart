import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_weather/app/app_theme.dart';
import 'package:flutter_weather/app/widgets/widgets.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/enums/enums.dart';

class SettingsChartTypePicker extends StatefulWidget {
  SettingsChartTypePicker({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsChartTypePickerState();
}

class _SettingsChartTypePickerState extends State<SettingsChartTypePicker> {
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
    List<ChartType> chartTypes = ChartType.values;
    List<Widget> widgets = <Widget>[];
    ChartType _chartType = context.read<AppBloc>().state.chartType;

    for (ChartType chartType in chartTypes) {
      widgets.add(
        AppRadioTile<ChartType>(
          title: chartType.getText(context),
          value: chartType,
          groupValue: _chartType,
          onTap: _tapChartType,
        ),
      );

      if ((count + 1) < chartTypes.length) {
        widgets.add(Divider());
      }

      count++;
    }

    return ListView(children: widgets);
  }

  void _tapChartType(
    ChartType? chartType,
  ) =>
      context.read<AppBloc>().add(SetChartType(chartType));
}
