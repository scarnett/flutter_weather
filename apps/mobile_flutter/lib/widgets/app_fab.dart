import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_weather/app_keys.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/views/lookup/lookup_view.dart';

class AppFAB extends StatefulWidget {
  final AnimationController animationController;

  AppFAB({
    Key? key,
    required this.animationController,
  }) : super(key: key);

  @override
  _AppFABState createState() => _AppFABState();
}

class _AppFABState extends State<AppFAB> with SingleTickerProviderStateMixin {
  @override
  Widget build(
    BuildContext context,
  ) =>
      FadeTransition(
        opacity: widget.animationController,
        child: ScaleTransition(
          alignment: Alignment.centerRight,
          scale: widget.animationController,
          child: FloatingActionButton(
            key: Key(AppKeys.addLocationKey),
            tooltip: AppLocalizations.of(context)!.addForecast,
            onPressed: _tapAddLocation,
            child: const Icon(Icons.add),
            mini: true,
          ),
        ),
      );

  void _tapAddLocation() {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    Navigator.push(context, LookupView.route());
  }
}

class AppFABNoScalingAnimation extends FloatingActionButtonAnimator {
  late double _x;
  late double _y;

  @override
  Offset getOffset({
    required Offset begin,
    required Offset end,
    required double progress,
  }) {
    _x = (begin.dx + (end.dx - begin.dx) * progress);
    _y = (begin.dy + (end.dy - begin.dy) * progress);
    return Offset(_x, _y);
  }

  @override
  Animation<double> getRotationAnimation({
    required Animation<double> parent,
  }) =>
      Tween<double>(begin: 1.0, end: 1.0).animate(parent);

  @override
  Animation<double> getScaleAnimation({
    required Animation<double> parent,
  }) =>
      Tween<double>(begin: 1.0, end: 1.0).animate(parent);
}
