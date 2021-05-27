import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/enums.dart';
import 'package:flutter_weather/utils/common_utils.dart';
import 'package:flutter_weather/utils/date_utils.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_hour_tile.dart';

class ForecastHours extends StatefulWidget {
  final Forecast forecast;
  final TemperatureUnit temperatureUnit;
  final ThemeMode themeMode;
  final bool colorTheme;
  final int maxHours;

  ForecastHours({
    Key? key,
    required this.forecast,
    required this.temperatureUnit,
    required this.themeMode,
    this.colorTheme: false,
    this.maxHours: 24,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ForecastHoursState();
}

class _ForecastHoursState extends State<ForecastHours> {
  final Map<String, List<ForecastHour>> hourData = {};

  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) =>
      ListView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: _getHourTiles(),
        padding: const EdgeInsets.all(0.0),
      );

  void initialize() {
    _buildDataMap();
  }

  int get hourCount {
    if (widget.forecast.details!.hourly != null) {
      int count = widget.forecast.details!.hourly!.length;
      if (count < widget.maxHours) {
        return count;
      }

      return widget.maxHours;
    }

    return 0;
  }

  void _buildDataMap() {
    int count = 0;
    int maxCount = hourCount;

    for (ForecastHour hour in widget.forecast.details!.hourly!) {
      DateTime hourDate = epochToDateTime(hour.dt!).getDate();
      String? formatted = formatDateTime(date: hourDate, format: 'yyyyMMdd');
      if (formatted != null) {
        if (hourData.containsKey(formatted)) {
          hourData[formatted]!.add(hour);
        } else {
          hourData[formatted] = [hour];
        }
      }

      count++;

      if (count == maxCount) {
        break;
      }
    }
  }

  List<Widget> _getHourTiles() {
    List<Widget> tiles = [];

    if (hourData.length > 0) {
      hourData.forEach((String day, List<ForecastHour> hours) {
        // Add day tile
        tiles.add(
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              formatDateTime(
                date: fromString(day),
                format: 'EEEE, MMMM d',
                addSuffix: true,
              )!,
              style: Theme.of(context).textTheme.headline4!.copyWith(
                    shadows: (widget.themeMode == ThemeMode.dark)
                        ? commonTextShadow()
                        : null,
                  ),
            ),
          ),
        );

        // Add hour tiles
        for (ForecastHour hour in hours) {
          tiles.add(
            ForecastHourTile(
              hour: hour,
              temperatureUnit: widget.temperatureUnit,
              themeMode: widget.themeMode,
              colorTheme: widget.colorTheme,
            ),
          );
        }
      });
    }

    return tiles;
  }
}
