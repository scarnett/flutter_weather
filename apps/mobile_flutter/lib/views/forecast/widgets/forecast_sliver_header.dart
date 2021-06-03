import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/models/models.dart';
import 'package:flutter_weather/views/forecast/forecast_extension.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_current_temp.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_location.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_options.dart';

class ForecastSliverHeader extends SliverPersistentHeaderDelegate {
  final BuildContext parentContext;
  final Forecast forecast;
  final Color? forecastColor;

  ForecastSliverHeader({
    required this.parentContext,
    required this.forecast,
    this.forecastColor,
  });

  @override
  double get minExtent => (MediaQuery.of(parentContext).padding.top + 160.0);

  @override
  double get maxExtent => (MediaQuery.of(parentContext).padding.top + 230.0);

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate _) => true;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) =>
      LayoutBuilder(
        builder: (
          BuildContext context,
          BoxConstraints constraints,
        ) {
          final double expandRatio = _calculateExpandRatio(constraints);
          final AlwaysStoppedAnimation<double> resizeAnimation =
              AlwaysStoppedAnimation(expandRatio);

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _getBackgroundColor(context),
                  _getBackgroundColor(context).withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.7, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            padding: EdgeInsets.only(
              top:
                  (MediaQuery.of(context).padding.top + ForecastOptions.height),
              bottom: 10.0,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Stack(
                children: [
                  ForecastLocation(
                    forecast: forecast,
                    shrinkOffset: shrinkOffset,
                    maxExtent: maxExtent,
                    minExtent: minExtent,
                    resizeAnimation: resizeAnimation,
                  ),
                  ForecastCurrentTemp(
                    currentDay: forecast.list!.first,
                    shrinkOffset: shrinkOffset,
                    maxExtent: maxExtent,
                    minExtent: minExtent,
                    resizeAnimation: resizeAnimation,
                  ),
                ],
              ),
            ),
          );
        },
      );

  Color _getBackgroundColor(
    BuildContext context,
  ) {
    if (context.read<AppBloc>().state.colorTheme) {
      if (forecastColor != null) {
        return forecastColor!.withOpacity(0.8);
      }

      return forecast.getTemperatureColor().withOpacity(0.8);
    }

    return Theme.of(context).appBarTheme.color!;
  }

  double _calculateExpandRatio(
    BoxConstraints constraints,
  ) {
    double expandRatio =
        ((constraints.maxHeight - minExtent) / (maxExtent - minExtent));

    if (expandRatio > 1.0) {
      expandRatio = 1.0;
    }

    if (expandRatio < 0.0) {
      expandRatio = 0.0;
    }

    return expandRatio;
  }
}
