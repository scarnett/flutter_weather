import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/theme.dart';
import 'package:flutter_weather/utils/common_utils.dart';
import 'package:flutter_weather/views/settings/widgets/settings_enums.dart';
import 'package:flutter_weather/widgets/app_ui_overlay_style.dart';

class SettingsUpdatePeriodPicker extends StatefulWidget {
  final UpdatePeriod? selectedPeriod;

  final Function(
    UpdatePeriod period,
  ) onTap;

  SettingsUpdatePeriodPicker({
    Key? key,
    this.selectedPeriod,
    required this.onTap,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsUpdatePeriodPickerState();
}

class _SettingsUpdatePeriodPickerState
    extends State<SettingsUpdatePeriodPicker> {
  List<UpdatePeriod>? _periodList;

  @override
  void initState() {
    super.initState();
    _preparePeriods();
  }

  @override
  Widget build(
    BuildContext context,
  ) =>
      AppUiOverlayStyle(
        themeMode: context.watch<AppBloc>().state.themeMode,
        colorTheme: (context.watch<AppBloc>().state.colorTheme ?? false),
        systemNavigationBarIconBrightness:
            context.watch<AppBloc>().state.colorTheme! ? Brightness.dark : null,
        child: Theme(
          data: (context.watch<AppBloc>().state.themeMode == ThemeMode.dark)
              ? appDarkThemeData
              : appLightThemeData,
          child: Scaffold(
            extendBody: true,
            body: _buildBody(),
          ),
        ),
      );

  Future<void> _preparePeriods() async {
    List<UpdatePeriod>? periods = <UpdatePeriod>[];

    try {
      for (UpdatePeriod period in UpdatePeriod.values) {
        periods.add(period);
      }
    } on PlatformException {
      periods = null;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _periodList = periods;
    });
  }

  Widget _buildBody() => Column(
        children: <Widget>[
          Expanded(child: _buildListOfPeriods()),
        ],
      );

  Widget _buildListOfPeriods() => ListView.separated(
        itemBuilder: (
          BuildContext context,
          int index,
        ) {
          final UpdatePeriod period = _periodList![index];

          return ListTile(
            key: Key('period_${period.id}'),
            title: Text(
              period.text!,
              style: Theme.of(context).textTheme.headline5!.copyWith(
                    color: _getPeriodColor(period),
                  ),
            ),
            onTap: () => _tapPeriod(period),
          );
        },
        separatorBuilder: (context, index) => Divider(),
        itemCount: (_periodList != null) ? _periodList!.length : 0,
      );

  void _tapPeriod(
    UpdatePeriod period,
  ) async {
    closeKeyboard(context);
    widget.onTap(period);
  }

  Color? _getPeriodColor(
    UpdatePeriod period,
  ) {
    if (widget.selectedPeriod?.id == period.id) {
      return AppTheme.primaryColor;
    }

    return null;
  }
}
