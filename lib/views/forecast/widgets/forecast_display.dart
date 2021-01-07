import 'package:flutter/material.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/model.dart';
import 'package:flutter_weather/theme.dart';
import 'package:flutter_weather/utils/date_utils.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/forecast_utils.dart';
import 'package:flutter_weather/widgets/app_temperature_display.dart';
import 'package:weather_icons/weather_icons.dart';

class ForecastDisplay extends StatefulWidget {
  final AppBloc bloc;
  final Forecast forecast;

  ForecastDisplay({
    @required this.bloc,
    @required this.forecast,
  });

  @override
  _ForecastDisplayState createState() => _ForecastDisplayState();
}

class _ForecastDisplayState extends State<ForecastDisplay> {
  @override
  Widget build(
    BuildContext context,
  ) {
    List<ForecastDay> days = widget.forecast.list;
    ForecastDay currentDay = days.first;

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 40.0),
        child: Column(
          children: <Widget>[
            _buildLocation(),
            _buildCurrentTemperature(currentDay),
            _buildCondition(currentDay),
            _buildCurrentHiLow(currentDay),
            _buildForecastDetails(currentDay),
            _buildDays(days.getRange(1, 4).toList()), // Three day forecast
            _buildLastUpdated(),
          ],
        ),
      ),
    );
  }

  Widget _buildLocation() => Container(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Column(
          children: <Widget>[
            Text(
              widget.forecast.city.name.toUpperCase(),
              style: Theme.of(context).textTheme.headline3,
            ),
            Text(
              widget.forecast.city.country.toUpperCase(),
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ],
        ),
      );

  Widget _buildCurrentTemperature(
    ForecastDay currentDay,
  ) {
    ForecastDayWeather currentWeater = currentDay.weather.first;
    TemperatureUnit temperatureUnit = widget.bloc.state.temperatureUnit;

    return Container(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppTemperatureDisplay(
                temperature:
                    getTemperature(currentDay.temp.day, temperatureUnit)
                        .toString(),
                style: Theme.of(context).textTheme.headline1,
                unit: temperatureUnit,
              ),
              AppTemperatureDisplay(
                temperature: AppLocalizations.of(context).getFeelsLike(
                    getTemperature(currentDay.feelsLike.day, temperatureUnit)
                        .toString()),
                style: Theme.of(context).textTheme.headline5,
                unit: temperatureUnit,
                unitSizeFactor: 1.5,
              ),
            ],
          ),
          BoxedIcon(
            getForecastIconData(currentWeater.icon),
            size: 80.0,
          ),
        ],
      ),
    );
  }

  Widget _buildCondition(
    ForecastDay currentDay,
  ) =>
      Container(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Text(
          currentDay.weather.first.description.toUpperCase(),
          style: Theme.of(context).textTheme.headline4.copyWith(
                fontWeight: FontWeight.w300,
              ),
        ),
      );

  Widget _buildCurrentHiLow(
    ForecastDay currentDay,
  ) {
    TemperatureUnit temperatureUnit = widget.bloc.state.temperatureUnit;

    return Container(
      padding: const EdgeInsets.only(bottom: 20.0),
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
                    widget.bloc.state.themeMode,
                    colorTheme: widget.bloc.state.colorTheme,
                  ),
                  width: 1.0,
                ),
              ),
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    AppLocalizations.of(context).hi.toUpperCase(),
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                AppTemperatureDisplay(
                  temperature:
                      getTemperature(currentDay.temp.max, temperatureUnit)
                          .toString(),
                  style: Theme.of(context).textTheme.headline3,
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
                    AppLocalizations.of(context).low.toUpperCase(),
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                AppTemperatureDisplay(
                  temperature:
                      getTemperature(currentDay.temp.min, temperatureUnit)
                          .toString(),
                  style: Theme.of(context).textTheme.headline3,
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
                          AppLocalizations.of(context).wind,
                          style: Theme.of(context).textTheme.headline5.copyWith(
                                fontSize: 10.0,
                              ),
                        ),
                      ),
                      Text(
                        currentDay.speed.toString(),
                        style: Theme.of(context).textTheme.headline4.copyWith(
                              fontSize: 16.0,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                    width: 30.0,
                    child: RotationTransition(
                      turns: AlwaysStoppedAnimation(currentDay.deg / 360.0),
                      child: Icon(
                        Icons.navigation,
                        color: AppTheme.getHintColor(
                          widget.bloc.state.themeMode,
                          colorTheme: widget.bloc.state.colorTheme,
                        ),
                        size: 20.0,
                      ),
                    ),
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
                          AppLocalizations.of(context).pressure,
                          style: Theme.of(context).textTheme.headline5.copyWith(
                                fontSize: 10.0,
                              ),
                        ),
                      ),
                      Text(
                        currentDay.pressure.toString(),
                        style: Theme.of(context).textTheme.headline4.copyWith(
                              fontSize: 16.0,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                    width: 30.0,
                    child: BoxedIcon(
                      WeatherIcons.barometer,
                      size: 20.0,
                      color: AppTheme.getHintColor(
                        widget.bloc.state.themeMode,
                        colorTheme: widget.bloc.state.colorTheme,
                      ),
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
                          AppLocalizations.of(context).humidity,
                          style: Theme.of(context).textTheme.headline5.copyWith(
                                fontSize: 10.0,
                              ),
                        ),
                      ),
                      Text(
                        currentDay.humidity.toString(),
                        style: Theme.of(context).textTheme.headline4.copyWith(
                              fontSize: 16.0,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                    width: 30.0,
                    child: BoxedIcon(
                      WeatherIcons.humidity,
                      size: 20.0,
                      color: AppTheme.getHintColor(
                        widget.bloc.state.themeMode,
                        colorTheme: widget.bloc.state.colorTheme,
                      ),
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
    TemperatureUnit temperatureUnit = widget.bloc.state.temperatureUnit;

    int count = 0;
    List<Widget> _days = <Widget>[];

    days.forEach((ForecastDay day) {
      _days.add(
        Container(
          padding:
              EdgeInsets.only(right: (count + 1 == days.length) ? 0.0 : 20.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 2.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        formatDateTime(epochToDateTime(day.dt), 'EEE'),
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                    AppTemperatureDisplay(
                      temperature: getTemperature(day.temp.max, temperatureUnit)
                          .toString(),
                      style: Theme.of(context).textTheme.headline4,
                      unit: temperatureUnit,
                      unitSizeFactor: 2,
                    ),
                  ],
                ),
              ),
              BoxedIcon(
                getForecastIconData(day.weather.first.icon),
                size: 24.0,
                color: AppTheme.getHintColor(
                  widget.bloc.state.themeMode,
                  colorTheme: widget.bloc.state.colorTheme,
                ),
              ),
            ],
          ),
        ),
      );

      count++;
    });

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppTheme.getBorderColor(
              widget.bloc.state.themeMode,
              colorTheme: widget.bloc.state.colorTheme,
            ),
            width: 1.0,
          ),
        ),
      ),
      padding: const EdgeInsets.only(
        top: 20.0,
        bottom: 30.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _days,
      ),
    );
  }

  Widget _buildLastUpdated() {
    final DateTime lastUpdated = widget.forecast.lastUpdated.toLocal();
    if (lastUpdated == null) {
      return Container();
    }

    String formattedLastUpdated;

    if (lastUpdated.isToday()) {
      formattedLastUpdated = AppLocalizations.of(context)
          .getLastUpdatedAt(formatDateTime(lastUpdated, 'h:mm a'));
    } else {
      formattedLastUpdated = AppLocalizations.of(context).getLastUpdatedOn(
          formatDateTime(lastUpdated, 'EEE, MMM d, yyyy @ h:mm a'));
    }

    return Container(
      child: Text(
        formattedLastUpdated,
        style: Theme.of(context).textTheme.subtitle2,
      ),
    );
  }
}
