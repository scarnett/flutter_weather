import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/enums.dart';
import 'package:flutter_weather/utils/color_utils.dart';
import 'package:flutter_weather/utils/common_utils.dart';
import 'package:flutter_weather/utils/date_utils.dart';
import 'package:flutter_weather/utils/scroll_utils.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_hour_tile.dart';
import 'package:flutter_weather/widgets/app_option_button.dart';

class ForecastHours extends StatefulWidget {
  final ScrollController parentScrollController;
  final Forecast forecast;
  final TemperatureUnit temperatureUnit;
  final ThemeMode themeMode;
  final bool colorTheme;
  final Color? forecastColor;
  final ForecastHourRange forecastHourRange;

  ForecastHours({
    Key? key,
    required this.parentScrollController,
    required this.forecast,
    required this.temperatureUnit,
    required this.themeMode,
    required this.forecastHourRange,
    this.colorTheme: false,
    this.forecastColor,
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
  void dispose() {
    _listViewScrollController.dispose();
    super.dispose();
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
        child: Column(
          children: [
            _buildOptions(),
            Expanded(
              child: ListView(
                primary: false,
                shrinkWrap: true,
                controller: _listViewScrollController,
                physics: _listViewScrollPhysics,
                children: _getHourTiles(),
                padding: const EdgeInsets.all(0.0),
              ),
            ),
          ],
        ),
      );

  void initialize() {
    widget.parentScrollController.addListener(_parentScrollListener);

    _listViewScrollController = ScrollController();
    _listViewScrollController.addListener(_listViewScrollListener);
    _listViewScrollPhysics = ScrollPhysics();

    _buildDataMap(widget.forecastHourRange.hours);
  }

  void _listViewScrollListener() => setState(() {
        if ((isAtTop(_listViewScrollController) ||
                isAtBottom(_listViewScrollController)) &&
            isScrolling(widget.parentScrollController)) {
          _listViewScrollPhysics = NeverScrollableScrollPhysics();
        } else if ((isAtBottom(widget.parentScrollController) ||
                isScrolling(widget.parentScrollController)) &&
            isAtTop(_listViewScrollController)) {
          _listViewScrollPhysics = NeverScrollableScrollPhysics();
        }
      });

  void _parentScrollListener() => setState(() {
        if ((isAtBottom(_listViewScrollController) &&
            isAtBottom(widget.parentScrollController))) {
          _listViewScrollPhysics = ScrollPhysics();
        } else if (isScrolling(widget.parentScrollController)) {
          _listViewScrollPhysics = ScrollPhysics();
        } else if (isScrollingUp(widget.parentScrollController) &&
            isAtTop(_listViewScrollController)) {
          _listViewScrollPhysics = NeverScrollableScrollPhysics();
        }
      });

  int getHourCount(
    int hourCount,
  ) {
    if (widget.forecast.details!.hourly != null) {
      int count = widget.forecast.details!.hourly!.length;
      if (count < hourCount) {
        return count;
      }

      return hourCount;
    }

    return 0;
  }

  void _buildDataMap(
    int hourCount,
  ) {
    if (_hourData.length > 0) {
      _hourData.clear();
    }

    int count = 0;

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

      if (count == hourCount) {
        break;
      }
    }
  }

  Widget _buildOptions() => Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: _buildHourOptions(),
        ),
      );

  List<Widget> _buildHourOptions() {
    List<Widget> options = [];
    int count = 0;

    for (ForecastHourRange range in ForecastHourRange.values) {
      Widget option = AppOptionButton(
        text: range.getText(context).toUpperCase(),
        themeMode: widget.themeMode,
        colorTheme: widget.colorTheme,
        colorThemeColor: widget.forecastColor?.darken(0.15),
        active: (widget.forecastHourRange == range),
        onTap: (widget.forecastHourRange == range)
            ? null
            : () => _tapForecastHourRange(range),
      );

      if (count > 0) {
        option = Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: option,
        );
      }

      options.add(option);
      count++;
    }

    return options;
  }

  List<Widget> _getHourTiles() {
    List<Widget> tiles = [];
    int dayCount = 0;

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

        int hourCount = 0;

        // Add hour tiles
        for (ForecastHour hour in hours) {
          Widget hourTile = ForecastHourTile(
            hour: hour,
            temperatureUnit: widget.temperatureUnit,
            themeMode: widget.themeMode,
            colorTheme: widget.colorTheme,
          );

          if (((dayCount + 1) == _hourData.length) &&
              ((hourCount + 1) == hours.length)) {
            hourTile = Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom,
              ),
              child: hourTile,
            );
          }

          tiles.add(hourTile);
          hourCount++;
        }

        dayCount++;
      });
    }

    return tiles;
  }

  void _tapForecastHourRange(
    ForecastHourRange range,
  ) {
    BlocProvider.of<AppBloc>(context, listen: false)
        .add(SetForecastHourRange(range));

    _buildDataMap(range.hours);
  }
}
