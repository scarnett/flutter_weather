import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_weather/app/app_config.dart';
import 'package:flutter_weather/app/app_localization.dart';
import 'package:flutter_weather/app/app_theme.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';
import 'package:flutter_weather/app/widgets/widgets.dart';
import 'package:flutter_weather/enums/enums.dart';
import 'package:flutter_weather/forecast/forecast.dart';
import 'package:flutter_weather/models/models.dart';

class ForecastWindSpeed extends StatefulWidget {
  final ForecastDay currentDay;

  ForecastWindSpeed({
    Key? key,
    required this.currentDay,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ForecastWindSpeedState();
}

class _ForecastWindSpeedState extends State<ForecastWindSpeed> {
  @override
  Widget build(
    BuildContext context,
  ) =>
      Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ForecastMetaInfo(
              label: AppLocalizations.of(context)!.wind,
              value: getWindSpeed(
                widget.currentDay.speed,
                context.read<AppBloc>().state.units.windSpeed,
              ).toString(),
              unit: context
                  .read<AppBloc>()
                  .state
                  .units
                  .windSpeed
                  .getText(context),
            ),
            StreamBuilder<CompassEvent>(
              stream: FlutterCompass.events,
              builder: (
                BuildContext context,
                AsyncSnapshot<CompassEvent> snapshot,
              ) {
                if (snapshot.hasError || AppConfig.isDebug()) {
                  return _buildWindDirection();
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child: AppProgressIndicator(color: AppTheme.primaryColor),
                  );
                }

                double? heading = snapshot.data!.heading;

                // If heading is null then this device does not have the
                // required sensors
                if (heading == null) {
                  return _buildWindDirection();
                }

                return _buildWindDirection(heading: heading);
              },
            ),
          ],
        ),
      );

  Widget _buildWindDirection({
    double? heading,
  }) =>
      SizedBox(
        height: 20.0,
        width: 30.0,
        child: ForecastWindDirection(
          degree: getWindDirection(
            windDirection: widget.currentDay.deg ?? 0.0,
            heading: heading ?? 0.0,
          ),
          size: 20.0,
        ),
      );
}
