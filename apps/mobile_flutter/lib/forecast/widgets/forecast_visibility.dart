import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/app/app_localization.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';
import 'package:flutter_weather/enums/enums.dart';
import 'package:flutter_weather/forecast/forecast.dart';
import 'package:flutter_weather/models/models.dart';
import 'package:weather_icons/weather_icons.dart';

class ForecastVisibility extends StatelessWidget {
  final ForecastDetails details;

  const ForecastVisibility({
    Key? key,
    required this.details,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) =>
      Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ForecastMetaInfo(
              label: AppLocalizations.of(context)!.visibility,
              value: (details.current == null)
                  ? '0'
                  : getDistance(
                      details.current!.visibility,
                      context.read<AppBloc>().state.units.distance,
                    ).toString(),
              unit:
                  context.read<AppBloc>().state.units.distance.getText(context),
            ),
            SizedBox(
              height: 30.0,
              width: 30.0,
              child: ForecastIcon(
                iconSize: 20.0,
                icon: WeatherIcons.horizon,
                shadowColor: Colors.black26,
              ),
            ),
          ],
        ),
      );
}
