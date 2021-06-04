import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/about/view/view.dart';
import 'package:flutter_weather/app/app_config.dart';
import 'package:flutter_weather/app/app_localization.dart';
import 'package:flutter_weather/app/app_theme.dart';
import 'package:flutter_weather/app/utils/utils.dart';
import 'package:flutter_weather/app/widgets/widgets.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/enums/enums.dart';
import 'package:flutter_weather/settings/settings.dart' as settingsUtils;
import 'package:flutter_weather/settings/widgets/widgets.dart';
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
  int? _pageListIndex;

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
            title: Text(settingsUtils.getTitle(context, _pageListIndex)),
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
      setState(() => _pageListIndex = null);
      await animatePage(_pageController!, page: 0);
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<bool> _willPopCallback() async {
    if (_currentPage > 0) {
      setState(() => _pageListIndex = null);
      await animatePage(_pageController!, page: 0);
      return Future.value(false);
    }

    return Future.value(true);
  }

  Widget _buildContent() {
    List<Widget> children = []
      ..addAll(_buildApplicationSection())
      ..addAll(_buildAutoUpdatePeriodSection())
      ..addAll(_buildUnitsSection());

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
        _getPage(context.read<AppBloc>().state),
      ],
    );
  }

  List<Widget> _buildApplicationSection() {
    List<Widget> widgets = <Widget>[];
    widgets.addAll(
      [
        AppSectionHeader(
          text: AppLocalizations.of(context)!.application,
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 4.0,
            top: 16.0,
            bottom: 16.0,
          ),
        ),
        SettingsOption(
          pageController: _pageController!,
          title: AppLocalizations.of(context)!.themeMode,
          trailingText: settingsUtils.getThemeModeText(
            context,
            themeMode: context.read<AppBloc>().state.themeMode,
            colorized: context.read<AppBloc>().state.colorTheme,
          ),
          onTapCallback: () => _setPageListIndex(2),
        ),
        Divider(),
        SettingsOption(
          pageController: _pageController!,
          title: AppLocalizations.of(context)!.chartType,
          trailingText:
              context.read<AppBloc>().state.chartType.getText(context),
          onTapCallback: () => _setPageListIndex(3),
        ),
        Divider(),
        SettingsOption(
          pageController: _pageController!,
          title: AppLocalizations.of(context)!.hourRange,
          trailingText:
              context.read<AppBloc>().state.hourRange.getText(context),
          onTapCallback: () => _setPageListIndex(4),
        ),
      ],
    );

    return widgets;
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
                  value ? UpdatePeriod.hour2 : null,
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
        SettingsOption(
          pageController: _pageController!,
          title: AppLocalizations.of(context)!.updatePeriod,
          trailingText: context
              .read<AppBloc>()
              .state
              .updatePeriod!
              .getInfo(context: context)!['text'],
          onTapCallback: () => _setPageListIndex(0),
        ),
        Divider(),
        SettingsOption(
          pageController: _pageController!,
          title: AppLocalizations.of(context)!.pushNotification,
          trailingText: settingsUtils.getPushNotificationText(
                context,
                context.read<AppBloc>().state.pushNotification,
                extras: context.read<AppBloc>().state.pushNotificationExtras,
              ) ??
              '',
          onTapCallback: () => _setPageListIndex(1),
        ),
      ]);
    }

    return widgets;
  }

  List<Widget> _buildUnitsSection() => [
        AppSectionHeader(
          text: AppLocalizations.of(context)!.units,
        ),
        SettingsOption(
          pageController: _pageController!,
          title: AppLocalizations.of(context)!.temperature,
          trailingText:
              context.read<AppBloc>().state.units.temperature.getText(context),
          onTapCallback: () => _setPageListIndex(5),
        ),
        Divider(),
        SettingsOption(
          pageController: _pageController!,
          title: AppLocalizations.of(context)!.windSpeed,
          trailingText:
              context.read<AppBloc>().state.units.windSpeed.getText(context),
          onTapCallback: () => _setPageListIndex(6),
        ),
        Divider(),
        SettingsOption(
          pageController: _pageController!,
          title: AppLocalizations.of(context)!.pressure,
          trailingText:
              context.read<AppBloc>().state.units.pressure.getText(context),
          onTapCallback: () => _setPageListIndex(7),
        ),
        Divider(),
        SettingsOption(
          pageController: _pageController!,
          title: AppLocalizations.of(context)!.distance,
          trailingText:
              context.read<AppBloc>().state.units.distance.getText(context),
          onTapCallback: () => _setPageListIndex(8),
        ),
      ];

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
      ];

  List<Widget> _buildBuildInfoSection() => [
        AppSectionHeader(
          text: AppLocalizations.of(context)!.buildInformation,
        ),
        ListTile(
          title: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                scrubVersion(_packageInfo.version),
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Text(
                scrubVersion(_packageInfo.buildNumber),
                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      color: AppTheme.getHintColor(
                        context.read<AppBloc>().state.themeMode,
                        colorTheme: context.read<AppBloc>().state.colorTheme,
                      ),
                    ),
              ),
            ],
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

  void _tapPrivacyPolicy() =>
      Navigator.push(context, PrivacyPolicyView.route());

  List<Widget> _getPages(
    AppState state,
  ) =>
      [
        SettingsUpdatePeriodPicker(selectedPeriod: state.updatePeriod),
        SettingsPushNotificationPicker(
          selectedNotification: state.pushNotification,
          selectedNotificationExtras: state.pushNotificationExtras,
        ),
        SettingsThemeModePicker(),
        SettingsChartTypePicker(),
        SettingsHourRangePicker(),
        SettingsTemperatureUnitsPicker(),
        SettingsWindSpeedUnitsPicker(),
        SettingsPressureUnitsPicker(),
        SettingsDistanceUnitsPicker(),
      ];

  Widget _getPage(
    AppState state,
  ) =>
      _getPages(state)[_pageListIndex ?? 0];

  void _setPageListIndex(
    int pageIndex,
  ) =>
      setState(() => _pageListIndex = pageIndex);
}
