import 'package:flutter/material.dart';
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
  final ThemeMode themeMode;
  final bool colorTheme;
  final Forecast forecast;
  final bool sliverView;
  final Color? forecastColor;
  final bool detailsEnabled;

  ForecastDisplay({
    required this.temperatureUnit,
    required this.themeMode,
    required this.forecast,
    this.colorTheme: false,
    this.sliverView: true,
    this.forecastColor,
    this.detailsEnabled: true,
  });

  @override
  _ForecastDisplayState createState() => _ForecastDisplayState();
}

class _ForecastDisplayState extends State<ForecastDisplay> {
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
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
      Padding(
        padding: const EdgeInsets.only(
          left: 10.0,
          right: 10.0,
        ),
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
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
              if (widget.detailsEnabled &&
                  (widget.forecast.details!.timezone != null))
                ForecastDetailDisplay(
                  scrollController: _scrollController,
                  forecast: widget.forecast,
                  themeMode: widget.themeMode,
                  colorTheme: widget.colorTheme,
                  temperatureUnit: widget.temperatureUnit,
                ),
            ],
          ),
        ),
      );

  Widget _buildSliverContent(
    ForecastDay currentDay,
  ) =>
      CustomScrollView(
        controller: _scrollController,
        physics: ClampingScrollPhysics(),
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
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  _buildCurrentForecast(currentDay),
                  ForecastDayScroller(
                    forecast: widget.forecast,
                    themeMode: widget.themeMode,
                    colorTheme: widget.colorTheme,
                    temperatureUnit: widget.temperatureUnit,
                  ),
                  if (widget.detailsEnabled &&
                      (widget.forecast.details!.timezone != null))
                    ForecastDetailDisplay(
                      scrollController: _scrollController,
                      forecast: widget.forecast,
                      themeMode: widget.themeMode,
                      colorTheme: widget.colorTheme,
                      temperatureUnit: widget.temperatureUnit,
                    ),
                ],
              ),
            ),
          ),
        ],
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
}
