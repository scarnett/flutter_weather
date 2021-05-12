import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/app_keys.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/enums.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/theme.dart';
import 'package:flutter_weather/utils/color_utils.dart';
import 'package:flutter_weather/utils/common_utils.dart';
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

class _ForecastPageViewState extends State<ForecastView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  PageController? _pageController;
  Animatable<Color?>? _pageBackground;
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
    _pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) =>
      Scaffold(
        key: _scaffoldKey,
        extendBody: true,
        body: BlocListener<AppBloc, AppState>(
          listener: _blocListener,
          child: WillPopScope(
            onWillPop: () => _willPopCallback(context.read<AppBloc>().state),
            child: _buildBody(context.watch<AppBloc>().state),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          key: Key(AppKeys.addLocationKey),
          tooltip: AppLocalizations.of(context)!.addForecast,
          onPressed: _tapAddLocation,
          child: Icon(Icons.add),
          mini: true,
        ),
      );

  void _initialize() {
    AppState state = context.read<AppBloc>().state;
    _colorTheme = state.colorTheme;
    _pageController = PageController(
      initialPage: state.selectedForecastIndex,
      keepPage: true,
    )..addListener(() {
        _currentPage = _pageController!.page;

        if (isInteger(_currentPage)) {
          _currentForecastNotifier.value = _currentPage!.toInt();

          context
              .read<AppBloc>()
              .add(SelectedForecastIndex(_currentForecastNotifier.value));

          // If auto update is enabled then run the refresh
          Forecast forecast = state.forecasts[_currentForecastNotifier.value];
          DateTime? lastUpdated = forecast.lastUpdated;
          if ((lastUpdated == null) ||
              DateTime.now().isAfter(lastUpdated.add(Duration(
                  minutes: state.updatePeriod?.getInfo()!['minutes'])))) {
            context.read<AppBloc>().add(
                  RefreshForecast(
                    context,
                    state.forecasts[state.selectedForecastIndex],
                    state.temperatureUnit,
                  ),
                );
          }
        }
      });

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
      _pageController!.jumpToPage(0);
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

  Widget _buildContent(
    AppState state,
  ) =>
      Column(
        children: <Widget>[
          ForecastOptions(),
          Expanded(
            child: hasForecasts(state.forecasts)
                ? Stack(
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        physics: const AppPageViewScrollPhysics(),
                        itemCount: state.forecasts.length,
                        itemBuilder: (BuildContext context, int position) =>
                            _buildForecastItem(context, position, state),
                      ),
                      _buildCircleIndicator(state),
                    ],
                  )
                : AppNoneFound(text: AppLocalizations.of(context)!.noForecasts),
          ),
        ],
      );

  Widget _buildForecastColorContent(
    AppState state,
  ) =>
      AnimatedBuilder(
        animation: _pageController!,
        builder: (BuildContext context, Widget? child) {
          num? currentPage = _currentPage;
          if (isInteger(currentPage)) {
            if (state.selectedForecastIndex != currentPage!.toInt()) {
              currentPage = state.selectedForecastIndex.toDouble();
            }
          }

          final double _forecastColorValue =
              (_pageController!.hasClients && state.forecasts.isNotEmpty)
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
                ),
              ),
              child: SafeArea(child: _buildContent(state)),
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
        child: SafeArea(child: _buildContent(state)),
      );

  _buildForecastItem(
    BuildContext context,
    int position,
    AppState state,
  ) {
    if (position == state.forecasts.length) {
      return null;
    }

    if (canRefresh(state, index: state.selectedForecastIndex)) {
      return RefreshIndicator(
        color: AppTheme.primaryColor,
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
  }

  _buildCircleIndicator(
    AppState state,
  ) {
    if (state.forecasts.isEmpty || (state.forecasts.length <= 1)) {
      return Container();
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
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

  void _onPageSelected(
    int page,
  ) {
    _currentForecastNotifier.value = page;
    animatePage(_pageController!, page: page);
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
