import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PremiumStar extends StatefulWidget {
  final Color color;
  final double? iconSize;
  final double pulseSize;
  final double speed;

  PremiumStar({
    this.color: Colors.amber,
    this.speed: 6.0,
    this.iconSize,
    this.pulseSize: 1.25,
  });

  @override
  _ForecastIconState createState() => _ForecastIconState();
}

class _ForecastIconState extends State<PremiumStar>
    with TickerProviderStateMixin {
  late AnimationController _rotateController;
  late AnimationController _sizeController;
  late Tween<double> _sizeTween;

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  void dispose() {
    _rotateController.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) =>
      AnimatedBuilder(
        animation: _rotateController,
        child: ScaleTransition(
          scale: _sizeTween.animate(
            CurvedAnimation(
              parent: _sizeController,
              curve: Curves.elasticOut,
            ),
          ),
          child: Icon(
            Icons.star,
            color: widget.color,
            size: widget.iconSize,
          ),
        ),
        builder: (
          BuildContext context,
          Widget? _widget,
        ) =>
            RotationTransition(
          turns: Tween(begin: 0.0, end: 1.0).animate(_rotateController),
          child: _widget,
        ),
      );

  void _initialize() {
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );

    _sizeController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
      value: 1.0,
    )..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          Future.delayed(
            Duration(seconds: 10),
            () => _sizeController.forward(from: 0.0),
          );
        }
      });

    _sizeTween = Tween(begin: widget.pulseSize, end: 1.0);

    _rotateController.repeat();
    _sizeController.forward();
    //_sizeController.repeat(reverse: true);
  }
}
