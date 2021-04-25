import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/bloc/bloc.dart';

class ForecastWindDirection extends StatefulWidget {
  final IconData icon;
  final double size;
  final Color? color;
  final Color shadowColor;
  final num? degree;

  ForecastWindDirection({
    this.icon: Icons.navigation,
    this.size: 20.0,
    this.color,
    this.shadowColor: Colors.black38,
    this.degree,
  });

  @override
  _ForecastWindDirectionState createState() => _ForecastWindDirectionState();
}

class _ForecastWindDirectionState extends State<ForecastWindDirection> {
  @override
  Widget build(
    BuildContext context,
  ) {
    if ((context.watch<AppBloc>().state.themeMode == ThemeMode.light) &&
        !context.watch<AppBloc>().state.colorTheme) {
      return _rotate(
        widget.degree!,
        Icon(
          Icons.navigation,
          color: widget.color,
          size: widget.size,
        ),
      );
    }

    return Align(
      alignment: Alignment.center,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 1.0,
            left: 1.0,
            child: _rotate(
              widget.degree!,
              Icon(
                Icons.navigation,
                color: widget.shadowColor,
                size: widget.size,
              ),
            ),
          ),
          _rotate(
            widget.degree!,
            Icon(
              Icons.navigation,
              color: widget.color,
              size: widget.size,
            ),
          ),
        ],
      ),
    );
  }

  Widget _rotate(
    num degree,
    Widget child,
  ) =>
      RotationTransition(
        turns: AlwaysStoppedAnimation(degree / 360.0),
        child: child,
      );
}
