import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';
import 'package:flutter_weather/premium/widgets/widgets.dart';

class PremiumBackdrop extends StatefulWidget {
  final int expandSpeed;
  final AnimationController animationController;

  PremiumBackdrop({
    Key? key,
    this.expandSpeed: 1250,
    required this.animationController,
  }) : super(key: key);

  @override
  _PremiumBackdropState createState() => _PremiumBackdropState();
}

class _PremiumBackdropState extends State<PremiumBackdrop> {
  @override
  Widget build(
    BuildContext context,
  ) =>
      GestureDetector(
        onTap: () => context.read<AppBloc>().add(SetShowPremiumInfo(false)),
        child: ClipPath(
          clipper: PremiumClipper(curveHeight: 0.0),
          child: AnimatedContainer(
            color: _backdropColor,
            height: context.read<AppBloc>().state.showPremiumInfo
                ? MediaQuery.of(context).size.height
                : 0.0,
            width: double.infinity,
            duration: _getBackdropAnimateDuration(),
            curve: Curves.easeOut,
            child: PremiumCarousel(
              animationController: widget.animationController,
            ),
          ),
        ),
      );

  Duration _getBackdropAnimateDuration() {
    int speed = widget.expandSpeed;
    return Duration(milliseconds: (speed - (speed * 0.75)).round());
  }

  Color get _backdropColor {
    AppState state = context.read<AppBloc>().state;
    if (state.colorTheme) {
      return Colors.black.withOpacity(0.75);
    }

    return Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9);
  }
}
