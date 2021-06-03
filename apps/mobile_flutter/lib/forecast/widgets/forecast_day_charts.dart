import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/app/app_localization.dart';
import 'package:flutter_weather/app/app_theme.dart';
import 'package:flutter_weather/app/utils/chart_utils.dart';
import 'package:flutter_weather/app/utils/color_utils.dart';
import 'package:flutter_weather/app/utils/common_utils.dart';
import 'package:flutter_weather/app/utils/math_utils.dart';
import 'package:flutter_weather/app/widgets/app_option_button.dart';
import 'package:flutter_weather/app/widgets/app_pageview_scroll_physics.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/enums/enums.dart';
import 'package:flutter_weather/forecast/forecast.dart';
import 'package:flutter_weather/models/models.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class ForecastDayCharts extends StatefulWidget {
  final Forecast forecast;
  final Color? forecastColor;
  final List<Color>? gradientColors;
  final bool enabled;

  ForecastDayCharts({
    Key? key,
    required this.forecast,
    this.forecastColor,
    this.gradientColors,
    this.enabled: true,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ForecastDayChartsState();
}

class _ForecastDayChartsState extends State<ForecastDayCharts> {
  late PageController _pageController;
  late ValueNotifier<int> _chartTypeNotifier;
  int? _selectedSpot;
  int? _currentPage = 0;

  @override
  void initState() {
    _currentPage = context.read<AppBloc>().state.chartType.index;
    _pageController = PageController(initialPage: _currentPage!, keepPage: true)
      ..addListener(() {
        setState(() {
          if (isInteger(_pageController.page)) {
            _currentPage = _pageController.page!.toInt();
            _chartTypeNotifier.value = _currentPage!.toInt();
            context
                .read<AppBloc>()
                .add(SetChartType(ChartType.values[_currentPage!]));
          }
        });
      });

    _chartTypeNotifier = ValueNotifier<int>(_currentPage!);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _chartTypeNotifier.dispose();
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
        ) async =>
            await _blocListener(context, state),
        child: Column(
          children: [
            _buildOptions(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: widget.enabled
                    ? const AppPageViewScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                clipBehavior: Clip.none,
                children: [
                  _buildLineChart(context),
                  _buildBarChart(),
                ],
              ),
            ),
            _buildCircleIndicator(),
          ],
        ),
      );

  Future<void> _blocListener(
    BuildContext context,
    AppState state,
  ) async {
    if (_chartTypeNotifier.value != state.chartType.index) {
      setState(() async {
        _currentPage = state.chartType.index;
        _chartTypeNotifier.value = state.chartType.index;
        await animatePage(_pageController, page: state.chartType.index);
      });
    }
  }

  Widget _buildOptions() => Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: AppOptionButton(
                text: AppLocalizations.of(context)!.chartLine.toUpperCase(),
                colorThemeColor: widget.forecastColor?.darken(0.15),
                active: (_currentPage == 0),
                onTap: (_currentPage == 0) ? null : () => _tapChartType(0),
              ),
            ),
            AppOptionButton(
              text: AppLocalizations.of(context)!.chartBar.toUpperCase(),
              colorThemeColor: widget.forecastColor?.darken(0.15),
              active: (_currentPage == 1),
              onTap: (_currentPage == 1) ? null : () => _tapChartType(1),
            ),
          ],
        ),
      );

  Widget _buildLineChart(
    BuildContext context,
  ) {
    AppState state = context.read<AppBloc>().state;
    List<LineChartBarData> lineBarsData = getLineBarsData(state);

    return Container(
      padding: const EdgeInsets.only(left: 10.0),
      child: LineChart(
        LineChartData(
          minX: 0.0,
          maxX: (_getDays().length.toDouble() - 1.0),
          minY: round5(
            number: getTemperature(
              widget.forecast.getDayLowMin().temp!.min!.toDouble(),
              state.units.temperature,
            ).toDouble(),
            offset: -5.0,
          ),
          maxY: round5(
            number: getTemperature(
              widget.forecast.getDayHighMax().temp!.max!.toDouble(),
              state.units.temperature,
            ).toDouble(),
          ),
          gridData: FlGridData(
            show: true,
            horizontalInterval: 1.0,
            drawHorizontalLine: true,
            getDrawingHorizontalLine: (double value) {
              if ((value % 5) == 0) {
                return FlLine(
                  color: getGridBorderColor(
                    themeMode: state.themeMode,
                    colorTheme: state.colorTheme,
                  ),
                  strokeWidth: 1.0,
                );
              }

              return FlLine(color: Colors.transparent);
            },
            drawVerticalLine: true,
            getDrawingVerticalLine: (double value) => FlLine(
              color: getGridBorderColor(
                themeMode: state.themeMode,
                colorTheme: state.colorTheme,
              ),
              strokeWidth: 1.0,
            ),
          ),
          showingTooltipIndicators: (_selectedSpot == null)
              ? null
              : [
                  ShowingTooltipIndicators([
                    LineBarSpot(
                      lineBarsData[0],
                      lineBarsData.indexOf(lineBarsData[0]),
                      lineBarsData[0].spots[_selectedSpot!],
                    ),
                  ]),
                ],
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: buildBottomSideTitles(
              context: context,
              title: (double value) => getDayTitle(widget.forecast, value),
            ),
            leftTitles: buildLeftSideTitles(
              context: context,
              temperatureUnit: state.units.temperature,
            ),
            rightTitles: buildEmptySideTitles(),
            topTitles: buildEmptySideTitles(),
          ),
          borderData: getBorderData(
            themeMode: state.themeMode,
            colorTheme: state.colorTheme,
          ),
          lineBarsData: lineBarsData,
          lineTouchData: getLineTouchData(
            context: context,
            temperatureUnit: state.units.temperature,
            colorTheme: state.colorTheme,
            forecastColor: widget.forecastColor,
            enabled: widget.enabled,
            callback: (int index) => setState(() {
              if (_selectedSpot == index) {
                _selectedSpot = null;
              } else {
                _selectedSpot = index;
              }
            }),
          ),
        ),
      ),
    );
  }

  List<LineChartBarData> getLineBarsData(
    AppState state,
  ) =>
      [
        getLineData(
          spots: _getTempMaxSpots(),
          colors: widget.gradientColors ?? getLineColors(state.colorTheme),
          colorTheme: state.colorTheme,
          forecastColor: widget.forecastColor,
        ),
        getLineData(
          opacity: 0.5,
          spots: _getTempMinSpots(),
          colors: widget.gradientColors ??
              getLineColors(
                state.colorTheme,
                opacity: 0.5,
              ),
          colorTheme: state.colorTheme,
          forecastColor: widget.forecastColor,
        ),
      ];

  Widget _buildBarChart() {
    AppState state = context.read<AppBloc>().state;
    return Container(
      padding: const EdgeInsets.only(left: 10.0),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.center,
          minY: round5(
            number: getTemperature(
              widget.forecast.getDayLowMin().temp!.min!.toDouble(),
              state.units.temperature,
            ).toDouble(),
            offset: -5.0,
          ),
          maxY: round5(
            number: getTemperature(
              widget.forecast.getDayHighMax().temp!.max!.toDouble(),
              state.units.temperature,
            ).toDouble(),
          ),
          gridData: FlGridData(
            show: true,
            horizontalInterval: 1.0,
            drawHorizontalLine: true,
            getDrawingHorizontalLine: (double value) {
              if ((value % 5) == 0) {
                return FlLine(
                  color: getGridBorderColor(
                    themeMode: state.themeMode,
                    colorTheme: state.colorTheme,
                  ),
                  strokeWidth: 1.0,
                );
              }

              return FlLine(color: Colors.transparent);
            },
          ),
          groupsSpace: 15.0,
          barGroups: getBarGroups(state),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: buildBottomSideTitles(
              context: context,
              title: (double value) => getDayTitle(widget.forecast, value),
            ),
            leftTitles: buildLeftSideTitles(
              context: context,
              temperatureUnit: state.units.temperature,
            ),
            rightTitles: buildEmptySideTitles(),
            topTitles: buildEmptySideTitles(),
          ),
          borderData: getBorderData(
            themeMode: state.themeMode,
            colorTheme: state.colorTheme,
          ),
          barTouchData: getBarTouchData(
            context: context,
            temperatureUnit: state.units.temperature,
            colorTheme: state.colorTheme,
            enabled: widget.enabled,
          ),
        ),
      ),
    );
  }

  Widget _buildCircleIndicator() {
    AppState state = context.read<AppBloc>().state;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: CirclePageIndicator(
          size: 4.0,
          dotColor: AppTheme.getBorderColor(
            state.themeMode,
            colorTheme: state.colorTheme,
          ),
          selectedDotColor:
              state.colorTheme ? Colors.white : AppTheme.primaryColor,
          selectedSize: 6.0,
          itemCount: ChartType.values.length,
          currentPageNotifier: _chartTypeNotifier,
          onPageSelected: (int page) async => await _tapChartType(page),
        ),
      ),
    );
  }

  List<BarChartGroupData> getBarGroups(
    AppState state,
  ) {
    List<BarChartGroupData> rodData = <BarChartGroupData>[];
    int count = 0;

    for (ForecastDaily day in _getDays()) {
      double tempMax = getTemperature(
        day.temp!.max!.toDouble(),
        state.units.temperature,
      ).toDouble();

      double tempMin = getTemperature(
        day.temp!.min!.toDouble(),
        state.units.temperature,
      ).toDouble();

      rodData.add(
        BarChartGroupData(
          x: count,
          barsSpace: 5.0,
          barRods: [
            BarChartRodData(
              y: tempMax,
              width: 10.0,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
              colors: widget.gradientColors ?? getLineColors(state.colorTheme),
            ),
            BarChartRodData(
              y: tempMin,
              width: 10.0,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
              colors: widget.gradientColors ??
                  getLineColors(
                    state.colorTheme,
                    opacity: 0.5,
                  ),
            ),
          ],
        ),
      );

      count++;
    }

    return rodData;
  }

  List<ForecastDaily> _getDays({
    int count: 8, // TODO! premium
  }) {
    if (widget.forecast.details!.daily == null) {
      return [];
    } else if (widget.forecast.details!.daily!.length < count) {
      return widget.forecast.details!.daily!;
    }

    return widget.forecast.details!.daily!.sublist(0, (count - 1));
  }

  List<FlSpot> _getTempMaxSpots() {
    int index = 0;
    List<FlSpot> spots = [];
    TemperatureUnit temperatureUnit =
        context.read<AppBloc>().state.units.temperature;

    for (ForecastDaily day in _getDays()) {
      spots.add(
        FlSpot(
          index.toDouble(),
          getTemperature(day.temp!.max!.toDouble(), temperatureUnit).toDouble(),
        ),
      );

      index++;
    }

    return spots;
  }

  List<FlSpot> _getTempMinSpots() {
    int index = 0;
    List<FlSpot> spots = [];
    TemperatureUnit temperatureUnit =
        context.read<AppBloc>().state.units.temperature;

    for (ForecastDaily day in _getDays()) {
      spots.add(
        FlSpot(
          index.toDouble(),
          getTemperature(day.temp!.min!.toDouble(), temperatureUnit).toDouble(),
        ),
      );

      index++;
    }

    return spots;
  }

  Future<void> _tapChartType(
    int page,
  ) async {
    if (widget.enabled) {
      _chartTypeNotifier.value = page;
      await animatePage(_pageController, page: page);
    }
  }
}
