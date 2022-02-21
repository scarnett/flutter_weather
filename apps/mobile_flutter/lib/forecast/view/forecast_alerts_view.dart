import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/app/app_localization.dart';
import 'package:flutter_weather/app/app_theme.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';
import 'package:flutter_weather/app/utils/utils.dart';
import 'package:flutter_weather/app/widgets/widgets.dart';
import 'package:flutter_weather/forecast/forecast.dart';
import 'package:flutter_weather/models/models.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class ForecastAlertsViewArguments {
  final int initialIndex;

  ForecastAlertsViewArguments({
    this.initialIndex: 0,
  });
}

class ForecastAlertsView extends StatefulWidget {
  static Route route({
    required ForecastAlertsViewArguments arguments,
  }) =>
      PageRouteBuilder(
        settings: RouteSettings(
          arguments: arguments,
        ),
        pageBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) =>
            ForecastAlertsView(),
        opaque: false,
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) {
          Animatable<Offset> tween = Tween(
            begin: Offset(0.0, 1.0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.fastOutSlowIn));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );

  ForecastAlertsView({
    Key? key,
  }) : super(key: key);

  @override
  _ForecastAlertsViewState createState() => _ForecastAlertsViewState();
}

class _ForecastAlertsViewState extends State<ForecastAlertsView> {
  late final Forecast _forecast;
  late PageController _pageController;
  late ValueNotifier<int> _alertsNotifier;
  late ForecastAlertsViewArguments _arguments;

  int _currentPage = 0;

  @override
  void initState() {
    AppState state = context.read<AppBloc>().state;
    _forecast = state.forecasts[state.selectedForecastIndex];

    _pageController = PageController(initialPage: 0)
      ..addListener(() {
        num? currentPage = _pageController.page;
        if (isInteger(currentPage)) {
          setState(() {
            _currentPage = currentPage!.toInt();
            _alertsNotifier.value = _currentPage;
          });
        }
      });

    _alertsNotifier = ValueNotifier<int>(0);

    WidgetsBinding.instance!.addPostFrameCallback((Duration duration) {
      _arguments = ModalRoute.of(context)!.settings.arguments
          as ForecastAlertsViewArguments;

      if (_arguments.initialIndex > 0) {
        setState(() {
          _currentPage = _arguments.initialIndex;
          _alertsNotifier.value = _currentPage;
        });

        animatePage(_pageController, page: _arguments.initialIndex);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _alertsNotifier.dispose();
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
            title: Text(
              _forecast.details?.alerts?[_currentPage].event ?? 'N/A',
            ),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          backgroundColor:
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.975),
          body: AppUiSafeArea(
            top: false,
            bottom: false,
            child: _buildContent(),
          ),
          extendBody: true,
          extendBodyBehindAppBar: true,
        ),
      );

  Widget _buildContent() => Expanded(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    physics: const AppPageViewScrollPhysics(),
                    itemCount: _forecast.details?.alerts?.length ?? 0,
                    itemBuilder: (
                      BuildContext context,
                      int position,
                    ) =>
                        SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Container(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom,
                          top: MediaQuery.of(context).padding.top,
                        ),
                        child: Column(
                          children: [
                            ForecastAlertDescription(
                              description: _forecast
                                  .details!.alerts![position].description,
                            ),
                            AppSectionHeader(
                              text: AppLocalizations.of(context)!
                                  .meta
                                  .toUpperCase(),
                            ),
                            _buildMeta(
                              AppLocalizations.of(context)!.sender,
                              _forecast
                                  .details?.alerts?[_currentPage].senderName,
                            ),
                            ForecastDivider(padding: const EdgeInsets.all(0.0)),
                            _buildMeta(
                              AppLocalizations.of(context)!.start,
                              formatEpoch(
                                epoch: _forecast
                                        .details?.alerts?[_currentPage].start!
                                        .toInt() ??
                                    0,
                              ),
                            ),
                            ForecastDivider(padding: const EdgeInsets.all(0.0)),
                            _buildMeta(
                              AppLocalizations.of(context)!.end,
                              formatEpoch(
                                epoch: _forecast
                                        .details?.alerts?[_currentPage].end!
                                        .toInt() ??
                                    0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom),
                    child: _buildAlertsCircleIndicator(
                      alerts: _forecast.details!.alerts!,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _buildAlertsCircleIndicator({
    required List<ForecastAlert> alerts,
  }) =>
      Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: CirclePageIndicator(
            size: 4.0,
            dotColor: AppTheme.getBorderColor(
              context.read<AppBloc>().state.themeMode,
              colorTheme: context.read<AppBloc>().state.colorTheme,
            ),
            selectedDotColor: context.read<AppBloc>().state.colorTheme
                ? Colors.white
                : AppTheme.primaryColor,
            selectedSize: 6.0,
            itemCount: alerts.length,
            currentPageNotifier: _alertsNotifier,
            onPageSelected: (int page) async => await _onPageSelected(page),
          ),
        ),
      );

  Widget _buildMeta(
    String label,
    String? text, {
    String defaultText: 'N/A',
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Text(
              text ?? defaultText,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
      );

  Future<void> _onPageSelected(
    int page,
  ) async {
    setState(() {
      _currentPage = page;
      _alertsNotifier.value = _currentPage;
    });

    await animatePage(_pageController, page: page);
  }
}
