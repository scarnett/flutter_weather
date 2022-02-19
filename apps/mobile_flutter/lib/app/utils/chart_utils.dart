import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/app/app_theme.dart';
import 'package:flutter_weather/app/utils/utils.dart';
import 'package:flutter_weather/enums/enums.dart';
import 'package:flutter_weather/forecast/forecast.dart';
import 'package:flutter_weather/models/models.dart';

String getDayTitle(
  Forecast forecast,
  double value, {
  String format: 'M/d',
}) {
  if ((value + 1.0) > forecast.details!.daily!.length) {
    return '';
  }

  ForecastDaily day = forecast.details!.daily![value.toInt()];
  return formatEpoch(epoch: day.dt!, format: format) ?? '';
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
  bool colorTheme: false,
  Color? forecastColor,
}) =>
    LineChartBarData(
      spots: spots,
      isCurved: true,
      colors: colors,
      barWidth: barWidth,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (
          FlSpot spot,
          double percent,
          LineChartBarData barData,
          int index,
        ) =>
            getSpotPainter(
          opacity: opacity,
          colorTheme: colorTheme,
          colorThemeColor: forecastColor,
        ),
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

Color getSpotColor({
  required bool colorTheme,
}) {
  if (colorTheme) {
    return Colors.white;
  }

  return AppTheme.primaryColor;
}

Color getSpotStrokeColor({
  required bool colorTheme,
  Color? colorThemeColor,
}) {
  if (colorTheme) {
    return colorThemeColor ?? Colors.white;
  }

  return AppTheme.primaryColor;
}

Color getTooltipColor({
  required bool colorTheme,
}) {
  if (colorTheme) {
    return Colors.white;
  }

  return AppTheme.primaryColor;
}

Color getTextColor({
  required double temperature,
  required bool colorTheme,
}) {
  if (colorTheme) {
    return getTemperatureColor(temperature);
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
      interval: 5.0,
      margin: 15.0,
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
  Color? colorThemeColor,
  double opacity: 1.0,
}) =>
    FlDotCirclePainter(
      radius: radius,
      color: Colors.white,
      strokeWidth: strokeWidth,
      strokeColor: getSpotStrokeColor(
        colorTheme: colorTheme,
        colorThemeColor: colorThemeColor,
      ).withOpacity(opacity),
    );

LineTouchData getLineTouchData({
  required BuildContext context,
  required TemperatureUnit temperatureUnit,
  required Function(int) callback,
  bool colorTheme: false,
  Color? forecastColor,
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
        forecastColor: forecastColor,
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
      enabled: enabled,
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
  Color? forecastColor,
  bool enabled: true,
}) =>
    spotIndexes
        .map(
          (int index) => TouchedSpotIndicatorData(
            FlLine(color: getSpotColor(colorTheme: colorTheme)),
            FlDotData(
              show: true,
              getDotPainter: (
                FlSpot spot,
                double percent,
                LineChartBarData barData,
                int index,
              ) =>
                  getSpotPainter(
                radius: 8.0,
                colorTheme: colorTheme,
                colorThemeColor: forecastColor,
              ),
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
      tooltipBgColor: getTooltipColor(colorTheme: colorTheme),
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
                        color: getTextColor(
                          temperature: lineBarSpot.y,
                          colorTheme: colorTheme,
                        ),
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
      tooltipBgColor: getTooltipColor(colorTheme: colorTheme),
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
              color: getTextColor(
                temperature: rod.y,
                colorTheme: colorTheme,
              ),
              height: 1.0,
            ),
      ),
    );
