import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';
import 'package:weather_icons/weather_icons.dart';

class ForecastIcon extends StatelessWidget {
  final double containerSize;
  final IconData? icon;
  final double iconSize;
  final Color? color;
  final Color shadowColor;
  final Animation<double>? resizeAnimation;

  ForecastIcon({
    this.containerSize: 90.0,
    this.icon,
    this.iconSize: 60.0,
    this.color,
    this.shadowColor: Colors.black38,
    this.resizeAnimation,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    if ((context.watch<AppBloc>().state.themeMode == ThemeMode.light) && !context.watch<AppBloc>().state.colorTheme) {
      return SizedBox(
        height: getContainerSize(),
        child: BoxedIcon(
          icon!,
          color: color,
          size: getIconSize(),
        ),
      );
    }

    return Stack(
      children: <Widget>[
        Positioned.fill(
          top: 1.0,
          left: 1.0,
          child: BoxedIcon(
            icon!,
            color: shadowColor,
            size: getIconSize(),
          ),
        ),
        Positioned(
          child: SizedBox(
            height: getContainerSize(),
            child: BoxedIcon(
              icon!,
              color: color,
              size: getIconSize(),
            ),
          ),
        ),
      ],
    );
  }

  double getIconSize() {
    if (resizeAnimation == null) {
      return iconSize;
    }

    return Tween<double>(
      begin: (iconSize - 36.0),
      end: iconSize,
    ).evaluate(resizeAnimation!);
  }

  double getContainerSize() {
    if (resizeAnimation == null) {
      return containerSize;
    }

    return Tween<double>(
      begin: (containerSize - 50.0),
      end: containerSize,
    ).evaluate(resizeAnimation!);
  }
}
