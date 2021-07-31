import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/app/app_localization.dart';
import 'package:flutter_weather/app/app_theme.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';
import 'package:flutter_weather/app/utils/utils.dart';
import 'package:flutter_weather/app/widgets/widgets.dart';
import 'package:flutter_weather/enums/enums.dart';
import 'package:flutter_weather/forecast/forecast.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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
    with TickerProviderStateMixin {
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
    // context.read<AppBloc>().add(SetScrollDirection(ScrollDirection.idle));
    _pageController.dispose();
    _hideFabAnimationController.dispose();
    _currentForecastNotifier.dispose();
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
        floatingActionButtonLocation: AppFABLocation(
          location: FloatingActionButtonLocation.miniEndFloat,
          offsetX: 6.0,
          offsetY: 0.0,
        ),
        floatingActionButton: AppFAB(
          animationController: _hideFabAnimationController,
        ),
        floatingActionButtonAnimator: AppFABNoScalingAnimation(),
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
            ..add(SetScrollDirection(ScrollDirection.forward))
            ..add(AutoUpdateForecast(context, _currentForecastNotifier.value));
        }
      });

    _hideFabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      value: 1.0,
    );

    if (state.colorTheme) {
      _pageBackground = buildForecastColorSequence(state.forecasts);
    }

    _currentForecastNotifier = ValueNotifier<int>(state.selectedForecastIndex);

    context.read<AppBloc>()
      ..add(AutoUpdateForecast(context, _currentForecastNotifier.value));
  }

  void _blocListener(
    BuildContext context,
    AppState state,
  ) {
    if (state.crudStatus != null) {
      AppLocalizations? i18n = AppLocalizations.of(context);

      switch (state.crudStatus) {
        case CRUDStatus.created:
          _showSnackbar(state: state, message: i18n!.forecastAdded);
          break;

        case CRUDStatus.updated:
          _showSnackbar(state: state, message: i18n!.forecastUpdated);
          break;

        case CRUDStatus.deleted:
          _showSnackbar(state: state, message: i18n!.forecastDeleted);
          break;

        default:
          break;
      }

      context.read<AppBloc>().add(ClearCRUDStatus());
    }

    switch (state.scrollDirection ?? null) {
      case ScrollDirection.reverse:
        if (_hideFabAnimationController.isCompleted) {
          _hideFabAnimationController.reverse();
        }

        break;

      case ScrollDirection.forward:
        if (_hideFabAnimationController.isDismissed) {
          _hideFabAnimationController.forward();
        }

        break;

      default:
        break;
    }

    if (state.colorTheme) {
      _pageBackground = buildForecastColorSequence(state.forecasts);
    }

    if (_colorTheme != state.colorTheme) {
      _initialize();
    }

    if (state.isPremium && state.showPremiumSuccess) {
      Alert(
        context: context,
        image: Image.asset(
          'assets/images/logo.png',
          height: 150.0,
        ),
        title: 'Congratulations!', // TODO! i18n
        content: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
                right: 8.0,
                left: 8.0,
                bottom: 20.0,
              ),
              child: Text(
                'Well done, you now have full access to the app', // TODO! i18n
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            radius: BorderRadius.circular(10.0),
            child: Text(
              'COOL', // TODO! i18n
            ),
            onPressed: () {
              context.read<AppBloc>().add(SetShowPremiumSuccess(false));
              Navigator.of(context).pop();
            },
          ),
        ],
      ).show();
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
    Color? forecastDarkenedColor,
  }) =>
      hasForecasts(state.forecasts)
          ? Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  physics: const AppPageViewScrollPhysics(),
                  itemCount: state.forecasts.length,
                  itemBuilder: (
                    BuildContext context,
                    int position,
                  ) =>
                      _buildForecastItem(
                        context: context,
                        position: position,
                        state: state,
                        forecastColor: forecastColor,
                        forecastDarkenedColor: forecastDarkenedColor,
                      ) ??
                      Container(),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: FadeTransition(
                    opacity: _hideFabAnimationController,
                    child: ScaleTransition(
                      alignment: Alignment.center,
                      scale: _hideFabAnimationController,
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildCircleIndicator(
                              state: state,
                              forecastColor: forecastColor,
                            ),
                            ForecastLastUpdated(
                              forecast:
                                  state.forecasts[state.selectedForecastIndex],
                              fillColor: forecastColor,
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

          Color _forecastDarkenedColor = state.showPremiumInfo
              ? _forecastColor!
              : _forecastColor!.darken(40);

          return AppUiOverlayStyle(
            systemNavigationBarColorOpacity:
                state.showPremiumInfo ? 0.01 : 0.925,
            systemNavigationBarColor:
                state.showPremiumInfo ? Colors.black : _forecastDarkenedColor,
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
                  forecastDarkenedColor: _forecastDarkenedColor,
                ),
              ),
            ),
          );
        },
      );

  Widget _buildLightDarkContent(
    AppState state,
  ) =>
      AppUiOverlayStyle(
        child: AppUiSafeArea(
          bottom: false,
          top: false,
          topWidget: ForecastOptions(),
          child: _buildContent(state: state),
        ),
      );

  Widget? _buildForecastItem({
    required BuildContext context,
    required int position,
    required AppState state,
    Color? forecastColor,
    Color? forecastDarkenedColor,
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
          forecastDarkenedColor: forecastDarkenedColor,
          forecast: sortForecasts(state.forecasts)[position],
        ),
      );
    }

    return ForecastDisplay(
      forecastColor: forecastColor,
      forecastDarkenedColor: forecastDarkenedColor,
      forecast: sortForecasts(state.forecasts)[position],
    );
  }

  Widget _buildCircleIndicator({
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
              ? Colors.black.withOpacity(0.1)
              : forecastColor.withOpacity(0.2),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        padding: const EdgeInsets.all(4.0),
        margin: const EdgeInsets.only(bottom: 6.0),
        child: CirclePageIndicator(
          dotColor: AppTheme.getBorderColor(
            state.themeMode,
            colorTheme: state.colorTheme,
          ),
          selectedDotColor:
              state.colorTheme ? Colors.white : AppTheme.primaryColor,
          selectedSize: 10.0,
          itemCount: state.forecasts.length,
          currentPageNotifier: _currentForecastNotifier,
          onPageSelected: (int page) async => await _onPageSelected(page),
        ),
      ),
    );
  }

  Future<void> _onPageSelected(
    int page,
  ) async {
    _currentForecastNotifier.value = page;
    await animatePage(_pageController, page: page);
  }

  Future<void> _pullRefresh(
    AppState state,
  ) async =>
      context.read<AppBloc>().add(
            RefreshForecast(
              context,
              state.forecasts[state.selectedForecastIndex],
              state.units.temperature,
            ),
          );

  _showSnackbar({
    required AppState state,
    required String message,
  }) {
    showSnackbar(
      context,
      message,
      backgroundColor: state.colorTheme
          ? state.forecasts[state.selectedForecastIndex]
              .getTemperatureColor()
              .darken(35)
          : null,
    );
  }
}
