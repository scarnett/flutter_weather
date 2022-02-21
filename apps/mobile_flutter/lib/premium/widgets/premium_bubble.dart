import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/app/app_localization.dart';
import 'package:flutter_weather/app/app_theme.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';
import 'package:flutter_weather/app/utils/utils.dart';
import 'package:flutter_weather/premium/premium.dart';
import 'package:flutter_weather/premium/widgets/widgets.dart';

class PremiumBubble extends StatefulWidget {
  final double expandHeight;
  final int expandSpeed;
  final double curveHeight;
  final AnimationController overlayCurveTweenController;
  final Animation overlayCurveAnimation;

  PremiumBubble({
    Key? key,
    this.expandHeight: 275.0,
    this.expandSpeed: 1250,
    this.curveHeight: 30.0,
    required this.overlayCurveTweenController,
    required this.overlayCurveAnimation,
  }) : super(key: key);

  @override
  _PremiumBubbleState createState() => _PremiumBubbleState();
}

class _PremiumBubbleState extends State<PremiumBubble> {
  @override
  Widget build(
    BuildContext context,
  ) =>
      AnimatedBuilder(
        animation: widget.overlayCurveTweenController,
        builder: (
          BuildContext context,
          Widget? child,
        ) =>
            CustomPaint(
          painter: PremiumClipperShadowPainter(
            clipper:
                PremiumClipper(curveHeight: widget.overlayCurveAnimation.value),
            shadow: Shadow(
              color: _overlayShadowColor,
              offset: Offset(0.0, 10.0),
            ),
          ),
          child: ClipPath(
            clipper:
                PremiumClipper(curveHeight: widget.overlayCurveAnimation.value),
            child: AnimatedContainer(
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.primaryColor.darken(10.0),
                    AppTheme.primaryColor,
                  ],
                  stops: [0.0, 0.5],
                ),
              ),
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
      );

  Widget _buildTopContent() => SafeArea(
        child: Stack(
          children: [
            AnimatedOpacity(
              opacity:
                  context.read<AppBloc>().state.showPremiumInfo ? 1.0 : 0.0,
              duration: _getContentFadeDuration(),
              child: AnimatedContainer(
                duration: _getContentAnimateDuration(),
                curve: Curves.easeOut,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(),
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                ),
                width: double.infinity,
                height:
                    context.read<AppBloc>().state.showPremiumInfo ? 400 : 0.0,
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
                              color:
                                  AppTheme.getFadedTextColor(colorTheme: true),
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    PremiumSubscriptionButton(),
                    Container(
                      width: double.infinity,
                      child: Text(
                        AppLocalizations.of(context)!.getPremiumCost(
                            (2.00).formatDecimal(decimals: 2)), // TODO! cost
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                              color:
                                  AppTheme.getFadedTextColor(colorTheme: true),
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
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
                    (widget.overlayCurveAnimation.value / 2.0)),
              ),
            ),
          ],
        ),
      );

  Duration _getContentAnimateDuration() {
    int speed = widget.expandSpeed;

    if (context.read<AppBloc>().state.showPremiumInfo) {
      speed = (speed + (speed * 0.75)).round();
    } else {
      speed = (speed - (speed * 0.25)).round();
    }

    return Duration(milliseconds: speed);
  }

  Duration _getContentFadeDuration() {
    int speed = widget.expandSpeed;
    return Duration(milliseconds: (speed / 1.5).round());
  }

  Color get _overlayShadowColor {
    AppState state = context.read<AppBloc>().state;
    if (state.colorTheme) {
      return Colors.black.withOpacity(0.2);
    }

    return Colors.black.withOpacity(0.1);
  }
}
