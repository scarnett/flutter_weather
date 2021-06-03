import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/models/models.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_condition.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_current_temp.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_day_scroller.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_detail_display.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_divider.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_hi_lo.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_location.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_meta.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_sliver_header.dart';

class ForecastDisplay extends StatefulWidget {
  final Forecast forecast;
  final bool sliverView;
  final Color? forecastColor;
  final Color? forecastDarkenedColor;
  final bool detailsEnabled;

  ForecastDisplay({
    required this.forecast,
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
  double _headerHeight = 260.0;
  double _bottomFadeHeight = 75.0;
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
            ForecastCurrentTemp(currentDay: widget.forecast.list!.first),
            ForecastCondition(currentDay: currentDay),
            ForecastHiLo(currentDay: currentDay),
            ForecastDayScroller(forecast: widget.forecast),
            ForecastMeta(
              details: widget.forecast.details!,
              currentDay: currentDay,
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
                    parentContext: context,
                    forecastColor: widget.forecastColor,
                    forecast: widget.forecast,
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      _buildCurrentForecast(currentDay),
                      ForecastDivider(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                          left: 10.0,
                          right: 10.0,
                          bottom: 20.0,
                        ),
                      ),
                      ForecastDayScroller(forecast: widget.forecast),
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
                      _fadeColor.withOpacity(
                          (_bottomFadeOpacity < _fadeColor.opacity)
                              ? _bottomFadeOpacity
                              : _fadeColor.opacity),
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
          ForecastHiLo(currentDay: currentDay),
          ForecastMeta(
            details: widget.forecast.details!,
            currentDay: currentDay,
          ),
        ],
      );

  List<Widget> _buildDetailDisplay() {
    if (widget.detailsEnabled && (widget.forecast.details!.timezone != null)) {
      return [
        GestureDetector(
          onDoubleTap: () {
            _scrollController.animateTo(
              _headerHeight,
              duration: Duration(milliseconds: 150),
              curve: Curves.linear,
            );

            context
                .read<AppBloc>()
                .add(SetScrollDirection(ScrollDirection.reverse));
          },
          child: ForecastDetailDisplay(
            scrollController: _scrollController,
            forecast: widget.forecast,
            forecastColor: widget.forecastColor,
          ),
        ),
      ];
    }

    return [];
  }

  Color get _fadeColor {
    if (context.read<AppBloc>().state.colorTheme &&
        (widget.forecastDarkenedColor != null)) {
      return widget.forecastDarkenedColor!.withOpacity(0.925);
    }

    return Theme.of(context).appBarTheme.color!;
  }

  void _snapHeader({
    double? maxHeight,
    double minHeight: 0.0,
    double minDistance: 0.5,
  }) {
    final double scrollDistance = ((maxHeight ?? _headerHeight) - minHeight);
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
        context
            .read<AppBloc>()
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
