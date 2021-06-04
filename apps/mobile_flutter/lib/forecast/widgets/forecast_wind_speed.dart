import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_weather/app/app_config.dart';
import 'package:flutter_weather/app/app_localization.dart';
import 'package:flutter_weather/app/app_theme.dart';
import 'package:flutter_weather/app/widgets/widgets.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/enums/enums.dart';
import 'package:flutter_weather/forecast/forecast.dart';
import 'package:flutter_weather/models/models.dart';

class ForecastWindSpeed extends StatelessWidget {
  final ForecastDay currentDay;

  const ForecastWindSpeed({
    Key? key,
    required this.currentDay,
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
              label: AppLocalizations.of(context)!.wind,
              value: getWindSpeed(
                currentDay.speed,
                context.read<AppBloc>().state.units.windSpeed,
              ).toString(),
              unit: context
                  .read<AppBloc>()
                  .state
                  .units
                  .windSpeed
                  .getText(context),
            ),
            AppConfig.isRelease()
                ? StreamBuilder<CompassEvent>(
                    stream: FlutterCompass.events,
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<CompassEvent> snapshot,
                    ) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Icon(
                              Icons.close,
                              color: AppTheme.dangerColor,
                            ),
                          ),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        if (currentDay.deg != null) {
                          return _buildWindDirection();
                        }

                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: SizedBox(
                              height: 10.0,
                              width: 10.0,
                              child: AppProgressIndicator(),
                            ),
                          ),
                        );
                      }

                      return _buildWindDirection(
                        heading: snapshot.data!.heading,
                      );
                    },
                  )
                : _buildWindDirection(),
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
            windDirection: currentDay.deg ?? 0.0,
            heading: heading ?? 0.0,
          ),
          size: 20.0,
        ),
      );
}
