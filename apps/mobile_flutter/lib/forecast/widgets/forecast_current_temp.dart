import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/app/app_localization.dart';
import 'package:flutter_weather/app/widgets/widgets.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/forecast/forecast.dart';
import 'package:flutter_weather/models/models.dart';

class ForecastCurrentTemp extends StatelessWidget {
  final ForecastDay currentDay;
  final double? shrinkOffset;
  final double? maxExtent;
  final double? minExtent;
  final Animation<double>? resizeAnimation;

  final AlignmentTween _currentTemperatureAlignTween = AlignmentTween(
    begin: Alignment.bottomCenter,
    end: Alignment.topRight,
  );

  ForecastCurrentTemp({
    Key? key,
    required this.currentDay,
    this.shrinkOffset,
    this.maxExtent,
    this.minExtent,
    this.resizeAnimation,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) {
    AppState state = context.read<AppBloc>().state;
    return Container(
      child: Align(
        alignment: _getAlignment(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppTemperatureDisplay(
                  temperature: getTemperature(
                    currentDay.temp!.day,
                    state.units.temperature,
                  ).toString(),
                  style: getTemperatureTextStyle(context),
                ),
                AppTemperatureDisplay(
                  temperature:
                      AppLocalizations.of(context)!.getFeelsLike(getTemperature(
                    currentDay.feelsLike!.day,
                    state.units.temperature,
                  ).toString()),
                  style: getFeelsLikeTextStyle(context),
                  unitSizeFactor: 1.5,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: getTemperaturePadding(context)),
              child: ForecastIcon(
                icon: getForecastIconData(currentDay.weather!.first.icon),
                resizeAnimation: resizeAnimation,
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle getTemperatureTextStyle(
    BuildContext context,
  ) {
    TextStyle style = Theme.of(context).textTheme.headline1!;

    if (resizeAnimation != null) {
      return style.copyWith(
        fontSize: (resizeAnimation == null)
            ? null
            : Tween<double>(
                begin: (style.fontSize! - 40.0),
                end: style.fontSize,
              ).evaluate(resizeAnimation!),
      );
    }

    return style;
  }

  TextStyle getFeelsLikeTextStyle(
    BuildContext context,
  ) {
    TextStyle style = Theme.of(context).textTheme.headline5!;

    if (resizeAnimation != null) {
      return style.copyWith(
        fontSize: (resizeAnimation == null)
            ? null
            : Tween<double>(
                begin: (style.fontSize! - 6.0),
                end: style.fontSize,
              ).evaluate(resizeAnimation!),
      );
    }

    return style;
  }

  double getTemperaturePadding(
    BuildContext context,
  ) {
    if (resizeAnimation == null) {
      return 40.0;
    }

    return Tween<double>(
      begin: 10.0,
      end: 40.0,
    ).evaluate(resizeAnimation!);
  }

  bool isScrollable() =>
      ((shrinkOffset != null) && (maxExtent != null) && (minExtent != null));

  AlignmentGeometry _getAlignment() {
    if (isScrollable()) {
      return _currentTemperatureAlignTween.lerp(
        getScrollProgress(
          shrinkOffset: shrinkOffset!,
          maxExtent: maxExtent!,
          minExtent: minExtent!,
          speed: 0.5,
        ),
      );
    }

    return Alignment.center;
  }
}
