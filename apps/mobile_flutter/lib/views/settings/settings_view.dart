import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/config.dart';
import 'package:flutter_weather/enums.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/theme.dart';
import 'package:flutter_weather/utils/common_utils.dart';
import 'package:flutter_weather/utils/version_utils.dart';
import 'package:flutter_weather/views/about/privacyPolicy/privacy_policy_view.dart';
import 'package:flutter_weather/views/forecast/forecast_utils.dart'
    as forecastUtils;
import 'package:flutter_weather/views/settings/settings_utils.dart'
    as settingsUtils;
import 'package:flutter_weather/views/settings/widgets/settings_enums.dart';
import 'package:flutter_weather/views/settings/widgets/settings_open_source_info.dart';
import 'package:flutter_weather/views/settings/widgets/settings_update_period_picker.dart';
import 'package:flutter_weather/views/settings/widgets/settings_version_status_text.dart';
import 'package:flutter_weather/widgets/app_checkbox_tile.dart';
import 'package:flutter_weather/widgets/app_radio_tile.dart';
import 'package:flutter_weather/widgets/app_section_header.dart';
import 'package:flutter_weather/widgets/app_ui_overlay_style.dart';
import 'package:package_info/package_info.dart';

class SettingsView extends StatelessWidget {
  static Route route() =>
      MaterialPageRoute<void>(builder: (_) => SettingsView());

  const SettingsView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) =>
      SettingsPageView();
}

class SettingsPageView extends StatefulWidget {
  SettingsPageView({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsPageViewState();
}

class _SettingsPageViewState extends State<SettingsPageView> {
  PageController? _pageController;
  num _currentPage = 0;

  PackageInfo _packageInfo = PackageInfo(
    appName: 'unknown',
    packageName: 'unknown',
    version: 'unknown',
    buildNumber: 'unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();

    _pageController = PageController(keepPage: true)
      ..addListener(() {
        _onPageChange(_pageController!.page ?? 0);
      });
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) =>
      AppUiOverlayStyle(
        themeMode: context.read<AppBloc>().state.themeMode,
        colorTheme: context.read<AppBloc>().state.colorTheme,
        systemNavigationBarIconBrightness:
            context.read<AppBloc>().state.colorTheme ? Brightness.dark : null,
        child: Scaffold(
          extendBody: true,
          appBar: AppBar(
            title: Text(settingsUtils.getTitle(context, _currentPage)),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: _handleBack,
            ),
          ),
          body: WillPopScope(
            onWillPop: () => _willPopCallback(),
            child: _buildContent(),
          ),
        ),
      );

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() => _packageInfo = info);
  }

  Future<void> _handleBack() async {
    if (_currentPage > 0) {
      animatePage(_pageController!, page: 0);
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<bool> _willPopCallback() async {
    if (_currentPage > 0) {
      animatePage(_pageController!, page: 0);
      return Future.value(false);
    }

    return Future.value(true);
  }

  Widget _buildContent() {
    List<Widget> children = []
      ..addAll(_buildAutoUpdatePeriodSection())
      ..addAll(_buildThemeModeSection())
      ..addAll(_buildTemperatureUnitSection());

    if (AppConfig.instance.privacyPolicyUrl != null) {
      children..addAll(_buildAboutSection());
    }

    children..addAll(_buildBuildInfoSection());
    children
      ..add(SettingsOpenSourceInfo(
        themeMode: context.read<AppBloc>().state.themeMode,
      ));

    return SafeArea(
      child: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(children: children),
          ),
          SettingsUpdatePeriodPicker(
            selectedPeriod: context.read<AppBloc>().state.updatePeriod,
            onTap: (UpdatePeriod period) => _tapUpdatePeriod(period),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAutoUpdatePeriodSection() {
    UpdatePeriod? updatePeriod = context.read<AppBloc>().state.updatePeriod;
    List<Widget> widgets = <Widget>[];
    widgets.addAll(
      [
        AppSectionHeader(
          bloc: context.read<AppBloc>(),
          text: AppLocalizations.of(context)!.autoUpdate,
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 4.0,
            top: 16.0,
            bottom: 16.0,
          ),
          options: [
            SizedBox(
              height: 16.0,
              child: Switch(
                onChanged: (bool value) => _tapUpdatePeriod(
                  value ? UpdatePeriod.HOUR2 : null,
                  redirect: false,
                ),
                value: (updatePeriod != null),
              ),
            ),
          ],
        ),
      ],
    );

    if (updatePeriod != null) {
      widgets.addAll([
        Divider(),
        ListTile(
          title: Text(
            AppLocalizations.of(context)!.updatePeriod,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          trailing:
              Text(context.read<AppBloc>().state.updatePeriod!.info!['text']),
          onTap: () => animatePage(_pageController!, page: 1),
        ),
      ]);
    }

    return widgets;
  }

  List<Widget> _buildThemeModeSection() {
    ThemeMode _themeMode = context.read<AppBloc>().state.themeMode;
    List<Widget> widgets = <Widget>[];
    widgets.addAll(
      [
        AppSectionHeader(
          bloc: context.read<AppBloc>(),
          text: AppLocalizations.of(context)!.themeMode,
        ),
        AppRadioTile<ThemeMode>(
          bloc: context.read<AppBloc>(),
          title: AppLocalizations.of(context)!.light,
          value: ThemeMode.light,
          groupValue: _themeMode,
          onTap: _tapThemeMode,
        ),
        Divider(),
      ],
    );

    if ((_themeMode == ThemeMode.light) &&
        forecastUtils.hasForecasts(context.read<AppBloc>().state.forecasts)) {
      widgets.addAll(
        [
          AppChekboxTile(
            bloc: context.read<AppBloc>(),
            title: AppLocalizations.of(context)!.colorized,
            checked: context.read<AppBloc>().state.colorTheme,
            onTap: _tapColorized,
          ),
          Divider(),
        ],
      );
    }

    widgets.add(
      AppRadioTile<ThemeMode>(
        bloc: context.read<AppBloc>(),
        title: AppLocalizations.of(context)!.dark,
        value: ThemeMode.dark,
        groupValue: _themeMode,
        onTap: _tapThemeMode,
      ),
    );

    return widgets;
  }

  List<Widget> _buildTemperatureUnitSection() {
    TemperatureUnit _temperatureUnit =
        context.read<AppBloc>().state.temperatureUnit;

    return [
      AppSectionHeader(
        bloc: context.read<AppBloc>(),
        text: AppLocalizations.of(context)!.temperatureUnit,
      ),
      AppRadioTile<TemperatureUnit>(
        bloc: context.read<AppBloc>(),
        title: AppLocalizations.of(context)!.celsius,
        value: TemperatureUnit.celsius,
        groupValue: _temperatureUnit,
        onTap: _tapTemperatureUnit,
      ),
      Divider(),
      AppRadioTile<TemperatureUnit>(
        bloc: context.read<AppBloc>(),
        title: AppLocalizations.of(context)!.fahrenheit,
        value: TemperatureUnit.fahrenheit,
        groupValue: _temperatureUnit,
        onTap: _tapTemperatureUnit,
      ),
      Divider(),
      AppRadioTile<TemperatureUnit>(
        bloc: context.read<AppBloc>(),
        title: AppLocalizations.of(context)!.kelvin,
        value: TemperatureUnit.kelvin,
        groupValue: _temperatureUnit,
        onTap: _tapTemperatureUnit,
      ),
    ];
  }

  List<Widget> _buildAboutSection() => [
        AppSectionHeader(
          bloc: context.read<AppBloc>(),
          text: AppLocalizations.of(context)!.about,
        ),
        ListTile(
          title: RichText(
            text: TextSpan(
              text: AppLocalizations.of(context)!.privacyPolicy,
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

  List<Widget> _buildBuildInfoSection() => [
        AppSectionHeader(
          bloc: context.read<AppBloc>(),
          text: AppLocalizations.of(context)!.buildInformation,
        ),
        ListTile(
          title: Text(
            scrubVersion(_packageInfo.version),
            style: Theme.of(context).textTheme.subtitle1,
          ),
          trailing: SettingsVersionStatusText(
            bloc: context.read<AppBloc>(),
            packageInfo: _packageInfo,
          ),
          onTap: () => animatePage(_pageController!, page: 1),
        ),
        Divider(),
      ];

  void _onPageChange(
    num currentPage,
  ) {
    setState(() => _currentPage = currentPage);
  }

  void _tapUpdatePeriod(
    UpdatePeriod? period, {
    bool redirect: true,
  }) {
    context.read<AppBloc>().add(SetUpdatePeriod(updatePeriod: period));

    if (redirect) {
      animatePage(_pageController!, page: 0);
    }
  }

  void _tapThemeMode(
    ThemeMode? themeMode,
  ) =>
      context.read<AppBloc>().add(SetThemeMode(themeMode));

  void _tapColorized(
    bool? checked,
  ) =>
      context.read<AppBloc>().add(SetColorTheme(checked));

  void _tapTemperatureUnit(
    TemperatureUnit? temperatureUnit,
  ) =>
      context.read<AppBloc>().add(SetTemperatureUnit(temperatureUnit));

  void _tapPrivacyPolicy() =>
      Navigator.push(context, PrivacyPolicyView.route());
}
