import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/app/app_localization.dart';
import 'package:flutter_weather/app/app_theme.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';
import 'package:flutter_weather/app/utils/utils.dart';
import 'package:flutter_weather/premium/premium.dart';
import 'package:flutter_weather/premium/widgets/premium_clipper.dart';

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

  late AnimationController _overlayCurveTweenController;
  late Animation _overlayCurveAnimation;

  @override
  void initState() {
    super.initState();

    _overlayCurveTweenController = AnimationController(
      duration: Duration(milliseconds: widget.expandSpeed),
      vsync: this,
    );

    _overlayCurveAnimation = Tween(begin: 0.0, end: widget.curveHeight)
        .animate(_overlayCurveTweenController);
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
          _overlayCurveTweenController.forward();
        } else {
          _overlayCurveTweenController.reverse();
        }
      });
    }
  }

  Widget _buildChild() {
    if (context.read<AppBloc>().state.showPremiumInfo) {
      return GestureDetector(
        onTap: () => context.read<AppBloc>().add(SetShowPremiumInfo(false)),
        child: widget.child,
      );
    }

    return widget.child;
  }

  Widget _buildContent() => AnimatedBuilder(
        animation: _overlayCurveTweenController,
        builder: (BuildContext context, Widget? child) => Stack(
          children: [
            GestureDetector(
              onTap: () =>
                  context.read<AppBloc>().add(SetShowPremiumInfo(false)),
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
                ),
              ),
            ),
            CustomPaint(
              painter: PremiumClipperShadowPainter(
                clipper:
                    PremiumClipper(curveHeight: _overlayCurveAnimation.value),
                shadow: Shadow(
                  color: _overlayShadowColor,
                  offset: Offset(0.0, 10.0),
                ),
              ),
              child: ClipPath(
                clipper:
                    PremiumClipper(curveHeight: _overlayCurveAnimation.value),
                child: AnimatedContainer(
                  color: AppTheme.primaryColor,
                  height: context.read<AppBloc>().state.showPremiumInfo
                      ? widget.expandHeight
                      : 0.0,
                  width: double.infinity,
                  duration: Duration(milliseconds: widget.expandSpeed),
                  curve: Curves.bounceOut,
                  child: _buildTopContent(),
                  clipBehavior: Clip.antiAlias,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildTopContent() => SafeArea(
        child: Stack(
          children: [
            AnimatedContainer(
              duration: _getContentAnimateDuration(),
              curve: Curves.easeOut,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(),
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
              ),
              width: double.infinity,
              height: context.read<AppBloc>().state.showPremiumInfo ? 400 : 0.0,
              child: Wrap(
                runAlignment: WrapAlignment.center,
                alignment: WrapAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      AppLocalizations.of(context)!.premium,
                      style: Theme.of(context)
                          .textTheme
                          .headline4!
                          .copyWith(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10.0,
                      left: 40.0,
                      right: 40.0,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.premiumText,
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: AppTheme.getFadedTextColor(colorTheme: true),
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    onPressed: () => null,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        PremiumStar(),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Text(
                            AppLocalizations.of(context)!.premiumSubscribe,
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: Text(
                      AppLocalizations.of(context)!.getPremiumCost(
                          (2.00).formatDecimal(decimals: 2)), // TODO!
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            color: AppTheme.getFadedTextColor(colorTheme: true),
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      AppTheme.primaryColor,
                      AppTheme.primaryColor.withOpacity(0.0),
                    ],
                    stops: [0.0, 1.0],
                  ),
                ),
                height: ((widget.curveHeight / 2.0) -
                    (_overlayCurveAnimation.value / 2.0)),
              ),
            ),
          ],
        ),
      );

  Duration _getBackdropAnimateDuration() {
    int speed = widget.expandSpeed;
    return Duration(milliseconds: (speed - (speed * 0.75)).round());
  }

  Duration _getContentAnimateDuration() {
    int speed = widget.expandSpeed;

    if (context.read<AppBloc>().state.showPremiumInfo) {
      speed = (speed + (speed * 0.75)).round();
    } else {
      speed = (speed - (speed * 0.25)).round();
    }

    return Duration(milliseconds: speed);
  }

  Color get _backdropColor {
    AppState state = context.read<AppBloc>().state;
    if (state.colorTheme) {
      return Colors.black.withOpacity(0.75);
    }

    return Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9);
  }

  Color get _overlayShadowColor {
    AppState state = context.read<AppBloc>().state;
    if (state.colorTheme) {
      return Colors.black.withOpacity(0.2);
    }

    return Colors.black.withOpacity(0.1);
  }
}
