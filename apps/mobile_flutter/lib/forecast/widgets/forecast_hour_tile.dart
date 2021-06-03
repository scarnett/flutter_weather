import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/app/utils/common_utils.dart';
import 'package:flutter_weather/app/widgets/app_temperature_display.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/forecast/forecast.dart';
import 'package:flutter_weather/models/models.dart';

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
                temperature: getTemperature(hour.temp, state.units.temperature)
                    .toString(),
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
            getWindSpeedText(context, hour.windSpeed, state.units.windSpeed),
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
