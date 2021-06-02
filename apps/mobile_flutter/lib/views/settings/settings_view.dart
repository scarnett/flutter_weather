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
import 'package:flutter_weather/views/settings/settings_enums.dart';
import 'package:flutter_weather/views/settings/settings_utils.dart'
    as settingsUtils;
import 'package:flutter_weather/views/settings/widgets/settings_chart_type_picker.dart';
import 'package:flutter_weather/views/settings/widgets/settings_open_source_info.dart';
import 'package:flutter_weather/views/settings/widgets/settings_push_notification_picker.dart';
import 'package:flutter_weather/views/settings/widgets/settings_theme_mode_picker.dart';
import 'package:flutter_weather/views/settings/widgets/settings_update_period_picker.dart';
import 'package:flutter_weather/views/settings/widgets/settings_version_status_text.dart';
import 'package:flutter_weather/widgets/app_radio_tile.dart';
import 'package:flutter_weather/widgets/app_section_header.dart';
import 'package:flutter_weather/widgets/app_ui_overlay_style.dart';
import 'package:flutter_weather/widgets/app_ui_safe_area.dart';
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
        systemNavigationBarIconBrightness:
            context.read<AppBloc>().state.colorTheme ? Brightness.dark : null,
        child: Scaffold(
          appBar: AppBar(
            title: Text(settingsUtils.getTitle(context, _currentPage)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _handleBack,
            ),
          ),
          body: WillPopScope(
            onWillPop: () => _willPopCallback(),
            child: _buildContent(),
          ),
          extendBody: true,
          extendBodyBehindAppBar: true,
        ),
      );

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() => _packageInfo = info);
  }

  Future<void> _handleBack() async {
    if (_currentPage > 0) {
      await animatePage(_pageController!, page: 0);
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<bool> _willPopCallback() async {
    if (_currentPage > 0) {
      await animatePage(_pageController!, page: 0);
      return Future.value(false);
    }

    return Future.value(true);
  }

  Widget _buildContent() {
    AppState state = context.read<AppBloc>().state;
    List<Widget> children = []
      ..addAll(_buildAutoUpdatePeriodSection())
      ..addAll(_buildThemeModeSection())
      ..addAll(_buildTemperatureUnitSection());

    if (AppConfig.instance.privacyPolicyUrl != '') {
      children..addAll(_buildAboutSection());
    }

    children..addAll(_buildBuildInfoSection());
    children..add(SettingsOpenSourceInfo());

    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: AppUiSafeArea(
            child: Column(children: children),
          ),
        ),
        SettingsUpdatePeriodPicker(
          selectedPeriod: state.updatePeriod,
          onTap: (UpdatePeriod period) => _tapUpdatePeriod(period),
        ),
        SettingsPushNotificationPicker(
          selectedNotification: state.pushNotification,
          selectedNotificationExtras: state.pushNotificationExtras,
          onTap: (
            PushNotification? notification,
            Map<String, dynamic>? extras,
          ) async =>
              await _tapPushNotification(notification, extras: extras),
        ),
        SettingsThemeModePicker(
          onTapThemeMode: (ThemeMode? themeMode) async =>
              await _tapThemeMode(themeMode),
          onTapColorized: (bool? colorized) async =>
              await _tapColorized(colorized),
        ),
        SettingsChartTypePicker(
          onTap: (ChartType? chartType) => _tapChartType(chartType),
        ),
      ],
    );
  }

  List<Widget> _buildAutoUpdatePeriodSection() {
    UpdatePeriod? updatePeriod = context.read<AppBloc>().state.updatePeriod;
    List<Widget> widgets = <Widget>[];
    widgets.addAll(
      [
        AppSectionHeader(
          text: AppLocalizations.of(context)!.autoUpdates,
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
                onChanged: (bool value) async => await _tapUpdatePeriod(
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
          trailing: Text(
            context
                .read<AppBloc>()
                .state
                .updatePeriod!
                .getInfo(context: context)!['text'],
            style: Theme.of(context).textTheme.subtitle1,
          ),
          onTap: () async => await animatePage(_pageController!, page: 1),
        ),
        Divider(),
        ListTile(
          title: Text(
            AppLocalizations.of(context)!.pushNotification,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          trailing: Text(
            settingsUtils.getPushNotificationText(
                  context,
                  context.read<AppBloc>().state.pushNotification,
                  extras: context.read<AppBloc>().state.pushNotificationExtras,
                ) ??
                '',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          onTap: () async => await animatePage(_pageController!, page: 2),
        ),
      ]);
    }

    return widgets;
  }

  List<Widget> _buildThemeModeSection() {
    List<Widget> widgets = <Widget>[];
    widgets.addAll(
      [
        AppSectionHeader(
          text: AppLocalizations.of(context)!.forecast,
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 4.0,
            top: 16.0,
            bottom: 16.0,
          ),
        ),
        ListTile(
          title: Text(
            AppLocalizations.of(context)!.themeMode,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          trailing: Text(
            settingsUtils.getThemeModeText(
              context,
              themeMode: context.read<AppBloc>().state.themeMode,
              colorized: context.read<AppBloc>().state.colorTheme,
            ),
            style: Theme.of(context).textTheme.subtitle1,
          ),
          onTap: () async => await animatePage(_pageController!, page: 3),
        ),
        Divider(),
        ListTile(
          title: Text(
            AppLocalizations.of(context)!.chartType,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          trailing: Text(
            context.read<AppBloc>().state.chartType.getText(context),
            style: Theme.of(context).textTheme.subtitle1,
          ),
          onTap: () async => await animatePage(_pageController!, page: 4),
        ),
        Divider(),
        ListTile(
          title: Text(
            AppLocalizations.of(context)!.hourRange,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          trailing: Text(
            context.read<AppBloc>().state.forecastHourRange.getText(context),
            style: Theme.of(context).textTheme.subtitle1,
          ),
          onTap: () async => await animatePage(_pageController!, page: 5),
        ),
      ],
    );

    return widgets;
  }

  List<Widget> _buildTemperatureUnitSection() {
    TemperatureUnit _temperatureUnit =
        context.read<AppBloc>().state.temperatureUnit;

    return [
      AppSectionHeader(
        text: AppLocalizations.of(context)!.temperatureUnit,
      ),
      AppRadioTile<TemperatureUnit>(
        title: AppLocalizations.of(context)!.celsius,
        value: TemperatureUnit.celsius,
        groupValue: _temperatureUnit,
        onTap: _tapTemperatureUnit,
      ),
      Divider(),
      AppRadioTile<TemperatureUnit>(
        title: AppLocalizations.of(context)!.fahrenheit,
        value: TemperatureUnit.fahrenheit,
        groupValue: _temperatureUnit,
        onTap: _tapTemperatureUnit,
      ),
      Divider(),
      AppRadioTile<TemperatureUnit>(
        title: AppLocalizations.of(context)!.kelvin,
        value: TemperatureUnit.kelvin,
        groupValue: _temperatureUnit,
        onTap: _tapTemperatureUnit,
      ),
    ];
  }

  List<Widget> _buildAboutSection() => [
        AppSectionHeader(
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
          text: AppLocalizations.of(context)!.buildInformation,
        ),
        ListTile(
          title: Text(
            scrubVersion(_packageInfo.version),
            style: Theme.of(context).textTheme.subtitle1,
          ),
          trailing: SettingsVersionStatusText(
            packageInfo: _packageInfo,
          ),
        ),
        Divider(),
      ];

  void _onPageChange(
    num currentPage,
  ) {
    setState(() => _currentPage = currentPage);
  }

  Future<void> _tapUpdatePeriod(
    UpdatePeriod? period, {
    bool redirect: true,
  }) async {
    context.read<AppBloc>().add(
          SetUpdatePeriod(
            context: context,
            updatePeriod: period,
            callback: () async {
              if (redirect) {
                await animatePage(_pageController!, page: 0);
              }
            },
          ),
        );
  }

  Future<void> _tapPushNotification(
    PushNotification? notification, {
    Map<String, dynamic>? extras,
    bool redirect: true,
  }) async {
    context.read<AppBloc>().add(
          SetPushNotification(
            context: context,
            pushNotification: notification,
            pushNotificationExtras: extras,
            callback: () async {
              if (redirect) {
                await animatePage(_pageController!, page: 0);
              }
            },
          ),
        );
  }

  Future<void> _tapThemeMode(
    ThemeMode? themeMode, {
    bool redirect: true,
  }) async {
    context.read<AppBloc>().add(SetThemeMode(themeMode));

    if (redirect) {
      await animatePage(_pageController!, page: 0, pauseMilliseconds: 1000);
    }
  }

  Future<void> _tapColorized(
    bool? colorized, {
    bool redirect: true,
  }) async {
    context.read<AppBloc>().add(SetColorTheme(colorized));

    if (redirect) {
      await animatePage(_pageController!, page: 0, pauseMilliseconds: 1000);
    }
  }

  Future<void> _tapChartType(
    ChartType? chartType, {
    bool redirect: true,
  }) async {
    context.read<AppBloc>().add(SetChartType(chartType));

    if (redirect) {
      await animatePage(_pageController!, page: 0, pauseMilliseconds: 500);
    }
  }

  void _tapTemperatureUnit(
    TemperatureUnit? temperatureUnit,
  ) =>
      context.read<AppBloc>().add(SetTemperatureUnit(temperatureUnit));

  void _tapPrivacyPolicy() =>
      Navigator.push(context, PrivacyPolicyView.route());
}
