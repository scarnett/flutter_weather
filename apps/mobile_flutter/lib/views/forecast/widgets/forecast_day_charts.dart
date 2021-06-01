import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/enums.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/theme.dart';
import 'package:flutter_weather/utils/chart_utils.dart';
import 'package:flutter_weather/utils/color_utils.dart';
import 'package:flutter_weather/utils/common_utils.dart';
import 'package:flutter_weather/utils/math_utils.dart';
import 'package:flutter_weather/views/forecast/forecast_extension.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/forecast_utils.dart';
import 'package:flutter_weather/widgets/app_option_button.dart';
import 'package:flutter_weather/widgets/app_pageview_scroll_physics.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class ForecastDayCharts extends StatefulWidget {
  final Forecast forecast;
  final TemperatureUnit temperatureUnit;
  final ChartType chartType;
  final ThemeMode themeMode;
  final bool colorTheme;
  final Color? forecastColor;
  final List<Color>? gradientColors;
  final bool enabled;

  ForecastDayCharts({
    Key? key,
    required this.forecast,
    required this.temperatureUnit,
    required this.chartType,
    required this.themeMode,
    this.colorTheme: false,
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
    _currentPage = widget.chartType.index;
    _pageController = PageController(initialPage: _currentPage!, keepPage: true)
      ..addListener(() {
        setState(() {
          if (isInteger(_pageController.page)) {
            _currentPage = _pageController.page!.toInt();
            _chartTypeNotifier.value = _currentPage!.toInt();

            BlocProvider.of<AppBloc>(context, listen: false)
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
      Column(
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
      );

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
                themeMode: widget.themeMode,
                colorTheme: widget.colorTheme,
                colorThemeColor: widget.forecastColor?.darken(0.15),
                active: (_currentPage == 0),
                onTap: (_currentPage == 0) ? null : () => _tapChartType(0),
              ),
            ),
            AppOptionButton(
              text: AppLocalizations.of(context)!.chartBar.toUpperCase(),
              themeMode: widget.themeMode,
              colorTheme: widget.colorTheme,
              colorThemeColor: widget.forecastColor?.darken(0.15),
              active: (_currentPage == 1),
              onTap: (_currentPage == 1) ? null : () => _tapChartType(1),
            ),
          ],
        ),
      );

  Widget _buildLineChart(
    BuildContext context,
  ) =>
      Container(
        padding: const EdgeInsets.only(left: 10.0),
        child: LineChart(
          LineChartData(
            minX: 0.0,
            maxX: (_getDays().length.toDouble() - 1.0),
            minY: round5(
              number: getTemperature(
                widget.forecast.getDayLowMin().temp!.min!.toDouble(),
                widget.temperatureUnit,
              ).toDouble(),
              offset: -5.0,
            ),
            maxY: round5(
              number: getTemperature(
                widget.forecast.getDayHighMax().temp!.max!.toDouble(),
                widget.temperatureUnit,
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
                      themeMode: widget.themeMode,
                      colorTheme: widget.colorTheme,
                    ),
                    strokeWidth: 1.0,
                  );
                }

                return FlLine(color: Colors.transparent);
              },
              drawVerticalLine: true,
              getDrawingVerticalLine: (double value) => FlLine(
                color: getGridBorderColor(
                  themeMode: widget.themeMode,
                  colorTheme: widget.colorTheme,
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
                temperatureUnit: widget.temperatureUnit,
              ),
              rightTitles: buildEmptySideTitles(),
              topTitles: buildEmptySideTitles(),
            ),
            borderData: getBorderData(
              themeMode: widget.themeMode,
              colorTheme: widget.colorTheme,
            ),
            lineBarsData: lineBarsData,
            lineTouchData: getLineTouchData(
              context: context,
              temperatureUnit: widget.temperatureUnit,
              colorTheme: widget.colorTheme,
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

  List<LineChartBarData> get lineBarsData => [
        getLineData(
          spots: _getTempMaxSpots(),
          colors: widget.gradientColors ?? getLineColors(widget.colorTheme),
          colorTheme: widget.colorTheme,
          forecastColor: widget.forecastColor,
        ),
        getLineData(
          opacity: 0.5,
          spots: _getTempMinSpots(),
          colors: widget.gradientColors ??
              getLineColors(
                widget.colorTheme,
                opacity: 0.5,
              ),
          colorTheme: widget.colorTheme,
          forecastColor: widget.forecastColor,
        ),
      ];

  Widget _buildBarChart() => Container(
        padding: const EdgeInsets.only(left: 10.0),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.center,
            minY: round5(
              number: getTemperature(
                widget.forecast.getDayLowMin().temp!.min!.toDouble(),
                widget.temperatureUnit,
              ).toDouble(),
              offset: -5.0,
            ),
            maxY: round5(
              number: getTemperature(
                widget.forecast.getDayHighMax().temp!.max!.toDouble(),
                widget.temperatureUnit,
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
                      themeMode: widget.themeMode,
                      colorTheme: widget.colorTheme,
                    ),
                    strokeWidth: 1.0,
                  );
                }

                return FlLine(color: Colors.transparent);
              },
            ),
            groupsSpace: 15.0,
            barGroups: barGroups,
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: buildBottomSideTitles(
                context: context,
                title: (double value) => getDayTitle(widget.forecast, value),
              ),
              leftTitles: buildLeftSideTitles(
                context: context,
                temperatureUnit: widget.temperatureUnit,
              ),
              rightTitles: buildEmptySideTitles(),
              topTitles: buildEmptySideTitles(),
            ),
            borderData: getBorderData(
              themeMode: widget.themeMode,
              colorTheme: widget.colorTheme,
            ),
            barTouchData: getBarTouchData(
              context: context,
              temperatureUnit: widget.temperatureUnit,
              colorTheme: widget.colorTheme,
              enabled: widget.enabled,
            ),
          ),
        ),
      );

  Widget _buildCircleIndicator() => Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: CirclePageIndicator(
            size: 4.0,
            dotColor: AppTheme.getBorderColor(
              widget.themeMode,
              colorTheme: widget.colorTheme,
            ),
            selectedDotColor:
                widget.colorTheme ? Colors.white : AppTheme.primaryColor,
            selectedSize: 6.0,
            itemCount: ChartType.values.length,
            currentPageNotifier: _chartTypeNotifier,
            onPageSelected: _tapChartType,
          ),
        ),
      );

  List<BarChartGroupData> get barGroups {
    List<BarChartGroupData> rodData = <BarChartGroupData>[];
    int count = 0;

    for (ForecastDaily day in _getDays()) {
      double tempMax = getTemperature(
        day.temp!.max!.toDouble(),
        widget.temperatureUnit,
      ).toDouble();

      double tempMin = getTemperature(
        day.temp!.min!.toDouble(),
        widget.temperatureUnit,
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
              colors: widget.gradientColors ?? getLineColors(widget.colorTheme),
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
                    widget.colorTheme,
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

    for (ForecastDaily day in _getDays()) {
      spots.add(
        FlSpot(
          index.toDouble(),
          getTemperature(
            day.temp!.max!.toDouble(),
            widget.temperatureUnit,
          ).toDouble(),
        ),
      );

      index++;
    }

    return spots;
  }

  List<FlSpot> _getTempMinSpots() {
    int index = 0;
    List<FlSpot> spots = [];

    for (ForecastDaily day in _getDays()) {
      spots.add(
        FlSpot(
          index.toDouble(),
          getTemperature(
            day.temp!.min!.toDouble(),
            widget.temperatureUnit,
          ).toDouble(),
        ),
      );

      index++;
    }

    return spots;
  }

  void _tapChartType(
    int page,
  ) {
    if (widget.enabled) {
      _chartTypeNotifier.value = page;
      animatePage(_pageController, page: page);
    }
  }
}