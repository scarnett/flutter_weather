import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';
import 'package:flutter_weather/premium/premium.dart';

class PremiumOverlayView extends StatefulWidget {
  final Widget child;
  final double expandHeight;
  final int expandSpeed;
  final double curveHeight;

  PremiumOverlayView({
    required this.child,
    this.expandHeight: 275.0,
    this.expandSpeed: 1250,
    this.curveHeight: 30.0,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PremiumOverlayViewState();
}

class _PremiumOverlayViewState extends State<PremiumOverlayView>
    with TickerProviderStateMixin {
  bool _showOverlay = false;

  late AnimationController _carouselCurveTweenController;
  late AnimationController _overlayCurveTweenController;
  late Animation _overlayCurveAnimation;

  @override
  void initState() {
    super.initState();

    _carouselCurveTweenController = AnimationController(
      duration: Duration(milliseconds: (widget.expandSpeed ~/ 2)),
      vsync: this,
    );

    _overlayCurveTweenController = AnimationController(
      duration: Duration(milliseconds: widget.expandSpeed),
      vsync: this,
    );

    _overlayCurveAnimation = Tween(begin: 0.0, end: widget.curveHeight)
        .animate(_overlayCurveTweenController);
  }

  @override
  void dispose() {
    _carouselCurveTweenController.dispose();
    _overlayCurveTweenController.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) =>
      Container(
        child: BlocListener<AppBloc, AppState>(
          listener: _blocListener,
          child: Stack(
            children: [
              _buildChild(),
              _buildContent(),
            ],
          ),
        ),
      );

  void _blocListener(
    BuildContext context,
    AppState state,
  ) {
    if (state.showPremiumInfo != _showOverlay) {
      setState(() {
        _showOverlay = state.showPremiumInfo;

        if (state.showPremiumInfo) {
          _carouselCurveTweenController.forward();
          _overlayCurveTweenController.forward();
        } else {
          _carouselCurveTweenController.reverse();
          _overlayCurveTweenController.reverse();
        }
      });
    }
  }

  Widget _buildChild() => GestureDetector(
        onTap: context.read<AppBloc>().state.showPremiumInfo
            ? () => context.read<AppBloc>().add(SetShowPremiumInfo(false))
            : null,
        child: widget.child,
      );

  Widget _buildContent() => AnimatedBuilder(
        animation: _overlayCurveTweenController,
        builder: (
          BuildContext context,
          Widget? child,
        ) =>
            Stack(
          children: [
            PremiumBackdrop(
              animationController: _carouselCurveTweenController,
            ),
            PremiumBubble(
              overlayCurveTweenController: _overlayCurveTweenController,
              overlayCurveAnimation: _overlayCurveAnimation,
            ),
          ],
        ),
      );
}
