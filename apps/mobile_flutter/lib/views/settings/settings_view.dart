import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/env_config.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/model.dart';
import 'package:flutter_weather/theme.dart';
import 'package:flutter_weather/utils/common_utils.dart';
import 'package:flutter_weather/views/about/privacyPolicy/privacy_policy_view.dart';
import 'package:flutter_weather/views/forecast/forecast_utils.dart';
import 'package:flutter_weather/widgets/app_checkbox_tile.dart';
import 'package:flutter_weather/widgets/app_radio_tile.dart';
import 'package:flutter_weather/widgets/app_section_header.dart';
import 'package:flutter_weather/widgets/app_ui_overlay_style.dart';
import 'package:package_info/package_info.dart';
import 'package:version/version.dart';

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
  AppBloc _bloc;
  PackageInfo _packageInfo;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<AppBloc>();
    _initPackageInfo();
  }

  @override
  Widget build(
    BuildContext context,
  ) =>
      AppUiOverlayStyle(
        themeMode: _bloc.state.themeMode,
        colorTheme: _bloc.state.colorTheme,
        systemNavigationBarIconBrightness:
            _bloc.state.colorTheme ? Brightness.dark : null,
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

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() => _packageInfo = info);
  }

  Widget _buildContent() => SafeArea(
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            children: <Widget>[]
              ..addAll(_buildThemeModeSection())
              ..addAll(_buildTemperatureUnitSection())
              ..addAll(_buildAboutSection())
              ..addAll(_buildBuildInfoSection())
              ..add(_buildOpenSourceSection()),
          ),
        ),
      );

  List<Widget> _buildThemeModeSection() {
    ThemeMode _themeMode = _bloc.state.themeMode;
    List<Widget> widgets = <Widget>[];
    widgets.addAll(
      [
        AppSectionHeader(
          bloc: _bloc,
          text: AppLocalizations.of(context).themeMode,
        ),
        AppRadioTile<ThemeMode>(
          bloc: _bloc,
          title: AppLocalizations.of(context).light,
          value: ThemeMode.light,
          groupValue: _themeMode,
          onTap: _tapThemeMode,
        ),
        Divider(),
      ],
    );

    if (_themeMode == ThemeMode.light && hasForecasts(_bloc.state.forecasts)) {
      widgets.addAll(
        [
          AppChekboxTile(
            bloc: _bloc,
            title: AppLocalizations.of(context).colorized,
            checked: _bloc.state.colorTheme,
            onTap: _tapColorized,
          ),
          Divider(),
        ],
      );
    }

    widgets.add(
      AppRadioTile<ThemeMode>(
        bloc: _bloc,
        title: AppLocalizations.of(context).dark,
        value: ThemeMode.dark,
        groupValue: _themeMode,
        onTap: _tapThemeMode,
      ),
    );

    return widgets;
  }

  List<Widget> _buildTemperatureUnitSection() {
    TemperatureUnit _temperatureUnit = _bloc.state.temperatureUnit;

    return [
      AppSectionHeader(
        bloc: _bloc,
        text: AppLocalizations.of(context).temperatureUnit,
      ),
      AppRadioTile<TemperatureUnit>(
        bloc: _bloc,
        title: AppLocalizations.of(context).celsius,
        value: TemperatureUnit.celsius,
        groupValue: _temperatureUnit,
        onTap: _tapTemperatureUnit,
      ),
      Divider(),
      AppRadioTile<TemperatureUnit>(
        bloc: _bloc,
        title: AppLocalizations.of(context).fahrenheit,
        value: TemperatureUnit.fahrenheit,
        groupValue: _temperatureUnit,
        onTap: _tapTemperatureUnit,
      ),
      Divider(),
      AppRadioTile<TemperatureUnit>(
        bloc: _bloc,
        title: AppLocalizations.of(context).kelvin,
        value: TemperatureUnit.kelvin,
        groupValue: _temperatureUnit,
        onTap: _tapTemperatureUnit,
      ),
    ];
  }

  List<Widget> _buildAboutSection() => (_packageInfo == null)
      ? [Container()]
      : [
          AppSectionHeader(
            bloc: _bloc,
            text: AppLocalizations.of(context).about,
          ),
          ListTile(
            title: RichText(
              text: TextSpan(
                text: AppLocalizations.of(context).privacyPolicy,
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()..onTap = _tapPrivacyPolicy,
              ),
            ),
          ),
          Divider(),
        ];

  List<Widget> _buildBuildInfoSection() => (_packageInfo == null)
      ? [Container()]
      : [
          AppSectionHeader(
            bloc: _bloc,
            text: AppLocalizations.of(context).buildInformation,
          ),
          ListTile(
            title: Text(
              _packageInfo.version,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            trailing: _buildVersionText(),
          ),
          Divider(),
        ];

  Widget _buildVersionText() {
    Version latestVersion;

    if (_bloc.state.appVersion.contains('+')) {
      latestVersion = Version.parse(_bloc.state.appVersion.split('+')[0]);
    } else {
      latestVersion = Version.parse(_bloc.state.appVersion);
    }

    Version currentVersion = Version.parse(_packageInfo.version);
    if (latestVersion > currentVersion) {
      return Text(
        AppLocalizations.of(context).updateAvailable,
        style: TextStyle(
          color: AppTheme.warningColor,
          fontWeight: FontWeight.w700,
        ),
      );
    }

    return Text(
      AppLocalizations.of(context).latest,
      style: TextStyle(
        color: AppTheme.successColor,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildOpenSourceSection() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            GestureDetector(
              onTap: () => launchURL(EnvConfig.GITHUB_LINK),
              child: Image.asset(
                (_bloc.state.themeMode == ThemeMode.light)
                    ? 'assets/images/github_dark.png'
                    : 'assets/images/github_light.png',
                width: 50.0,
                height: 50.0,
              ),
            ),
            GestureDetector(
              onTap: () => launchURL('https://opensource.org/'),
              child: Image.asset(
                'assets/images/osi.png',
                width: 50.0,
                height: 50.0,
              ),
            ),
          ],
        ),
      );

  void _tapThemeMode(
    ThemeMode themeMode,
  ) =>
      _bloc.add(SetThemeMode(themeMode));

  void _tapColorized(
    bool checked,
  ) =>
      _bloc.add(SetColorTheme(checked));

  void _tapTemperatureUnit(
    TemperatureUnit temperatureUnit,
  ) =>
      _bloc.add(SetTemperatureUnit(temperatureUnit));

  void _tapPrivacyPolicy() =>
      Navigator.push(context, PrivacyPolicyView.route());
}
