import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/bloc/bloc.dart';

class ForecastWindDirection extends StatelessWidget {
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
  Widget build(
    BuildContext context,
  ) {
    AppState state = context.watch<AppBloc>().state;
    if ((state.themeMode == ThemeMode.light) && !state.colorTheme) {
      return _rotate(
        degree ?? 0.0,
        Icon(
          Icons.navigation,
          color: color,
          size: size,
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
              degree ?? 0.0,
              Icon(
                Icons.navigation,
                color: shadowColor,
                size: size,
              ),
            ),
          ),
          _rotate(
            degree ?? 0.0,
            Icon(
              Icons.navigation,
              color: color,
              size: size,
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
