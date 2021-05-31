import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/enums.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_condition.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_current_temp.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_day_scroller.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_detail_display.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_hi_lo.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_location.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_meta_row.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_sliver_header.dart';

class ForecastDisplay extends StatefulWidget {
  final TemperatureUnit temperatureUnit;
  final ChartType chartType;
  final ThemeMode themeMode;
  final bool colorTheme;
  final Forecast forecast;
  final bool sliverView;
  final Color? forecastColor;
  final Color? forecastDarkenedColor;
  final bool detailsEnabled;

  ForecastDisplay({
    required this.temperatureUnit,
    required this.chartType,
    required this.themeMode,
    required this.forecast,
    this.colorTheme: false,
    this.sliverView: true,
    this.forecastColor,
    this.forecastDarkenedColor,
    this.detailsEnabled: true,
  });

  @override
  _ForecastDisplayState createState() => _ForecastDisplayState();
}

class _ForecastDisplayState extends State<ForecastDisplay> {
  late ScrollController _scrollController;
  double _bottomFadeHeight = 50.0;
  double _bottomFadeOpacity = 1.0;

  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() => _setBottomFadeMargin());

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    List<ForecastDay> days = widget.forecast.list!;
    ForecastDay currentDay = days.first;

    return Align(
      alignment: Alignment.topCenter,
      child: widget.sliverView
          ? _buildSliverContent(currentDay)
          : _buildNormalContent(currentDay),
    );
  }

  Widget _buildNormalContent(
    ForecastDay currentDay,
  ) =>
      SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: <Widget>[
            ForecastLocation(forecast: widget.forecast),
            SizedBox(height: 10.0),
            ForecastCurrentTemp(
              currentDay: widget.forecast.list!.first,
              temperatureUnit: widget.temperatureUnit,
            ),
            ForecastCondition(currentDay: currentDay),
            ForecastHiLo(
              currentDay: currentDay,
              themeMode: widget.themeMode,
              colorTheme: widget.colorTheme,
              temperatureUnit: widget.temperatureUnit,
            ),
            ForecastMetaRow(
              currentDay: currentDay,
              themeMode: widget.themeMode,
              colorTheme: widget.colorTheme,
            ),
            ForecastDayScroller(
              forecast: widget.forecast,
              themeMode: widget.themeMode,
              colorTheme: widget.colorTheme,
              temperatureUnit: widget.temperatureUnit,
            ),
          ]..addAll(_buildDetailDisplay()),
        ),
      );

  Widget _buildSliverContent(
    ForecastDay currentDay,
  ) =>
      NotificationListener<ScrollEndNotification>(
        onNotification: (ScrollEndNotification notification) {
          _snapHeader();
          return false;
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomScrollView(
              controller: _scrollController,
              physics: const ClampingScrollPhysics(),
              slivers: <Widget>[
                SliverPersistentHeader(
                  pinned: true,
                  floating: false,
                  delegate: ForecastSliverHeader(
                    context: context,
                    forecastColor: widget.forecastColor,
                    temperatureUnit: widget.temperatureUnit,
                    colorTheme: widget.colorTheme,
                    forecast: widget.forecast,
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      _buildCurrentForecast(currentDay),
                      ForecastDayScroller(
                        forecast: widget.forecast,
                        themeMode: widget.themeMode,
                        colorTheme: widget.colorTheme,
                        temperatureUnit: widget.temperatureUnit,
                      ),
                    ]..addAll(_buildDetailDisplay()),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      _fadeColor.withOpacity(_bottomFadeOpacity),
                      _fadeColor.withOpacity(0.0),
                    ],
                    stops: [0.0, 1.0],
                  ),
                ),
                height: _bottomFadeHeight,
                margin: EdgeInsets.only(
                  bottom: (Platform.isIOS)
                      ? 0.0
                      : MediaQuery.of(context).padding.bottom,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildCurrentForecast(
    ForecastDay currentDay,
  ) =>
      Column(
        children: <Widget>[
          ForecastCondition(currentDay: currentDay),
          ForecastHiLo(
            currentDay: currentDay,
            themeMode: widget.themeMode,
            colorTheme: widget.colorTheme,
            temperatureUnit: widget.temperatureUnit,
          ),
          ForecastMetaRow(
            currentDay: currentDay,
            themeMode: widget.themeMode,
            colorTheme: widget.colorTheme,
          ),
        ],
      );

  List<Widget> _buildDetailDisplay() {
    if (widget.detailsEnabled && (widget.forecast.details!.timezone != null)) {
      return [
        ForecastDetailDisplay(
          scrollController: _scrollController,
          forecast: widget.forecast,
          themeMode: widget.themeMode,
          colorTheme: widget.colorTheme,
          temperatureUnit: widget.temperatureUnit,
          chartType: widget.chartType,
          forecastColor: widget.forecastColor,
        ),
      ];
    }

    return [];
  }

  Color get _fadeColor {
    if (widget.colorTheme && (widget.forecastDarkenedColor != null)) {
      return widget.forecastDarkenedColor!;
    }

    return Theme.of(context).scaffoldBackgroundColor;
  }

  void _snapHeader({
    double maxHeight: 260.0,
    double minHeight: 0.0,
    double minDistance: 0.5,
  }) {
    final double scrollDistance = (maxHeight - minHeight);
    if ((_scrollController.offset > 0.0) &&
        (_scrollController.offset < scrollDistance)) {
      final double snapOffset =
          ((_scrollController.offset / scrollDistance) > minDistance)
              ? scrollDistance
              : 0.0;

      Future.microtask(() => _scrollController.animateTo(
            snapOffset,
            duration: Duration(milliseconds: 250),
            curve: Curves.easeIn,
          ));

      if (snapOffset == 0.0) {
        BlocProvider.of<AppBloc>(context, listen: false)
            .add(SetScrollDirection(ScrollDirection.forward));
      }
    }
  }

  void _setBottomFadeMargin({
    maxHeight: 50.0,
  }) {
    double maxScroll = _scrollController.position.maxScrollExtent;
    double currentScroll = _scrollController.position.pixels;
    if ((maxScroll - currentScroll) <= maxHeight) {
      double deltaPercent =
          ((maxHeight + (maxScroll - currentScroll)) - maxHeight);

      setState(() {
        _bottomFadeHeight =
            (maxScroll - currentScroll).clamp(0.0, maxHeight).toDouble();

        _bottomFadeOpacity = (1.0 -
                ((deltaPercent - maxHeight) /
                    (deltaPercent + maxHeight) *
                    -1.0))
            .clamp(0.0, 1.0);
      });
    } else {
      setState(() {
        _bottomFadeHeight = maxHeight;
        _bottomFadeOpacity = 1.0;
      });
    }
  }
}
