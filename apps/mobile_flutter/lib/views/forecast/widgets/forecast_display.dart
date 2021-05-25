import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_weather/enums.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/theme.dart';
import 'package:flutter_weather/utils/common_utils.dart';
import 'package:flutter_weather/utils/date_utils.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/forecast_utils.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_current_temp.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_detail_display.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_icon.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_location.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_sliver_header.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_wind_direction.dart';
import 'package:flutter_weather/widgets/app_pageview_scroll_physics.dart';
import 'package:flutter_weather/widgets/app_temperature_display.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:weather_icons/weather_icons.dart';

class ForecastDisplay extends StatefulWidget {
  final TemperatureUnit temperatureUnit;
  final ThemeMode themeMode;
  final bool colorTheme;
  final Forecast forecast;
  final bool showSixDayForecast;
  final bool sliverView;
  final Color? forecastColor;
  final bool detailsEnabled;

  ForecastDisplay({
    required this.temperatureUnit,
    required this.themeMode,
    required this.forecast,
    this.colorTheme: false,
    this.showSixDayForecast: true,
    this.sliverView: true,
    this.forecastColor,
    this.detailsEnabled: true,
  });

  @override
  _ForecastDisplayState createState() => _ForecastDisplayState();
}

class _ForecastDisplayState extends State<ForecastDisplay> {
  PageController? _pageController;
  late ValueNotifier<int> _dayForecastsNotifier;

  @override
  void initState() {
    _pageController = PageController(keepPage: true)
      ..addListener(() {
        num? currentPage = _pageController!.page;

        if (isInteger(currentPage)) {
          _dayForecastsNotifier.value = currentPage!.toInt();
        }
      });

    _dayForecastsNotifier = ValueNotifier<int>(0);
    super.initState();
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
          ? _buildSliverContent(days, currentDay)
          : _buildNormalContent(days, currentDay),
    );
  }

  Widget _buildNormalContent(
    List<ForecastDay> days,
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
              _buildCondition(currentDay),
              _buildCurrentHiLow(currentDay),
              _buildForecastDetails(currentDay),
              _buildDays(days.toList()),
              _buildDayForecastsCircleIndicator(
                themeMode: widget.themeMode,
                colorTheme: widget.colorTheme,
                days: days.toList(),
              ),
              if (widget.detailsEnabled &&
                  (widget.forecast.details!.timezone != null))
                ForecastDetailDisplay(
                  forecast: widget.forecast,
                  themeMode: widget.themeMode,
                  colorTheme: widget.colorTheme,
                ),
            ],
          ),
        ),
      );

  Widget _buildSliverContent(
    List<ForecastDay> days,
    ForecastDay currentDay,
  ) =>
      CustomScrollView(
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
                  _buildDays(days.toList()),
                  _buildDayForecastsCircleIndicator(
                    themeMode: widget.themeMode,
                    colorTheme: widget.colorTheme,
                    days: days.toList(),
                  ),
                  if (widget.detailsEnabled &&
                      (widget.forecast.details!.timezone != null))
                    ForecastDetailDisplay(
                      forecast: widget.forecast,
                      themeMode: widget.themeMode,
                      colorTheme: widget.colorTheme,
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
          _buildCondition(currentDay),
          _buildCurrentHiLow(currentDay),
          _buildForecastDetails(currentDay),
        ],
      );

  Widget _buildCondition(
    ForecastDay currentDay,
  ) =>
      Container(
        padding: const EdgeInsets.only(bottom: 20.0, top: 10.0),
        child: Text(
          currentDay.weather!.first.description!.toUpperCase(),
          style: Theme.of(context).textTheme.headline4!.copyWith(
                fontWeight: FontWeight.w300,
              ),
        ),
      );

  Widget _buildCurrentHiLow(
    ForecastDay currentDay,
  ) {
    TemperatureUnit temperatureUnit = widget.temperatureUnit;

    return Container(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(right: 20.0),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: AppTheme.getBorderColor(
                    widget.themeMode,
                    colorTheme: widget.colorTheme,
                  ),
                  width: 2.0,
                ),
              ),
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    AppLocalizations.of(context)!.hi.toUpperCase(),
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                AppTemperatureDisplay(
                  temperature:
                      getTemperature(currentDay.temp!.max, temperatureUnit)
                          .toString(),
                  style: Theme.of(context)
                      .textTheme
                      .headline3!
                      .copyWith(height: 0.85),
                  unit: temperatureUnit,
                  unitSizeFactor: 2.5,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 20.0,
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    AppLocalizations.of(context)!.low.toUpperCase(),
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                AppTemperatureDisplay(
                  temperature:
                      getTemperature(currentDay.temp!.min, temperatureUnit)
                          .toString(),
                  style: Theme.of(context)
                      .textTheme
                      .headline3!
                      .copyWith(height: 0.85),
                  unit: temperatureUnit,
                  unitSizeFactor: 2.5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForecastDetails(
    ForecastDay currentDay,
  ) =>
      Container(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 20.0),
              child: Row(
                children: [
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          AppLocalizations.of(context)!.wind,
                          style:
                              Theme.of(context).textTheme.headline5!.copyWith(
                                    fontSize: 10.0,
                                  ),
                        ),
                      ),
                      Text(
                        currentDay.speed.toString(),
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                              fontSize: 16.0,
                            ),
                      ),
                    ],
                  ),
                  StreamBuilder<CompassEvent>(
                    stream: FlutterCompass.events,
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<CompassEvent> snapshot,
                    ) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child:
                                Icon(Icons.close, color: AppTheme.dangerColor),
                          ),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        if (currentDay.deg != null) {
                          return SizedBox(
                            height: 20.0,
                            width: 30.0,
                            child: ForecastWindDirection(
                              degree: getWindDirection(
                                windDirection: currentDay.deg ?? 0,
                              ),
                              size: 20.0,
                            ),
                          );
                        }

                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: SizedBox(
                              height: 10.0,
                              width: 10.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  (widget.themeMode == ThemeMode.dark) ||
                                          widget.colorTheme
                                      ? Colors.white
                                      : AppTheme.primaryColor,
                                ),
                              ),
                            ),
                          ),
                        );
                      }

                      return SizedBox(
                        height: 20.0,
                        width: 30.0,
                        child: ForecastWindDirection(
                          degree: getWindDirection(
                            windDirection: currentDay.deg ?? 0,
                            heading: snapshot.data!.heading ?? 0,
                          ),
                          size: 20.0,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 20.0),
              child: Row(
                children: [
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          AppLocalizations.of(context)!.pressure,
                          style:
                              Theme.of(context).textTheme.headline5!.copyWith(
                                    fontSize: 10.0,
                                  ),
                        ),
                      ),
                      Text(
                        currentDay.pressure.toString(),
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                              fontSize: 16.0,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                    width: 30.0,
                    child: ForecastIcon(
                      iconSize: 20.0,
                      icon: WeatherIcons.barometer,
                      shadowColor: Colors.black26,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                children: [
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          AppLocalizations.of(context)!.humidity,
                          style:
                              Theme.of(context).textTheme.headline5!.copyWith(
                                    fontSize: 10.0,
                                  ),
                        ),
                      ),
                      Text(
                        currentDay.humidity.toString(),
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                              fontSize: 16.0,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                    width: 30.0,
                    child: ForecastIcon(
                      iconSize: 20.0,
                      icon: WeatherIcons.humidity,
                      shadowColor: Colors.black26,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _buildDays(
    List<ForecastDay> days,
  ) {
    if (!widget.showSixDayForecast) {
      return Container();
    }

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppTheme.getBorderColor(
              widget.themeMode,
              colorTheme: widget.colorTheme,
            ),
            width: 2.0,
          ),
        ),
      ),
      padding: const EdgeInsets.only(
        top: 20.0,
        bottom: 10.0,
      ),
      child: Container(
        width: double.infinity,
        height: 60.0,
        child: PageView(
          controller: _pageController,
          physics: const AppPageViewScrollPhysics(),
          children: _buildDayForecasts(days.toList()),
        ),
      ),
    );
  }

  List<Widget> _buildDayForecasts(
    List<ForecastDay> days, {
    int count: 3, // TODO! parameter?
  }) {
    int index = 0;
    List<Widget> forecasts = [];

    days.forEach((ForecastDay day) {
      if (index % count == 0) {
        int start = (index + 1);
        int end = ((index + 1) + 3);
        if (end > days.length) {
          end = days.length;
        }

        List<ForecastDay> _days = days.getRange(start, end).toList();
        if (_days.isNotEmpty) {
          forecasts.add(_buildDayForecast(days.getRange(start, end).toList()));
        }
      }

      index++;
    });

    return forecasts;
  }

  _buildDayForecastsCircleIndicator({
    required ThemeMode themeMode,
    required bool colorTheme,
    List<ForecastDay>? days,
    int dayCount: 3, // TODO! parameter?
  }) {
    if (!widget.showSixDayForecast) {
      return Container();
    }

    int pageCount = 0;

    if (days == null) {
      return Container();
    } else {
      pageCount = (days.length / dayCount).round();
      if (pageCount <= 1) {
        return Container();
      }
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: CirclePageIndicator(
          size: 4.0,
          dotColor: AppTheme.getHintColor(themeMode),
          selectedDotColor: colorTheme ? Colors.white : AppTheme.primaryColor,
          selectedSize: 6.0,
          itemCount: pageCount,
          currentPageNotifier: _dayForecastsNotifier,
          onPageSelected: _onPageSelected,
        ),
      ),
    );
  }

  void _onPageSelected(
    int page,
  ) {
    _dayForecastsNotifier.value = page;
    animatePage(_pageController!, page: page);
  }

  Widget _buildDayForecast(
    List<ForecastDay> days,
  ) {
    int count = 0;
    TemperatureUnit temperatureUnit = widget.temperatureUnit;
    List<Widget> dayList = <Widget>[];

    days.forEach((ForecastDay day) {
      dayList.add(
        Container(
          padding:
              EdgeInsets.only(right: (count + 1 == days.length) ? 0.0 : 20.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(
                        formatDateTime(epochToDateTime(day.dt!), 'EEE')!,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Text(
                        getMonthDay(epochToDateTime(day.dt!)),
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                              fontSize: 8.0,
                              color: AppTheme.getFadedTextColor(
                                colorTheme: widget.colorTheme,
                              ),
                            ),
                      ),
                    ),
                    AppTemperatureDisplay(
                      temperature:
                          getTemperature(day.temp!.max, temperatureUnit)
                              .toString(),
                      style: Theme.of(context).textTheme.headline4,
                      unit: temperatureUnit,
                      unitSizeFactor: 2,
                    ),
                  ],
                ),
              ),
              ForecastIcon(
                iconSize: 24.0,
                icon: getForecastIconData(day.weather!.first.icon),
                shadowColor: Colors.black26,
              ),
            ],
          ),
        ),
      );

      count++;
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: dayList,
    );
  }
}
