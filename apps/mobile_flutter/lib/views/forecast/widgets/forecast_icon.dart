import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:weather_icons/weather_icons.dart';

class ForecastIcon extends StatefulWidget {
  final double containerSize;
  final IconData? icon;
  final double iconSize;
  final double scaleFactor;
  final Color? color;
  final Color shadowColor;

  ForecastIcon({
    this.containerSize: 90.0,
    this.icon,
    this.iconSize: 60.0,
    this.scaleFactor: 1.0,
    this.color,
    this.shadowColor: Colors.black38,
  });

  @override
  _ForecastIconState createState() => _ForecastIconState();
}

class _ForecastIconState extends State<ForecastIcon> {
  @override
  Widget build(
    BuildContext context,
  ) {
    if ((context.watch<AppBloc>().state.themeMode == ThemeMode.light) &&
        !context.watch<AppBloc>().state.colorTheme) {
      return SizedBox(
        height: containerSize,
        child: BoxedIcon(
          widget.icon!,
          color: widget.color,
          size: iconSize,
        ),
      );
    }

    return Stack(
      children: <Widget>[
        Positioned.fill(
          top: 1.0,
          left: 1.0,
          child: BoxedIcon(
            widget.icon!,
            color: widget.shadowColor,
            size: iconSize,
          ),
        ),
        Positioned(
          child: SizedBox(
            height: containerSize,
            child: BoxedIcon(
              widget.icon!,
              color: widget.color,
              size: iconSize,
            ),
          ),
        ),
      ],
    );
  }

  double get iconSize => (widget.iconSize * widget.scaleFactor);

  double get containerSize => (widget.containerSize * widget.scaleFactor);
}
