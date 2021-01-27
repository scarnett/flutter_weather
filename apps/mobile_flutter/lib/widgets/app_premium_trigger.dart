import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/bloc/bloc.dart';

class AppPremiumTrigger extends StatefulWidget {
  const AppPremiumTrigger({
    Key key,
  }) : super(key: key);

  _AppPremiumTrigger createState() => _AppPremiumTrigger();
}

class _AppPremiumTrigger extends State<AppPremiumTrigger>
    with TickerProviderStateMixin {
  AnimationController _rotateController;
  AnimationController _sizeController;
  Tween<double> _sizeTween;
  bool _colorTheme = false;

  @override
  void initState() {
    _initialize();
    _colorTheme = context.read<AppBloc>().state.colorTheme;
    super.initState();
  }

  @override
  void dispose() {
    _rotateController?.dispose();
    _sizeController?.dispose();
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
          child: Container(
            height: 40.0,
            width: 40.0,
            child: InkWell(
              borderRadius: BorderRadius.circular(40.0),
              child: Icon(
                Icons.star,
                color: _colorTheme ? Colors.white : Colors.amber,
              ),
            ),
          ),
        ),
        builder: (
          BuildContext context,
          Widget widget,
        ) =>
            Transform.rotate(
          angle: (_rotateController.value * 6.3),
          child: widget,
        ),
      );

  void _initialize() {
    _rotateController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 20),
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

    _sizeTween = Tween(begin: 1.25, end: 1.0);

    _rotateController.repeat();
    _sizeController.forward();
    //_sizeController.repeat(reverse: true);
  }
}
