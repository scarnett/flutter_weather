import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_weather/enums.dart';
import 'package:flutter_weather/theme.dart';
import 'package:flutter_weather/utils/chart_utils.dart';
import 'package:flutter_weather/views/forecast/forecast_extension.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/forecast_utils.dart';

class ForecastDayCharts extends StatelessWidget {
  final Forecast forecast;
  final TemperatureUnit temperatureUnit;
  final ThemeMode themeMode;
  final bool colorTheme;
  final List<Color>? gradientColors;

  ForecastDayCharts({
    Key? key,
    required this.forecast,
    required this.temperatureUnit,
    required this.themeMode,
    this.colorTheme: false,
    this.gradientColors,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) =>
      _buildLineChart(context);

  Widget _buildLineChart(
    BuildContext context,
  ) =>
      LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: false,
            drawVerticalLine: true,
            getDrawingVerticalLine: (double value) => FlLine(
              color: getGridBorderColor(
                themeMode: themeMode,
                colorTheme: colorTheme,
              ),
              strokeWidth: 1.0,
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: buildBottomSideTitles(
              context: context,
              title: (double value) => getDayTitle(forecast, value),
            ),
            leftTitles: buildEmptySideTitles(),
            rightTitles: buildEmptySideTitles(),
            topTitles: buildEmptySideTitles(),
          ),
          borderData: getBorderData(
            themeMode: themeMode,
            colorTheme: colorTheme,
          ),
          minX: 0.0,
          maxX: (_getDays().length.toDouble() - 1.0),
          minY: getTemperature(
            forecast.getDayHighMin().temp!.min!.toDouble(),
            temperatureUnit,
          ).toDouble(),
          maxY: getTemperature(
            forecast.getDayHighMax().temp!.max!.toDouble(),
            temperatureUnit,
          ).toDouble(),
          lineBarsData: [
            getLineData(
              spots: _getSpots(),
              colors: gradientColors ?? AppTheme.complimentaryColors,
            ),
          ],
          lineTouchData: getLineTouchData(
            context: context,
            temperatureUnit: temperatureUnit,
          ),
        ),
      );

  List<ForecastDaily> _getDays({
    int count: 8, // TODO! premium
  }) {
    if (forecast.details!.daily == null) {
      return [];
    } else if (forecast.details!.daily!.length < count) {
      return forecast.details!.daily!;
    }

    return forecast.details!.daily!.sublist(0, (count - 1));
  }

  List<FlSpot> _getSpots() {
    int index = 0;
    List<FlSpot> spots = [];

    for (ForecastDaily day in _getDays()) {
      spots.add(
        FlSpot(
          index.toDouble(),
          getTemperature(
            day.temp!.max!.toDouble(),
            temperatureUnit,
          ).toDouble(),
        ),
      );

      index++;
    }

    return spots;
  }

  // Widget _buildStackedChart() => BarChart(
  //       BarChartData(
  //         alignment: BarChartAlignment.center,
  //         maxY: 20.0,
  //         minY: -20.0,
  //         groupsSpace: 12.0,
  //         barTouchData: BarTouchData(
  //           enabled: false,
  //         ),
  //         barGroups: [
  //           BarChartGroupData(
  //             x: 0,
  //             barRods: [
  //               BarChartRodData(
  //                 y: 15.1,
  //                 width: 20.0,
  //                 borderRadius: const BorderRadius.only(
  //                   topLeft: Radius.circular(6.0),
  //                   topRight: Radius.circular(
  //                     6.0,
  //                   ),
  //                 ),
  //                 rodStackItems: [
  //                   BarChartRodStackItem(0.0, 2.0, const Color(0xff2bdb90)),
  //                   BarChartRodStackItem(2.0, 5.0, const Color(0xffffdd80)),
  //                   BarChartRodStackItem(5.0, 7.5, const Color(0xffff4d94)),
  //                   BarChartRodStackItem(7.5, 15.5, const Color(0xff19bfff)),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     );
}
