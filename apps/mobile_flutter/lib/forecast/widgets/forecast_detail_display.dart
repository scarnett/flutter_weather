import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';
import 'package:flutter_weather/forecast/forecast.dart';
import 'package:flutter_weather/models/models.dart';

class ForecastDetailDisplay extends StatefulWidget {
  final ScrollController scrollController;
  final Forecast forecast;
  final Color? forecastColor;

  ForecastDetailDisplay({
    required this.scrollController,
    required this.forecast,
    this.forecastColor,
  });

  @override
  _ForecastDetailDisplayState createState() => _ForecastDetailDisplayState();
}

class _ForecastDetailDisplayState extends State<ForecastDetailDisplay> {
  double _scrollOffset = 0.2;
  VoidCallback? _scrollListener;
  ScrollDirection? _scrollDirection;

  @override
  void initState() {
    super.initState();

    _scrollListener = () {
      setState(() {
        _scrollOffset = getScrollProgress(
          shrinkOffset: widget.scrollController.offset,
          minExtent: 0.0,
          maxExtent: 50.0,
          clampLower: 0.2,
          speed: 2.0,
        );

        if (_scrollDirection !=
            widget.scrollController.position.userScrollDirection) {
          _scrollDirection =
              widget.scrollController.position.userScrollDirection;

          context.read<AppBloc>().add(SetScrollDirection(_scrollDirection!));
        }
      });
    };

    widget.scrollController..addListener(_scrollListener!);
  }

  @override
  void dispose() {
    if (_scrollListener != null) {
      widget.scrollController.removeListener(_scrollListener!);
    }

    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) =>
      Opacity(
        opacity: _scrollOffset,
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 260.0,
                child: ForecastDayCharts(
                  forecast: widget.forecast,
                  forecastColor: widget.forecastColor,
                  enabled: chartsEnabled,
                ),
              ),
              ForecastDivider(
                padding: const EdgeInsets.only(
                  left: 10.0,
                  right: 10.0,
                  bottom: 20.0,
                  top: 10.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ForecastHours(
                  parentScrollController: widget.scrollController,
                  forecast: widget.forecast,
                  forecastColor: widget.forecastColor,
                ),
              ),
            ],
          ),
        ),
      );

  get chartsEnabled =>
      (_scrollOffset == 1.0); // (_scrollDirection == ScrollDirection.idle);
}
