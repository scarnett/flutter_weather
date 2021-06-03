import 'package:flutter/widgets.dart';
import 'package:flutter_weather/localization.dart';

enum ChartType {
  line,
  bar,
}

extension ChartTypeExtension on ChartType {
  String getText(
    BuildContext context,
  ) {
    switch (this) {
      case ChartType.bar:
        return AppLocalizations.of(context)!.chartBar;

      case ChartType.line:
      default:
        return AppLocalizations.of(context)!.chartLine;
    }
  }
}

ChartType getChartType(
  String? chartType,
) {
  switch (chartType) {
    case 'ChartType.bar':
      return ChartType.bar;

    case 'ChartType.line':
    default:
      return ChartType.line;
  }
}
