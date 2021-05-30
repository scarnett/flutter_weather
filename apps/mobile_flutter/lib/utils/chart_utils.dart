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
  String format: 'M/d',
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

List<Color> getLineColors(
  bool colorTheme, {
  double opacity: 1.0,
}) =>
    colorTheme
        ? [Colors.white.withOpacity(opacity)]
        : AppTheme.getComplimentaryColors(opacity: opacity);

LineChartBarData getLineData({
  List<FlSpot>? spots,
  List<Color>? colors,
  double barWidth: 3.0,
  double opacity: 1.0,
  List<int> showingIndicators: const [],
}) =>
    LineChartBarData(
      spots: spots,
      isCurved: true,
      colors: colors,
      barWidth: barWidth,
      isStrokeCapRound: true,
      showingIndicators: showingIndicators,
      dotData: FlDotData(
        show: true,
        getDotPainter: (
          FlSpot spot,
          double percent,
          LineChartBarData barData,
          int index,
        ) =>
            getSpotPainter(opacity: opacity),
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

Color getPrimaryColor({
  required bool colorTheme,
}) {
  if (colorTheme) {
    return Colors.white;
  }

  return AppTheme.primaryColor;
}

Color getTextColor({
  required bool colorTheme,
}) {
  if (colorTheme) {
    return AppTheme.secondaryColor;
  }

  return Colors.white;
}

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
  } else if (colorTheme) {
    return color.withOpacity(0.15);
  }

  return color;
}

SideTitles buildLeftSideTitles({
  required BuildContext context,
  required TemperatureUnit temperatureUnit,
}) =>
    SideTitles(
      showTitles: true,
      reservedSize: 30.0,
      getTextStyles: (double value) => Theme.of(context)
          .textTheme
          .subtitle2!
          .copyWith(fontWeight: FontWeight.bold),
      getTitles: (double value) {
        if ((value % 5) == 0) {
          return '${value.round().toString()} ${temperatureUnit.unitSymbol}';
        }

        return '';
      },
    );

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
  bool colorTheme: false,
  double opacity: 1.0,
}) =>
    FlDotCirclePainter(
      radius: colorTheme ? 2.0 : radius,
      color: Colors.white,
      strokeWidth: colorTheme ? 0.0 : strokeWidth,
      strokeColor: getPrimaryColor(colorTheme: colorTheme).withOpacity(opacity),
    );

LineTouchData getLineTouchData({
  required BuildContext context,
  required TemperatureUnit temperatureUnit,
  required Function(int) callback,
  bool colorTheme: false,
  bool enabled: true,
}) =>
    LineTouchData(
      enabled: enabled,
      touchTooltipData: getLineTooltipData(
        context: context,
        temperatureUnit: temperatureUnit,
        colorTheme: colorTheme,
      ),
      getTouchedSpotIndicator: (
        LineChartBarData barData,
        List<int> spotIndexes,
      ) =>
          getTouchedSpots(
        barData,
        spotIndexes,
        colorTheme: colorTheme,
        enabled: enabled,
      ),
    );

BarTouchData getBarTouchData({
  required BuildContext context,
  required TemperatureUnit temperatureUnit,
  bool colorTheme: false,
  bool enabled: true,
}) =>
    BarTouchData(
      touchTooltipData: getBarTooltipData(
        context: context,
        temperatureUnit: temperatureUnit,
        colorTheme: colorTheme,
      ),
    );

List<TouchedSpotIndicatorData?> getTouchedSpots(
  LineChartBarData barData,
  List<int> spotIndexes, {
  bool colorTheme: false,
  bool enabled: true,
}) =>
    spotIndexes
        .map(
          (int index) => TouchedSpotIndicatorData(
            FlLine(color: getPrimaryColor(colorTheme: colorTheme)),
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

LineTouchTooltipData getLineTooltipData({
  required BuildContext context,
  required TemperatureUnit temperatureUnit,
  bool colorTheme: false,
}) =>
    LineTouchTooltipData(
      tooltipBgColor: getPrimaryColor(colorTheme: colorTheme),
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
                        color: getTextColor(colorTheme: colorTheme),
                        height: 1.0,
                      ),
                ),
              )
              .toList(),
    );

BarTouchTooltipData getBarTooltipData({
  required BuildContext context,
  required TemperatureUnit temperatureUnit,
  bool colorTheme: false,
}) =>
    BarTouchTooltipData(
      tooltipBgColor: getPrimaryColor(colorTheme: colorTheme),
      fitInsideHorizontally: true,
      getTooltipItem: (
        BarChartGroupData group,
        int groupIndex,
        BarChartRodData rod,
        int rodIndex,
      ) =>
          BarTooltipItem(
        getTemperatureStr(
          rod.y.round(),
          temperatureUnit,
        ),
        Theme.of(context).textTheme.headline6!.copyWith(
              color: getTextColor(colorTheme: colorTheme),
              height: 1.0,
            ),
      ),
    );
