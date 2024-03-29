import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/app/app_theme.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';
import 'package:flutter_weather/app/utils/utils.dart';
import 'package:flutter_weather/app/widgets/widgets.dart';
import 'package:flutter_weather/forecast/forecast.dart';
import 'package:flutter_weather/models/models.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class ForecastDayScroller extends StatefulWidget {
  final Forecast forecast;

  const ForecastDayScroller({
    Key? key,
    required this.forecast,
  }) : super(key: key);

  @override
  _ForecastDayScrollerState createState() => _ForecastDayScrollerState();
}

class _ForecastDayScrollerState extends State<ForecastDayScroller> {
  late PageController _pageController;
  late ValueNotifier<int> _dayForecastsNotifier;

  @override
  void initState() {
    _pageController = PageController(keepPage: true)
      ..addListener(() {
        num? currentPage = _pageController.page;
        if (isInteger(currentPage)) {
          _dayForecastsNotifier.value = currentPage!.toInt();
        }
      });

    _dayForecastsNotifier = ValueNotifier<int>(0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _dayForecastsNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) =>
      Column(
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Container(
              height: 66.0,
              child: PageView(
                controller: _pageController,
                physics: const AppPageViewScrollPhysics(),
                children: _buildDayForecasts(
                  context,
                  widget.forecast.list!.toList(),
                ),
              ),
            ),
          ),
          _buildDayForecastsCircleIndicator(
            days: widget.forecast.list!.toList(),
          ),
        ],
      );

  List<Widget> _buildDayForecasts(
    BuildContext context,
    List<ForecastDay> days, {
    int count: 3, // TODO! parameter?
  }) {
    int index = 0;
    List<Widget> forecasts = [];

    days.forEach((ForecastDay day) {
      if ((index % count) == 0) {
        int start = (index + 1);
        int end = ((index + 1) + 3);
        if (end > days.length) {
          end = days.length;
        }

        List<ForecastDay> _days = days.getRange(start, end).toList();
        if (_days.isNotEmpty) {
          forecasts.add(_buildDayForecast(
            context,
            days.getRange(start, end).toList(),
          ));
        }
      }

      index++;
    });

    return forecasts;
  }

  Widget _buildDayForecast(
    BuildContext context,
    List<ForecastDay> days,
  ) {
    AppState state = context.read<AppBloc>().state;
    int count = 0;
    List<Widget> dayList = <Widget>[];

    days.forEach((ForecastDay day) {
      dayList.add(
        Container(
          padding:
              EdgeInsets.only(right: (count + 1 == days.length) ? 0.0 : 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 4.0, top: 4.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(
                        formatEpoch(epoch: day.dt!, format: 'EEE')!,
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
                                colorTheme: state.colorTheme,
                              ),
                            ),
                      ),
                    ),
                    AppTemperatureDisplay(
                      temperature:
                          getTemperature(day.temp!.max, state.units.temperature)
                              .toString(),
                      style: Theme.of(context).textTheme.headline4,
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

  Widget _buildDayForecastsCircleIndicator({
    List<ForecastDay>? days,
    int dayCount: 3, // TODO! parameter?
  }) {
    AppState state = context.read<AppBloc>().state;
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
          dotColor: AppTheme.getBorderColor(
            state.themeMode,
            colorTheme: state.colorTheme,
          ),
          selectedDotColor:
              state.colorTheme ? Colors.white : AppTheme.primaryColor,
          selectedSize: 6.0,
          itemCount: pageCount,
          currentPageNotifier: _dayForecastsNotifier,
          onPageSelected: (int page) async => await _onPageSelected(page),
        ),
      ),
    );
  }

  Future<void> _onPageSelected(
    int page,
  ) async {
    _dayForecastsNotifier.value = page;
    await animatePage(_pageController, page: page);
  }
}
