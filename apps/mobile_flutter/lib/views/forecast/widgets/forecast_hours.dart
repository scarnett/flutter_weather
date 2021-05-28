import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/enums.dart';
import 'package:flutter_weather/utils/common_utils.dart';
import 'package:flutter_weather/utils/date_utils.dart';
import 'package:flutter_weather/utils/scroll_utils.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_hour_tile.dart';

class ForecastHours extends StatefulWidget {
  final ScrollController parentScrollController;
  final Forecast forecast;
  final TemperatureUnit temperatureUnit;
  final ThemeMode themeMode;
  final bool colorTheme;
  final int maxHours;

  ForecastHours({
    Key? key,
    required this.parentScrollController,
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
  final Map<String, List<ForecastHour>> _hourData = {};
  late ScrollController _listViewScrollController;
  late ScrollPhysics _listViewScrollPhysics;

  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) =>
      ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 100.0,
          maxHeight: 500.0,
        ),
        child: ListView(
          primary: false,
          shrinkWrap: true,
          controller: _listViewScrollController,
          physics: _listViewScrollPhysics,
          children: _getHourTiles(),
          padding: const EdgeInsets.all(0.0),
        ),
      );

  void initialize() {
    widget.parentScrollController.addListener(_parentScrollListener);

    _listViewScrollController = ScrollController();
    _listViewScrollController.addListener(_listViewScrollListener);
    _listViewScrollPhysics = ScrollPhysics();

    _buildDataMap();
  }

  void _listViewScrollListener() => setState(() {
        if ((isAtTop(_listViewScrollController) ||
                isAtBottom(_listViewScrollController)) &&
            isScrolling(widget.parentScrollController)) {
          _listViewScrollPhysics = NeverScrollableScrollPhysics();
        } else if (isAtBottom(widget.parentScrollController) &&
            isAtTop(_listViewScrollController)) {
          _listViewScrollPhysics = NeverScrollableScrollPhysics();
        }
      });

  void _parentScrollListener() {
    if ((isAtBottom(_listViewScrollController) &&
        isAtBottom(widget.parentScrollController))) {
      _listViewScrollPhysics = ScrollPhysics();
    } else if (isScrolling(widget.parentScrollController)) {
      _listViewScrollPhysics = ScrollPhysics();
    } else if (isScrollingUp(widget.parentScrollController) &&
        isAtTop(_listViewScrollController)) {
      _listViewScrollPhysics = NeverScrollableScrollPhysics();
    }
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
        if (_hourData.containsKey(formatted)) {
          _hourData[formatted]!.add(hour);
        } else {
          _hourData[formatted] = [hour];
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

    if (_hourData.length > 0) {
      _hourData.forEach((String day, List<ForecastHour> hours) {
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
