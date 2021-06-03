import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/enums/enums.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/models/models.dart';
import 'package:flutter_weather/views/forecast/forecast_utils.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_icon.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_meta_info.dart';
import 'package:weather_icons/weather_icons.dart';

class ForecastPressure extends StatelessWidget {
  final ForecastDay currentDay;

  const ForecastPressure({
    Key? key,
    required this.currentDay,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) =>
      Container(
        child: Row(
          children: [
            ForecastMetaInfo(
              label: AppLocalizations.of(context)!.pressure,
              value: getPressure(
                currentDay.pressure,
                context.read<AppBloc>().state.units.pressure,
              ).toString(),
              unit:
                  context.read<AppBloc>().state.units.pressure.getText(context),
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
      );
}
