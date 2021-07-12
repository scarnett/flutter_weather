import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/app/app_theme.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';

class ForecastAlerts extends StatefulWidget {
  final double size;
  final double pulseSize;

  ForecastAlerts({
    Key? key,
    this.size: 18.0,
    this.pulseSize: 1.5,
  }) : super(key: key);

  @override
  _ForecastAlertsState createState() => _ForecastAlertsState();
}

class _ForecastAlertsState extends State<ForecastAlerts>
    with TickerProviderStateMixin {
  late AnimationController _sizeController;
  late Tween<double> _sizeTween;
  late Timer _sizeTimer;

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  void dispose() {
    _sizeController.dispose();
    _sizeTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) =>
      Material(
        type: MaterialType.transparency,
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: AppTheme.warningColor.withOpacity(0.3),
                width: 2.0,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              color: AppTheme.getAlertColor(
                context.read<AppBloc>().state.themeMode,
                colorTheme: context.read<AppBloc>().state.colorTheme,
              ),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 20.0,
            ),
            margin: const EdgeInsets.only(
              bottom: 20.0,
              left: 10.0,
              right: 10.0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: ScaleTransition(
                    scale: _sizeTween.animate(
                      CurvedAnimation(
                        parent: _sizeController,
                        curve: Curves.elasticOut,
                      ),
                    ),
                    child: Icon(
                      Icons.warning,
                      color: AppTheme.warningColor,
                      size: widget.size,
                    ),
                  ),
                ),
                Text(
                  'Severe Thunderstorm Watch', // TODO!
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(height: 1.0),
                ),
              ],
            ),
          ),
        ),
      );

  void _initialize() {
    _sizeController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
      value: 1.0,
    );

    _sizeTween = Tween(begin: widget.pulseSize, end: 1.0);
    _sizeTimer = Timer.periodic(
      const Duration(seconds: 10),
      (Timer timer) => _sizeController.forward(from: 0.0),
    );

    _sizeController.forward();
  }
}
