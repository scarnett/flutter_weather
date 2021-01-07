import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/model.dart';
import 'package:flutter_weather/widgets/app_checkbox_tile.dart';
import 'package:flutter_weather/widgets/app_radio_tile.dart';
import 'package:flutter_weather/widgets/app_section_header.dart';
import 'package:flutter_weather/widgets/app_ui_overlay_style.dart';

class SettingsView extends StatelessWidget {
  static Route route() =>
      MaterialPageRoute<void>(builder: (_) => SettingsView());

  const SettingsView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) =>
      SettingsPageView();
}

class SettingsPageView extends StatefulWidget {
  SettingsPageView({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsPageViewState();
}

class _SettingsPageViewState extends State<SettingsPageView> {
  AppBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = context.read<AppBloc>();
  }

  @override
  Widget build(
    BuildContext context,
  ) =>
      AppUiOverlayStyle(
        bloc: bloc,
        systemNavigationBarIconBrightness:
            bloc.state.colorTheme ? Brightness.dark : null,
        child: Scaffold(
          extendBody: true,
          appBar: AppBar(
            title: Text(AppLocalizations.of(context).settings),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: _buildContent(),
        ),
      );

  Widget _buildContent() => SafeArea(
        child: Column(
          children: <Widget>[]
            ..addAll(_buildThemeModeSection())
            ..addAll(_buildTemperatureUnitSection()),
        ),
      );

  List<Widget> _buildThemeModeSection() {
    ThemeMode _themeMode = bloc.state.themeMode;
    List<Widget> widgets = <Widget>[];
    widgets.addAll(
      [
        AppSectionHeader(
          bloc: bloc,
          text: AppLocalizations.of(context).themeMode,
        ),
        AppRadioTile<ThemeMode>(
          bloc: bloc,
          title: AppLocalizations.of(context).light,
          value: ThemeMode.light,
          groupValue: _themeMode,
          onTap: _tapThemeMode,
        ),
        Divider(),
      ],
    );

    if (_themeMode == ThemeMode.light) {
      widgets.addAll(
        [
          AppChekboxTile(
            bloc: bloc,
            title: AppLocalizations.of(context).colorized,
            checked: bloc.state.colorTheme,
            onTap: _tapColorized,
          ),
          Divider(),
        ],
      );
    }

    widgets.add(
      AppRadioTile<ThemeMode>(
        bloc: bloc,
        title: AppLocalizations.of(context).dark,
        value: ThemeMode.dark,
        groupValue: _themeMode,
        onTap: _tapThemeMode,
      ),
    );

    return widgets;
  }

  List<Widget> _buildTemperatureUnitSection() {
    TemperatureUnit _temperatureUnit = bloc.state.temperatureUnit;

    return [
      AppSectionHeader(
        bloc: bloc,
        text: AppLocalizations.of(context).temperatureUnit,
      ),
      AppRadioTile<TemperatureUnit>(
        bloc: bloc,
        title: AppLocalizations.of(context).celsius,
        value: TemperatureUnit.celsius,
        groupValue: _temperatureUnit,
        onTap: _tapTemperatureUnit,
      ),
      Divider(),
      AppRadioTile<TemperatureUnit>(
        bloc: bloc,
        title: AppLocalizations.of(context).fahrenheit,
        value: TemperatureUnit.fahrenheit,
        groupValue: _temperatureUnit,
        onTap: _tapTemperatureUnit,
      ),
      Divider(),
      AppRadioTile<TemperatureUnit>(
        bloc: bloc,
        title: AppLocalizations.of(context).kelvin,
        value: TemperatureUnit.kelvin,
        groupValue: _temperatureUnit,
        onTap: _tapTemperatureUnit,
      ),
      Divider(),
    ];
  }

  void _tapThemeMode(
    ThemeMode themeMode,
  ) =>
      bloc.add(SetThemeMode(themeMode));

  void _tapColorized(
    bool checked,
  ) =>
      bloc.add(SetColorTheme(checked));

  void _tapTemperatureUnit(
    TemperatureUnit temperatureUnit,
  ) =>
      bloc.add(SetTemperatureUnit(temperatureUnit));
}
