import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_weather/enums.dart';
import 'package:flutter_weather/theme.dart';
import 'package:flutter_weather/utils/date_utils.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/forecast_utils.dart';

String getDayTitle(
  Forecast forecast,
  double value, {
  String format: 'MM/dd',
}) {
  if ((value + 1.0) > forecast.details!.daily!.length) {
    return '';
  }

  ForecastDaily day = forecast.details!.daily![value.toInt()];
  return formatDateTime(
        date: epochToDateTime(day.dt!),
        format: format,
      ) ??
      '';
}

LineChartBarData getLineData({
  List<FlSpot>? spots,
  List<Color>? colors,
  double barWidth: 3.0,
}) =>
    LineChartBarData(
      spots: spots,
      isCurved: true,
      colors: colors,
      barWidth: barWidth,
      isStrokeCapRound: true,
      showingIndicators: [2],
      dotData: FlDotData(
        show: true,
        getDotPainter: (
          FlSpot spot,
          double percent,
          LineChartBarData barData,
          int index,
        ) =>
            getSpotPainter(),
      ),
    );

FlBorderData getBorderData({
  required ThemeMode themeMode,
  required bool colorTheme,
}) =>
    FlBorderData(
      show: true,
      border: Border.fromBorderSide(
        BorderSide(
          color: getGridBorderColor(
            themeMode: themeMode,
            colorTheme: colorTheme,
          ),
          width: 1.0,
        ),
      ),
    );

Color getGridBorderColor({
  required ThemeMode themeMode,
  required bool colorTheme,
}) {
  Color color = AppTheme.getBorderColor(
    themeMode,
    colorTheme: colorTheme,
  );

  if (themeMode == ThemeMode.dark) {
    return color.withOpacity(0.05);
  }

  return color;
}

SideTitles buildBottomSideTitles({
  required BuildContext context,
  required Function(double) title,
}) =>
    SideTitles(
      showTitles: true,
      reservedSize: 30.0,
      getTextStyles: (double value) => Theme.of(context)
          .textTheme
          .subtitle2!
          .copyWith(fontWeight: FontWeight.bold),
      getTitles: (double value) => title(value),
    );

SideTitles buildEmptySideTitles({
  reservedSize: 10.0,
}) =>
    SideTitles(
      showTitles: true,
      reservedSize: reservedSize,
      getTitles: (double value) => '',
    );

FlDotCirclePainter getSpotPainter({
  double radius: 4.0,
  double strokeWidth: 2.0,
}) =>
    FlDotCirclePainter(
      radius: radius,
      color: Colors.white.withOpacity(0.9),
      strokeWidth: strokeWidth,
      strokeColor: AppTheme.primaryColor,
    );

LineTouchData getLineTouchData({
  required BuildContext context,
  required TemperatureUnit temperatureUnit,
}) =>
    LineTouchData(
      enabled: true,
      touchTooltipData: getTooltipData(
        context: context,
        temperatureUnit: temperatureUnit,
      ),
      getTouchedSpotIndicator: getTouchedSpots,
    );

List<TouchedSpotIndicatorData?> getTouchedSpots(
  LineChartBarData barData,
  List<int> spotIndexes,
) =>
    spotIndexes
        .map(
          (int index) => TouchedSpotIndicatorData(
            FlLine(color: AppTheme.primaryColor),
            FlDotData(
              show: true,
              getDotPainter: (
                FlSpot spot,
                double percent,
                LineChartBarData barData,
                int index,
              ) =>
                  getSpotPainter(radius: 8.0),
            ),
          ),
        )
        .toList();

LineTouchTooltipData getTooltipData({
  required BuildContext context,
  required TemperatureUnit temperatureUnit,
}) =>
    LineTouchTooltipData(
      tooltipBgColor: AppTheme.primaryColor,
      tooltipRoundedRadius: 8.0,
      fitInsideHorizontally: true,
      getTooltipItems: (
        List<LineBarSpot> lineBarsSpot,
      ) =>
          lineBarsSpot
              .map(
                (LineBarSpot lineBarSpot) => LineTooltipItem(
                  getTemperatureStr(
                    lineBarSpot.y.round(),
                    temperatureUnit,
                  ),
                  Theme.of(context).textTheme.headline6!.copyWith(
                        color: Colors.white,
                        height: 1.0,
                      ),
                ),
              )
              .toList(),
    );
