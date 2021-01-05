import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/env_config.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/theme.dart';
import 'package:flutter_weather/utils/date_utils.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_display.dart';
import 'package:flutter_weather/views/lookup/lookup_view.dart';
import 'package:flutter_weather/views/settings/settings_view.dart';
import 'package:flutter_weather/widgets/app_day_night_switch.dart';
import 'package:flutter_weather/widgets/app_ui_overlay_style.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class ForecastView extends StatelessWidget {
  static Route route() =>
      MaterialPageRoute<void>(builder: (_) => ForecastView());

  const ForecastView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) =>
      ForecastPageView();
}

class ForecastPageView extends StatefulWidget {
  ForecastPageView({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ForecastPageViewState();
}

class _ForecastPageViewState extends State<ForecastPageView>
    with TickerProviderStateMixin {
  PageController _pageController;
  Animation _refreshAnimation;
  AnimationController _refreshAnimationController;
  ValueNotifier<int> _currentForecastNotifier;

  @override
  void initState() {
    super.initState();

    int selectedForecastIndex =
        context.read<AppBloc>().state.selectedForecastIndex;

    _pageController = PageController(initialPage: selectedForecastIndex);
    _currentForecastNotifier = ValueNotifier<int>(selectedForecastIndex);

    _refreshAnimationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    _refreshAnimation =
        Tween(begin: 0.0, end: pi + pi).animate(_refreshAnimationController);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _refreshAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) =>
      BlocListener<AppBloc, AppState>(
        listener: (
          BuildContext context,
          AppState state,
        ) {
          if (state.refreshStatus == RefreshStatus.REFRESHING) {
            _refreshAnimationController
              ..reset()
              ..forward();
          }

          _currentForecastNotifier.value = state.selectedForecastIndex;
        },
        child: AppUiOverlayStyle(
          bloc: context.watch<AppBloc>(),
          child: BlocBuilder<AppBloc, AppState>(
            builder: (
              BuildContext context,
              AppState state,
            ) =>
                WillPopScope(
              onWillPop: () => _willPopCallback(state),
              child: Scaffold(
                extendBody: true,
                body: SafeArea(
                  child: _buildBody(state),
                ),
                floatingActionButton: FloatingActionButton(
                  tooltip: AppLocalizations.of(context).addLocation,
                  onPressed: _tapAddLocation,
                  child: Icon(Icons.add),
                  mini: true,
                ),
              ),
            ),
          ),
        ),
      );

  Future<bool> _willPopCallback(
    AppState state,
  ) async {
    setState(() {
      if (state.selectedForecastIndex == 0) {
        // Exits the app
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      } else {
        // Go back to the first forecast
        _pageController.animateToPage(
          0,
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
        );

        context.read<AppBloc>().add(SelectedForecastIndex(0));
      }
    });

    return Future.value(false);
  }

  Widget _buildBody(
    AppState state,
  ) =>
      Column(
        children: <Widget>[
          _buildOptions(state),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (int page) => _onPageChanged(page, state),
              itemCount: (state.forecasts == null) ? 0 : state.forecasts.length,
              itemBuilder: (
                BuildContext context,
                int position,
              ) {
                if (position == state.forecasts.length) {
                  return null;
                }

                if (_canRefresh(state)) {
                  return RefreshIndicator(
                    onRefresh: () => _pullRefresh(state),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: ForecastDisplay(
                        bloc: context.read<AppBloc>(),
                        forecast: state.forecasts[position],
                      ),
                    ),
                  );
                }

                return ForecastDisplay(
                  bloc: context.read<AppBloc>(),
                  forecast: state.forecasts[position],
                );
              },
            ),
          ),
          _buildCircleIndicator(state),
        ],
      );

  _buildCircleIndicator(
    AppState state,
  ) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: CirclePageIndicator(
          dotColor: AppTheme.getSecondaryColor(state.themeMode),
          selectedDotColor: Colors.deepPurple[400],
          selectedSize: 10.0,
          itemCount: (state.forecasts == null) ? 0 : state.forecasts.length,
          currentPageNotifier: _currentForecastNotifier,
        ),
      );

  Widget _buildOptions(
    AppState state,
  ) =>
      Container(
        padding: const EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          top: 20.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _buildEditButton(state),
            _buildRefreshButton(state),
            Expanded(child: Container()),
            AppDayNightSwitch(bloc: context.read<AppBloc>()),
            _buildSettingsButton(),
          ],
        ),
      );

  Widget _buildEditButton(
    AppState state,
  ) =>
      (state.forecasts?.length == 0)
          ? Container()
          : Tooltip(
              message: AppLocalizations.of(context).editLocation,
              child: Material(
                type: MaterialType.transparency,
                child: Container(
                  height: 40.0,
                  width: 40.0,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(40.0),
                    child: Icon(Icons.edit),
                    onTap: _tapEdit,
                  ),
                ),
              ),
            );

  Widget _buildRefreshButton(
    AppState state,
  ) =>
      (!_canRefresh(state) || state.forecasts?.length == 0)
          ? Container()
          : Tooltip(
              message: AppLocalizations.of(context).refreshForecast,
              child: Material(
                type: MaterialType.transparency,
                child: Container(
                  height: 40.0,
                  width: 40.0,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(40.0),
                    child: AnimatedBuilder(
                      animation: _refreshAnimationController,
                      builder: (BuildContext context, Widget child) =>
                          Transform.rotate(
                        angle: _refreshAnimation.value,
                        child: child,
                      ),
                      child: Icon(Icons.refresh),
                    ),
                    onTap: () => _tapRefresh(state),
                  ),
                ),
              ),
            );

  Widget _buildSettingsButton() => Container(
        padding: EdgeInsets.only(left: 10.0),
        child: Tooltip(
          message: AppLocalizations.of(context).settings,
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              height: 40.0,
              width: 40.0,
              child: InkWell(
                borderRadius: BorderRadius.circular(40.0),
                child: Icon(Icons.settings),
                onTap: _tapSettings,
              ),
            ),
          ),
        ),
      );

  void _onPageChanged(
    int page,
    AppState state,
  ) {
    setState(() {
      context.read<AppBloc>().add(SelectedForecastIndex(page));

      if (_canRefresh(state)) {
        _tapRefresh(state);
      }
    });
  }

  bool _canRefresh(
    AppState state,
  ) {
    Forecast selectedForecast = state.forecasts[state.selectedForecastIndex];
    return (selectedForecast == null) ||
        (selectedForecast.lastUpdated == null) ||
        selectedForecast.lastUpdated
            .add(Duration(minutes: EnvConfig.REFRESH_TIMEOUT_MINS))
            .isBefore(getNow());
  }

  Future<void> _pullRefresh(
    AppState state,
  ) async =>
      _tapRefresh(state);

  void _tapEdit() => Navigator.push(context, SettingsView.route());
  void _tapRefresh(
    AppState state,
  ) =>
      context.read<AppBloc>().add(RefreshForecast(
            state.forecasts[state.selectedForecastIndex],
            context.read<AppBloc>().state.temperatureUnit,
          ));

  void _tapSettings() => Navigator.push(context, SettingsView.route());
  void _tapAddLocation() => Navigator.push(context, LookupView.route());
}
