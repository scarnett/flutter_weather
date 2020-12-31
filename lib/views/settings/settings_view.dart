import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/model.dart';
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
  @override
  Widget build(
    BuildContext context,
  ) =>
      AppUiOverlayStyle(
        bloc: context.watch<AppBloc>(),
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

  Widget _buildContent() {
    AppBloc bloc = context.watch<AppBloc>();

    return SafeArea(
      child: Column(
        children: <Widget>[]
          ..addAll(_buildThemeModeSection(bloc))
          ..addAll(_buildTemperatureUnitSection(bloc)),
      ),
    );
  }

  List<Widget> _buildThemeModeSection(
    AppBloc bloc,
  ) {
    ThemeMode _themeMode = context.watch<AppBloc>().state.themeMode;

    return [
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
      AppRadioTile<ThemeMode>(
        bloc: bloc,
        title: AppLocalizations.of(context).dark,
        value: ThemeMode.dark,
        groupValue: _themeMode,
        onTap: _tapThemeMode,
      ),
    ];
  }

  List<Widget> _buildTemperatureUnitSection(
    AppBloc bloc,
  ) {
    TemperatureUnit _temperatureUnit =
        context.watch<AppBloc>().state.temperatureUnit;

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
    ];
  }

  void _tapThemeMode(
    ThemeMode themeMode,
  ) =>
      context.read<AppBloc>().add(SetThemeMode(themeMode));

  void _tapTemperatureUnit(
    TemperatureUnit temperatureUnit,
  ) =>
      context.read<AppBloc>().add(SetTemperatureUnit(temperatureUnit));
}
