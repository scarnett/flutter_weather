import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/enums/enums.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/utils/date_utils.dart';
import 'package:flutter_weather/views/forecast/forecast_utils.dart';
import 'package:timer_builder/timer_builder.dart';

class ForecastRefresh extends StatefulWidget {
  ForecastRefresh();

  @override
  _ForecastRefreshState createState() => _ForecastRefreshState();
}

class _ForecastRefreshState extends State<ForecastRefresh>
    with TickerProviderStateMixin {
  late Animation _refreshAnimation;
  late AnimationController _refreshAnimationController;
  DateTime? _nextRefreshTime;

  @override
  void initState() {
    super.initState();

    _refreshAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _refreshAnimation =
        Tween(begin: 0.0, end: pi + pi).animate(_refreshAnimationController);

    _nextRefreshTime = getNow().toLocal();
  }

  @override
  void dispose() {
    _refreshAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) =>
      BlocListener<AppBloc, AppState>(
        listener: _blocListener,
        child: _buildContent(),
      );

  void _blocListener(
    BuildContext context,
    AppState state,
  ) {
    if (state.refreshStatus == RefreshStatus.refreshing) {
      _refreshAnimationController
        ..reset()
        ..forward();

      setState(() => _nextRefreshTime = getNextUpdateTime(getNow().toLocal()));
    } else {
      setState(() {
        if (canRefresh(state, index: state.selectedForecastIndex)) {
          _nextRefreshTime = getNow().toLocal();
        } else if (forecastIndexExists(
            state.forecasts, state.selectedForecastIndex)) {
          _nextRefreshTime = getNextUpdateTime(
              state.forecasts[state.selectedForecastIndex].lastUpdated!);
        }
      });
    }
  }

  Widget _buildContent() => TimerBuilder.scheduled(
        [_nextRefreshTime!],
        builder: (BuildContext context) {
          AppState state = context.watch<AppBloc>().state;
          return _buildRefreshIcon(state);
        },
      );

  Widget _buildRefreshIcon(
    AppState state,
  ) =>
      canRefresh(state, index: state.selectedForecastIndex)
          ? Tooltip(
              message: AppLocalizations.of(context)!.refreshForecast,
              child: Material(
                type: MaterialType.transparency,
                child: Container(
                  height: 40.0,
                  width: 40.0,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(40.0),
                    child: AnimatedBuilder(
                      animation: _refreshAnimationController,
                      builder: (BuildContext context, Widget? child) =>
                          Transform.rotate(
                        angle: _refreshAnimation.value,
                        child: child,
                      ),
                      child: const Icon(Icons.refresh),
                    ),
                    onTap: () => _tapRefresh(state),
                  ),
                ),
              ),
            )
          : Container();

  void _tapRefresh(
    AppState state,
  ) =>
      context.read<AppBloc>().add(
            RefreshForecast(
              context,
              state.forecasts[state.selectedForecastIndex],
              context.read<AppBloc>().state.units.temperature,
            ),
          );
}
