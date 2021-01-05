import 'package:flutter/material.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/theme.dart';
import 'package:flutter_weather/utils/date_utils.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/forecast_utils.dart';
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
            _buildCondition(currentDay),
            _buildTemperature(currentDay),
            _buildLastUpdated(),
          ],
        ),
      ),
    );
  }

  Widget _buildLocation() => Container(
        padding: const EdgeInsets.only(
          bottom: 30.0,
        ),
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

  Widget _buildCondition(
    ForecastDay currentDay,
  ) {
    ForecastDayWeather currentWeater = currentDay.weather.first;

    return Container(
      padding: const EdgeInsets.only(
        bottom: 10.0,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(
              currentWeater.main.toUpperCase(),
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          BoxedIcon(getForecastIconData(currentWeater.icon), size: 50.0),
        ],
      ),
    );
  }

  Widget _buildTemperature(
    ForecastDay currentDay,
  ) =>
      Container(
        child: Column(
          children: [
            Text(
              '${currentDay.temp.day.round()}\u00B0',
              style: Theme.of(context).textTheme.headline1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(right: 20.0),
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: AppTheme.getSecondaryColor(
                            widget.bloc.state.themeMode),
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context).hi.toUpperCase(),
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                      Text(
                        '${currentDay.temp.max.round()}\u00B0',
                        style: Theme.of(context).textTheme.headline6,
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
                      Text(
                        AppLocalizations.of(context).low.toUpperCase(),
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                      Text(
                        '${currentDay.temp.min.round()}\u00B0',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _buildLastUpdated() {
    final DateTime lastUpdated = widget.forecast.lastUpdated;
    if (lastUpdated == null) {
      return Container();
    }

    String formattedLastUpdated;

    if (lastUpdated.isToday()) {
      formattedLastUpdated =
          formatDateTime(widget.forecast.lastUpdated, 'h:mm a');
    } else {
      formattedLastUpdated = formatDateTime(
          widget.forecast.lastUpdated, 'EEE, MMM d, yyyy @ h:mm a');
    }

    return Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: Text(
        AppLocalizations.of(context).getLastUpdated(formattedLastUpdated),
        style: Theme.of(context).textTheme.subtitle2,
      ),
    );
  }
}
