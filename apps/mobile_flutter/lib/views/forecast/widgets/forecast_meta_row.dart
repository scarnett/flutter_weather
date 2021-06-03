import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/config.dart';
import 'package:flutter_weather/enums/enums.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/models/models.dart';
import 'package:flutter_weather/theme.dart';
import 'package:flutter_weather/views/forecast/forecast_utils.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_icon.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_wind_direction.dart';
import 'package:weather_icons/weather_icons.dart';

class ForecastMetaRow extends StatelessWidget {
  final ForecastDay currentDay;

  const ForecastMetaRow({
    Key? key,
    required this.currentDay,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) =>
      Container(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(right: 20.0),
              child: Row(
                children: [
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          AppLocalizations.of(context)!.wind,
                          style:
                              Theme.of(context).textTheme.headline5!.copyWith(
                                    fontSize: 10.0,
                                  ),
                        ),
                      ),
                      _buildMetaInfo(
                        context: context,
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
                    ],
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
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        (context
                                                        .read<AppBloc>()
                                                        .state
                                                        .themeMode ==
                                                    ThemeMode.dark) ||
                                                context
                                                    .read<AppBloc>()
                                                    .state
                                                    .colorTheme
                                            ? Colors.white
                                            : AppTheme.primaryColor,
                                      ),
                                    ),
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
            ),
            Container(
              padding: const EdgeInsets.only(right: 20.0),
              child: Row(
                children: [
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          AppLocalizations.of(context)!.pressure,
                          style:
                              Theme.of(context).textTheme.headline5!.copyWith(
                                    fontSize: 10.0,
                                  ),
                        ),
                      ),
                      _buildMetaInfo(
                        context: context,
                        value: getPressure(
                          currentDay.pressure,
                          context.read<AppBloc>().state.units.pressure,
                        ).toString(),
                        unit: context
                            .read<AppBloc>()
                            .state
                            .units
                            .pressure
                            .getText(context),
                      ),
                    ],
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
            ),
            Container(
              child: Row(
                children: [
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          AppLocalizations.of(context)!.humidity,
                          style:
                              Theme.of(context).textTheme.headline5!.copyWith(
                                    fontSize: 10.0,
                                  ),
                        ),
                      ),
                      _buildMetaInfo(
                        context: context,
                        value: currentDay.humidity.toString(),
                        unit: '%',
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                    width: 30.0,
                    child: ForecastIcon(
                      iconSize: 20.0,
                      icon: WeatherIcons.humidity,
                      shadowColor: Colors.black26,
                    ),
                  ),
                ],
              ),
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
            windDirection: currentDay.deg ?? 0.0,
            heading: heading ?? 0.0,
          ),
          size: 20.0,
        ),
      );

  Widget _buildMetaInfo({
    required BuildContext context,
    required String value,
    required String unit,
  }) =>
      Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            value,
            style: Theme.of(context).textTheme.headline4!.copyWith(
                  fontSize: 16.0,
                ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 2.0),
            child: Text(
              unit,
              style: Theme.of(context).textTheme.subtitle2!.copyWith(
                    color: AppTheme.getHintColor(
                      context.read<AppBloc>().state.themeMode,
                      colorTheme: context.read<AppBloc>().state.colorTheme,
                    ),
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      );
}
