import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/app/app_theme.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';
import 'package:flutter_weather/models/models.dart';
import 'package:flutter_weather/premium/premium.dart';
import 'package:flutter_weather/services/services.dart';

class PremiumCarousel extends StatefulWidget {
  final AnimationController animationController;

  PremiumCarousel({
    Key? key,
    required this.animationController,
  }) : super(key: key);

  @override
  _PremiumCarouselState createState() => _PremiumCarouselState();
}

class _PremiumCarouselState extends State<PremiumCarousel> {
  late CarouselController _buttonCarouselController;

  @override
  void initState() {
    super.initState();
    _buttonCarouselController = CarouselController();
  }

  @override
  Widget build(
    BuildContext context,
  ) =>
      FutureBuilder<List<Screenshot>>(
        future: getScreenshots(),
        builder: (
          BuildContext context,
          AsyncSnapshot<List<Screenshot>> snapshot,
        ) {
          if (snapshot.hasError || !snapshot.hasData) {
            return Container();
          }

          return FadeTransition(
            opacity: widget.animationController,
            child: ScaleTransition(
              alignment: Alignment.center,
              scale: widget.animationController,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 80.0),
                    child: CarouselSlider(
                      items: snapshot.data!
                          .map((Screenshot screenshot) => NetworkImage(
                                getScreenshot(
                                  screenshot,
                                  themeMode:
                                      context.read<AppBloc>().state.themeMode,
                                  colorized:
                                      context.read<AppBloc>().state.colorTheme,
                                ),
                              ))
                          .map((NetworkImage image) => Image(image: image))
                          .toList(),
                      carouselController: _buttonCarouselController,
                      options: CarouselOptions(
                        aspectRatio: 0.75,
                        enlargeCenterPage: true,
                        enlargeStrategy: CenterPageEnlargeStrategy.height,
                        viewportFraction: 1.0,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 40.0,
                    child: _buildButton(
                      onPressed: () => _buttonCarouselController.previousPage(
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.linear,
                      ),
                      icon: Icons.arrow_back,
                    ),
                  ),
                  Positioned(
                    right: 40.0,
                    child: _buildButton(
                      onPressed: () => _buttonCarouselController.nextPage(
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.linear,
                      ),
                      icon: Icons.arrow_forward,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

  _buildButton({
    required IconData icon,
    required void Function()? onPressed,
  }) =>
      Material(
        color: Colors.transparent,
        child: CircleAvatar(
          backgroundColor: AppTheme.secondaryColor.withOpacity(0.7),
          radius: 20.0,
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(
              icon,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ),
      );
}
