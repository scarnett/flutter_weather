import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/app/app_theme.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';
import 'package:flutter_weather/app/widgets/widgets.dart';
import 'package:flutter_weather/premium/widgets/premium_clipper.dart';
import 'package:flutter_weather/premium/widgets/premium_star.dart';

class PremiumView extends StatelessWidget {
  // static Route route() =>
  //     MaterialPageRoute<void>(builder: (_) => PremiumView());

  const PremiumView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) =>
      PremiumPageView();
}

class PremiumPageView extends StatefulWidget {
  PremiumPageView({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PremiumPageViewState();
}

class _PremiumPageViewState extends State<PremiumPageView> {
  @override
  Widget build(
    BuildContext context,
  ) =>
      AppUiOverlayStyle(
        systemNavigationBarIconBrightness:
            context.read<AppBloc>().state.colorTheme ? Brightness.dark : null,
        child: Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: _buildContent(),
        ),
      );

  Widget _buildContent() => Stack(
        children: [
          Positioned(
            child: ClipPath(
              clipper: PremiumClipper(),
              child: Container(
                color: AppTheme.primaryColor,
                height: 300.0,
                width: double.infinity,
              ),
            ),
          ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
              ),
              width: double.infinity,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      'GET ALL PREMIUM FEATURES', // TODO!
                      style: Theme.of(context).textTheme.headline4,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 20.0,
                      left: 40.0,
                      right: 40.0,
                    ),
                    child: Text(
                      'Refresh your forecasts anytime, get hourly and weekly forecasts, ad free and more...', // TODO!
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  FlatButton(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    onPressed: () => null,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        PremiumStar(),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Text(
                            'Start Today!',
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '\$1.00 per year', // TODO!
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontSize: 10.0),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
}
