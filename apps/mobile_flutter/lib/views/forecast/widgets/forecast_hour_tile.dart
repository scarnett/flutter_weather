import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/utils/common_utils.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/forecast_utils.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_hour_display.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_icon.dart';
import 'package:flutter_weather/widgets/app_temperature_display.dart';

class ForecastHourTile extends StatelessWidget {
  final ForecastHour hour;

  ForecastHourTile({
    required this.hour,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    AppState state = context.read<AppBloc>().state;
    return ListTile(
      key: Key(hour.dt.toString()),
      dense: true,
      contentPadding: const EdgeInsets.all(0.0),
      horizontalTitleGap: 0.0,
      leading: Container(
        width: 70.0,
        child: Align(
          alignment: Alignment.centerLeft,
          child: ForecastHourDisplay(hour: hour),
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Center(
            child: ForecastIcon(
              containerSize: 30.0,
              iconSize: 20.0,
              icon: getForecastIconData(
                (hour.weather == null) ? null : hour.weather!.first.icon,
              ),
              shadowColor: Colors.black26,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: AppTemperatureDisplay(
                temperature:
                    getTemperature(hour.temp, state.temperatureUnit).toString(),
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      shadows: state.colorTheme ? commonTextShadow() : null,
                    ),
                unitSizeFactor: 1.5,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                getHumidity(hour.humidity),
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      shadows: state.colorTheme ? commonTextShadow() : null,
                    ),
              ),
            ),
          ),
        ],
      ),
      trailing: Container(
        width: 70.0,
        child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            getWind(hour.windSpeed),
            style: Theme.of(context).textTheme.headline5!.copyWith(
                  shadows: state.colorTheme ? commonTextShadow() : null,
                ),
          ),
        ),
      ),
      onTap: null,
    );
  }
}
