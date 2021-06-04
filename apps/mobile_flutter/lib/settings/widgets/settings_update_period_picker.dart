import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_weather/app/app_theme.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';
import 'package:flutter_weather/app/utils/utils.dart';
import 'package:flutter_weather/app/widgets/widgets.dart';
import 'package:flutter_weather/enums/enums.dart';

class SettingsUpdatePeriodPicker extends StatefulWidget {
  final UpdatePeriod? selectedPeriod;

  SettingsUpdatePeriodPicker({
    Key? key,
    this.selectedPeriod,
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

  Widget _buildBody() => ListView.separated(
        itemBuilder: (
          BuildContext context,
          int index,
        ) {
          final UpdatePeriod period = _periodList![index];
          Map<String, dynamic> periodInfo = period.getInfo(context: context)!;

          return ListTile(
            key: Key('period_${periodInfo['id']}'),
            title: Text(
              periodInfo['text'],
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
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
    context.read<AppBloc>().add(SetUpdatePeriod(
          context: context,
          updatePeriod: period,
        ));
  }

  Color? _getPeriodColor(
    UpdatePeriod period,
  ) {
    if (widget.selectedPeriod?.getInfo()!['id'] == period.getInfo()!['id']) {
      return AppTheme.primaryColor;
    }

    return null;
  }
}
