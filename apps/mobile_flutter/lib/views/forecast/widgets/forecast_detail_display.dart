import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/enums.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/forecast_utils.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_divider.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_hours.dart';

class ForecastDetailDisplay extends StatefulWidget {
  final ScrollController scrollController;
  final Forecast forecast;
  final ThemeMode themeMode;
  final bool colorTheme;
  final TemperatureUnit temperatureUnit;

  ForecastDetailDisplay({
    required this.scrollController,
    required this.forecast,
    required this.themeMode,
    this.colorTheme: false,
    required this.temperatureUnit,
  });

  @override
  _ForecastDetailDisplayState createState() => _ForecastDetailDisplayState();
}

class _ForecastDetailDisplayState extends State<ForecastDetailDisplay> {
  double scrollOffset = 0.2;
  VoidCallback? _scrollListener;
  ScrollDirection? _scrollDirection;

  @override
  void initState() {
    super.initState();

    _scrollListener = () {
      setState(() {
        scrollOffset = getScrollProgress(
          shrinkOffset: widget.scrollController.offset,
          minExtent: 0.0,
          maxExtent: 50.0,
          clampLower: 0.2,
          speed: 2.0,
        );
      });

      if (_scrollDirection !=
          widget.scrollController.position.userScrollDirection) {
        _scrollDirection = widget.scrollController.position.userScrollDirection;

        BlocProvider.of<AppBloc>(context, listen: false)
            .add(SetScrollDirection(_scrollDirection!));
      }
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
        opacity: scrollOffset,
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom,
          ),
          child: Column(
            children: [
              ForecastDivider(
                themeMode: widget.themeMode,
                colorTheme: widget.colorTheme,
                padding: const EdgeInsets.only(bottom: 10.0),
              ),
              ForecastHours(
                forecast: widget.forecast,
                temperatureUnit: widget.temperatureUnit,
                themeMode: widget.themeMode,
                colorTheme: widget.colorTheme,
              ),
            ],
          ),
        ),
      );
}
