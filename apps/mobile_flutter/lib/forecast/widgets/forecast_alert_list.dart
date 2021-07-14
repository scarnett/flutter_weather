import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/app/app_localization.dart';
import 'package:flutter_weather/app/app_theme.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';
import 'package:flutter_weather/app/utils/utils.dart';
import 'package:flutter_weather/forecast/forecast.dart';
import 'package:flutter_weather/models/models.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class ForecastAlertList extends StatefulWidget {
  final Forecast forecast;

  ForecastAlertList({
    Key? key,
    required this.forecast,
  }) : super(key: key);

  @override
  _ForecastAlertListState createState() => _ForecastAlertListState();
}

class _ForecastAlertListState extends State<ForecastAlertList> {
  late PageController _pageController;
  late ValueNotifier<int> _alertsNotifier;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0)
      ..addListener(() {
        num? currentPage = _pageController.page;
        if (isInteger(currentPage)) {
          _alertsNotifier.value = currentPage!.toInt();
        }
      });

    _alertsNotifier = ValueNotifier<int>(0);
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
      Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                AppLocalizations.of(context)!.alerts,
                style: Theme.of(context).textTheme.headline4!.copyWith(
                      shadows: (context.read<AppBloc>().state.themeMode ==
                              ThemeMode.dark)
                          ? commonTextShadow()
                          : null,
                    ),
              ),
            ),
            Container(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 300.0,
                ),
                child: PageView.builder(
                  controller: _pageController,
                  physics: const ClampingScrollPhysics(),
                  itemCount: widget.forecast.details?.alerts?.length ?? 0,
                  itemBuilder: (
                    BuildContext context,
                    int position,
                  ) =>
                      SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Container(
                      child: ForecastAlertDescription(
                        description: widget
                            .forecast.details!.alerts![position].description,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            _buildAlertsCircleIndicator(
              alerts: widget.forecast.details!.alerts!,
            ),
          ],
        ),
      );

  Widget _buildAlertsCircleIndicator({
    required List<ForecastAlert> alerts,
  }) {
    AppState state = context.read<AppBloc>().state;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: CirclePageIndicator(
          size: 4.0,
          dotColor: AppTheme.getBorderColor(
            state.themeMode,
            colorTheme: state.colorTheme,
          ),
          selectedDotColor:
              state.colorTheme ? Colors.white : AppTheme.primaryColor,
          selectedSize: 6.0,
          itemCount: alerts.length,
          currentPageNotifier: _alertsNotifier,
          onPageSelected: (int page) async => await _onPageSelected(page),
        ),
      ),
    );
  }

  Future<void> _onPageSelected(
    int page,
  ) async {
    _alertsNotifier.value = page;
    await animatePage(_pageController, page: page);
  }
}
