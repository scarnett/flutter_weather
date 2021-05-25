import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/app_keys.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/enums.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/theme.dart';
import 'package:flutter_weather/utils/color_utils.dart';
import 'package:flutter_weather/utils/common_utils.dart';
import 'package:flutter_weather/utils/date_utils.dart';
import 'package:flutter_weather/utils/snackbar_utils.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/forecast_utils.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_display.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_options.dart';
import 'package:flutter_weather/views/lookup/lookup_view.dart';
import 'package:flutter_weather/views/settings/settings_enums.dart';
import 'package:flutter_weather/widgets/app_none_found.dart';
import 'package:flutter_weather/widgets/app_pageview_scroll_physics.dart';
import 'package:flutter_weather/widgets/app_ui_overlay_style.dart';
import 'package:flutter_weather/widgets/app_ui_safe_area.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class ForecastView extends StatefulWidget {
  static Route route() =>
      MaterialPageRoute<void>(builder: (_) => ForecastView());

  ForecastView({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ForecastPageViewState();
}

class _ForecastPageViewState extends State<ForecastView>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late PageController _pageController;
  Animatable<Color?>? _pageBackground;
  late AnimationController _hideFabAnimationController;
  late ValueNotifier<int> _currentForecastNotifier;
  num? _currentPage = 0;
  bool? _colorTheme = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    context.read<AppBloc>().add(SetScrollDirection(ScrollDirection.idle));
    _pageController.dispose();
    _hideFabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) =>
      Scaffold(
        key: _scaffoldKey,
        body: BlocListener<AppBloc, AppState>(
          listener: _blocListener,
          child: WillPopScope(
            onWillPop: () => _willPopCallback(context.read<AppBloc>().state),
            child: _buildBody(context.watch<AppBloc>().state),
          ),
        ),
        extendBody: true,
        extendBodyBehindAppBar: true,
        floatingActionButton: FadeTransition(
          opacity: _hideFabAnimationController,
          child: ScaleTransition(
            scale: _hideFabAnimationController,
            child: FloatingActionButton(
              key: Key(AppKeys.addLocationKey),
              tooltip: AppLocalizations.of(context)!.addForecast,
              onPressed: _tapAddLocation,
              child: Icon(Icons.add),
              mini: true,
            ),
          ),
        ),
      );

  void _initialize() {
    AppState state = context.read<AppBloc>().state;
    _colorTheme = state.colorTheme;
    _pageController = PageController(
      initialPage: state.selectedForecastIndex,
      keepPage: true,
    )..addListener(() {
        _currentPage = _pageController.page;

        if (isInteger(_currentPage)) {
          _currentForecastNotifier.value = _currentPage!.toInt();

          context.read<AppBloc>()
            ..add(SelectedForecastIndex(_currentForecastNotifier.value))
            ..add(SetScrollDirection(ScrollDirection.idle));

          // If auto update is enabled then run the refresh
          if ((state.updatePeriod != null) &&
              state.forecasts.isNotEmpty &&
              (state.forecasts.length >= _currentForecastNotifier.value + 1)) {
            Forecast forecast = state.forecasts[_currentForecastNotifier.value];
            DateTime? lastUpdated = forecast.lastUpdated;
            if ((lastUpdated == null) ||
                DateTime.now().isAfter(lastUpdated.add(Duration(
                    minutes: state.updatePeriod?.getInfo()!['minutes'])))) {
              context.read<AppBloc>().add(
                    RefreshForecast(
                      context,
                      state.forecasts[_currentForecastNotifier.value],
                      state.temperatureUnit,
                    ),
                  );
            }
          }
        }
      });

    _hideFabAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
      value: 1.0,
    );

    if (state.colorTheme) {
      _pageBackground = buildForecastColorSequence(state.forecasts);
    }

    _currentForecastNotifier = ValueNotifier<int>(state.selectedForecastIndex);
  }

  void _blocListener(
    BuildContext context,
    AppState state,
  ) {
    if (state.crudStatus != null) {
      AppLocalizations? i18n = AppLocalizations.of(context);

      switch (state.crudStatus) {
        case CRUDStatus.CREATED:
          showSnackbar(context, i18n!.forecastAdded);
          break;

        case CRUDStatus.UPDATED:
          showSnackbar(context, i18n!.forecastUpdated);
          break;

        case CRUDStatus.DELETED:
          showSnackbar(context, i18n!.forecastDeleted);
          break;

        default:
          break;
      }

      context.read<AppBloc>().add(ClearCRUDStatus());
    }

    if (state.scrollDirection != null) {
      switch (state.scrollDirection!) {
        case ScrollDirection.reverse:
          _hideFabAnimationController.reverse();
          break;

        case ScrollDirection.forward:
        case ScrollDirection.idle:
          _hideFabAnimationController.forward();
          break;
      }
    }

    if (state.colorTheme) {
      _pageBackground = buildForecastColorSequence(state.forecasts);
    }

    if (_colorTheme != state.colorTheme) {
      _initialize();
    }
  }

  Future<bool> _willPopCallback(
    AppState state,
  ) async {
    if (state.selectedForecastIndex == 0) {
      // Exits the app
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    } else {
      // Go back to the first forecast
      _pageController.jumpToPage(0);
      context.read<AppBloc>().add(SelectedForecastIndex(0));
    }

    return Future.value(false);
  }

  Widget _buildBody(
    AppState state,
  ) =>
      state.colorTheme
          ? _buildForecastColorContent(state)
          : _buildLightDarkContent(state);

  Widget _buildContent({
    required AppState state,
    Color? forecastColor,
  }) =>
      hasForecasts(state.forecasts)
          ? Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  physics: const AppPageViewScrollPhysics(),
                  itemCount: state.forecasts.length,
                  itemBuilder: (BuildContext context, int position) =>
                      _buildForecastItem(
                    context: context,
                    position: position,
                    state: state,
                    forecastColor: forecastColor,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: FadeTransition(
                    opacity: _hideFabAnimationController,
                    child: ScaleTransition(
                      scale: _hideFabAnimationController,
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildCircleIndicator(
                              state: state,
                              forecastColor: forecastColor,
                            ),
                            _buildLastUpdated(
                              state: state,
                              forecastColor: forecastColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Center(
              child: AppNoneFound(
                text: AppLocalizations.of(context)!.noForecasts,
              ),
            );

  Widget _buildForecastColorContent(
    AppState state,
  ) =>
      AnimatedBuilder(
        animation: _pageController,
        builder: (BuildContext context, Widget? child) {
          num? currentPage = _currentPage;
          if (isInteger(currentPage)) {
            if (state.selectedForecastIndex != currentPage!.toInt()) {
              currentPage = state.selectedForecastIndex.toDouble();
            }
          }

          final double _forecastColorValue =
              (_pageController.hasClients && state.forecasts.isNotEmpty)
                  ? (currentPage! / state.forecasts.length)
                  : (state.selectedForecastIndex.toDouble() /
                      state.forecasts.length);

          Color? _forecastColor = (_pageBackground == null)
              ? Colors.transparent
              : _pageBackground!.evaluate(
                  AlwaysStoppedAnimation(_forecastColorValue),
                );

          Color _forecastDarkenedColor = _forecastColor!.darken(0.25);

          return AppUiOverlayStyle(
            themeMode: state.themeMode,
            colorTheme: state.colorTheme,
            systemNavigationBarColor: _forecastDarkenedColor,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: _forecastColor,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    _forecastColor,
                    _forecastDarkenedColor,
                  ],
                  stops: [0.3, 1.0],
                ),
              ),
              child: AppUiSafeArea(
                bottom: false,
                top: false,
                topWidget: ForecastOptions(),
                child: _buildContent(
                  state: state,
                  forecastColor: _forecastColor,
                ),
              ),
            ),
          );
        },
      );

  _buildLightDarkContent(
    AppState state,
  ) =>
      AppUiOverlayStyle(
        themeMode: state.themeMode,
        colorTheme: state.colorTheme,
        child: AppUiSafeArea(
          bottom: false,
          top: false,
          topWidget: ForecastOptions(),
          child: _buildContent(state: state),
        ),
      );

  _buildForecastItem({
    required BuildContext context,
    required int position,
    required AppState state,
    Color? forecastColor,
  }) {
    if (position == state.forecasts.length) {
      return null;
    }

    if (canRefresh(state, index: state.selectedForecastIndex)) {
      return RefreshIndicator(
        color: AppTheme.primaryColor,
        onRefresh: () => _pullRefresh(state),
        child: ForecastDisplay(
          forecastColor: forecastColor,
          temperatureUnit: state.temperatureUnit,
          themeMode: state.themeMode,
          colorTheme: state.colorTheme,
          forecast: state.forecasts[position],
        ),
      );
    }

    return ForecastDisplay(
      forecastColor: forecastColor,
      temperatureUnit: state.temperatureUnit,
      themeMode: state.themeMode,
      colorTheme: state.colorTheme,
      forecast: state.forecasts[position],
    );
  }

  _buildCircleIndicator({
    required AppState state,
    Color? forecastColor,
  }) {
    if (state.forecasts.isEmpty || (state.forecasts.length <= 1)) {
      return Container();
    }

    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: (forecastColor == null)
              ? Theme.of(context).scaffoldBackgroundColor.withOpacity(0.7)
              : forecastColor.withOpacity(0.2),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        padding: const EdgeInsets.all(4.0),
        margin: const EdgeInsets.only(bottom: 6.0),
        child: CirclePageIndicator(
          dotColor: AppTheme.getHintColor(
            state.themeMode,
          ),
          selectedDotColor:
              state.colorTheme ? Colors.white : AppTheme.primaryColor,
          selectedSize: 10.0,
          itemCount: state.forecasts.length,
          currentPageNotifier: _currentForecastNotifier,
          onPageSelected: _onPageSelected,
        ),
      ),
    );
  }

  Widget _buildLastUpdated({
    required AppState state,
    Color? forecastColor,
  }) {
    DateTime? lastUpdated =
        state.forecasts[state.selectedForecastIndex].lastUpdated;
    if (lastUpdated == null) {
      return Container();
    }

    String formattedLastUpdated;

    if (lastUpdated.isToday()) {
      formattedLastUpdated = AppLocalizations.of(context)!
          .getLastUpdatedAt(formatDateTime(lastUpdated.toLocal(), 'h:mm a')!);
    } else {
      formattedLastUpdated = AppLocalizations.of(context)!.getLastUpdatedOn(
          formatDateTime(lastUpdated.toLocal(), 'EEE, MMM d, yyyy @ h:mm a')!);
    }

    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: (forecastColor == null)
              ? Theme.of(context).scaffoldBackgroundColor.withOpacity(0.7)
              : forecastColor.withOpacity(0.2),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 16),
        child: Text(
          formattedLastUpdated,
          style: Theme.of(context).textTheme.subtitle2,
        ),
      ),
    );
  }

  void _onPageSelected(
    int page,
  ) {
    _currentForecastNotifier.value = page;
    animatePage(_pageController, page: page);
  }

  Future<void> _pullRefresh(
    AppState state,
  ) async =>
      context.read<AppBloc>().add(
            RefreshForecast(
              context,
              state.forecasts[state.selectedForecastIndex],
              state.temperatureUnit,
            ),
          );

  void _tapAddLocation() {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    Navigator.push(context, LookupView.route());
  }
}
