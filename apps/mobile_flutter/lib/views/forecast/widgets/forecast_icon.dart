import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:weather_icons/weather_icons.dart';

class ForecastIcon extends StatefulWidget {
  final IconData? icon;
  final double size;
  final Color? color;
  final Color shadowColor;

  ForecastIcon({
    this.icon,
    this.size: 80.0,
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
      return BoxedIcon(
        widget.icon!,
        color: widget.color,
        size: widget.size,
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
            size: widget.size,
          ),
        ),
        BoxedIcon(
          widget.icon!,
          color: widget.color,
          size: widget.size,
        ),
      ],
    );
  }
}
