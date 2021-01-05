import 'package:flutter/material.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/model.dart';
import 'package:flutter_weather/theme.dart';
import 'package:flutter_weather/utils/date_utils.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/forecast_utils.dart';
import 'package:flutter_weather/views/forecast/widgets/temperature_display.dart';
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
    ForecastDay currentDay = widget.forecast.list.first;

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Column(
          children: <Widget>[
            _buildLocation(),
            _buildCurrentTemperature(currentDay),
            _buildCondition(currentDay),
            _buildCurrentDayNight(currentDay),
            _buildLastUpdated(),
          ],
        ),
      ),
    );
  }

  Widget _buildLocation() => Container(
        padding: const EdgeInsets.only(bottom: 30.0),
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
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TemperatureDisplay(
                temperature:
                    getTemperature(currentDay.temp.day, temperatureUnit)
                        .toString(),
                style: Theme.of(context).textTheme.headline1,
                unit: temperatureUnit,
              ),
              TemperatureDisplay(
                temperature: AppLocalizations.of(context).getFeelsLike(
                    getTemperature(currentDay.feelsLike.day, temperatureUnit)
                        .toString()),
                style: Theme.of(context).textTheme.headline5,
                unit: temperatureUnit,
                unitSizeFactor: 1.5,
              ),
            ],
          ),
          BoxedIcon(getForecastIconData(currentWeater.icon), size: 70.0),
        ],
      ),
    );
  }

  Widget _buildCondition(
    ForecastDay currentDay,
  ) =>
      Container(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: Text(
          currentDay.weather.first.main.toUpperCase(),
          style: Theme.of(context).textTheme.headline4,
        ),
      );

  Widget _buildCurrentDayNight(
    ForecastDay currentDay,
  ) {
    TemperatureUnit temperatureUnit = widget.bloc.state.temperatureUnit;

    return Container(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(right: 20.0),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color:
                      AppTheme.getSecondaryColor(widget.bloc.state.themeMode),
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
                TemperatureDisplay(
                  temperature:
                      getTemperature(currentDay.temp.max, temperatureUnit)
                          .toString(),
                  style: Theme.of(context).textTheme.headline3,
                  unit: temperatureUnit,
                  unitSizeFactor: 2.0,
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
                TemperatureDisplay(
                  temperature:
                      getTemperature(currentDay.temp.min, temperatureUnit)
                          .toString(),
                  style: Theme.of(context).textTheme.headline3,
                  unit: temperatureUnit,
                  unitSizeFactor: 2.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLastUpdated() {
    final DateTime lastUpdated = widget.forecast.lastUpdated;
    if (lastUpdated == null) {
      return Container();
    }

    String formattedLastUpdated;

    if (lastUpdated.isToday()) {
      formattedLastUpdated = AppLocalizations.of(context)
          .getLastUpdatedAt(formatDateTime(lastUpdated.toLocal(), 'h:mm a'));
    } else {
      formattedLastUpdated = AppLocalizations.of(context).getLastUpdatedOn(
          formatDateTime(lastUpdated.toLocal(), 'EEE, MMM d, yyyy @ h:mm a'));
    }

    return Container(
      child: Text(
        formattedLastUpdated,
        style: Theme.of(context).textTheme.subtitle2,
      ),
    );
  }
}
