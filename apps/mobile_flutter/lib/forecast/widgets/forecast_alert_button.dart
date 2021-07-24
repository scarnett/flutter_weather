import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/app/app_localization.dart';
import 'package:flutter_weather/app/app_theme.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';
import 'package:flutter_weather/forecast/view/view.dart';
import 'package:flutter_weather/models/models.dart';

class ForecastAlertButton extends StatefulWidget {
  final Forecast forecast;
  final double iconSize;
  final double iconPulseSize;
  final bool compact;

  ForecastAlertButton({
    Key? key,
    required this.forecast,
    this.iconSize: 16.0,
    this.iconPulseSize: 1.5,
    this.compact: false,
  }) : super(key: key);

  @override
  _ForecastAlertButtonState createState() => _ForecastAlertButtonState();
}

class _ForecastAlertButtonState extends State<ForecastAlertButton>
    with TickerProviderStateMixin {
  late AnimationController _sizeController;
  late Tween<double> _sizeTween;
  late Timer _sizeTimer;

  Timer? _eventTimer;
  List<Widget> _alertWidgets = <Widget>[];
  int _currentPage = 0;

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  void dispose() {
    _sizeController.dispose();
    _sizeTimer.cancel();
    _eventTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) =>
      Material(
        type: MaterialType.transparency,
        child: _buildContent(),
      );

  void _initialize() {
    _sizeController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
      value: 1.0,
    );

    _sizeTween = Tween(begin: widget.iconPulseSize, end: 1.0);
    _sizeTimer = Timer.periodic(
      const Duration(seconds: 10),
      (Timer timer) => _sizeController.forward(from: 0.0),
    );

    _sizeController.forward();

    if ((widget.forecast.details?.alerts?.length ?? 0) > 1) {
      _eventTimer = Timer.periodic(Duration(seconds: 10), (Timer timer) {
        if (_currentPage < (widget.forecast.details!.alerts!.length - 1)) {
          setState(() => _currentPage++);
        } else {
          setState(() => (_currentPage = 0));
        }
      });
    }
  }

  Widget _buildContent() {
    if (widget.compact) {
      return _buildCompactAlert();
    }

    if (_alertWidgets.isEmpty) {
      _buildAlerts();
    }

    if (_alertWidgets.isNotEmpty) {
      if (_alertWidgets.length > 1) {
        return Container(
          margin: const EdgeInsets.only(bottom: 20.0),
          child: CarouselSlider(
            items: _alertWidgets,
            options: CarouselOptions(
              height: 50.0,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 10),
              autoPlayAnimationDuration: const Duration(milliseconds: 300),
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: false,
              viewportFraction: 1.0,
            ),
          ),
        );
      }

      return Container(
        margin: const EdgeInsets.only(bottom: 20.0),
        child: _alertWidgets.first,
      );
    }

    return Container();
  }

  Widget _buildCompactAlert() => Tooltip(
        preferBelow: false,
        message: AppLocalizations.of(context)!
            .getAlerts(widget.forecast.details?.alerts?.length ?? 0),
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            height: 40.0,
            width: 40.0,
            child: InkWell(
              highlightColor: Colors.transparent,
              overlayColor: MaterialStateProperty.all<Color>(
                  AppTheme.warningColor.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(40.0),
              child: ScaleTransition(
                scale: _sizeTween.animate(
                  CurvedAnimation(
                    parent: _sizeController,
                    curve: Curves.elasticOut,
                  ),
                ),
                child: Icon(
                  Icons.warning,
                  color: AppTheme.warningColor,
                  size: widget.iconSize,
                ),
              ),
              onTap: () => _tapAlert(context),
            ),
          ),
        ),
      );

  Widget _buildDetailedAlert(
    ForecastAlert alert,
    int index,
  ) =>
      Center(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: AppTheme.warningColor.withOpacity(0.3),
              width: 2.0,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            color: AppTheme.getAlertColor(
              context.read<AppBloc>().state.themeMode,
              colorTheme: context.read<AppBloc>().state.colorTheme,
            ),
          ),
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            highlightColor: Colors.transparent,
            overlayColor: MaterialStateProperty.all<Color>(
                AppTheme.warningColor.withOpacity(0.1)),
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 20.0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Icon(
                      Icons.warning,
                      color: AppTheme.warningColor,
                      size: widget.iconSize,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      alert.event ?? 'N/A',
                      style: TextStyle(fontSize: 16.0),
                      //style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                ],
              ),
            ),
            onTap: () => _tapAlert(context, index: index),
          ),
        ),
      );

  void _buildAlerts() {
    if (widget.forecast.details?.alerts != null) {
      int index = 0;
      for (ForecastAlert alert in widget.forecast.details!.alerts!) {
        _alertWidgets.add(_buildDetailedAlert(alert, index));
        index++;
      }
    }
  }

  void _tapAlert(
    BuildContext context, {
    int index: 0,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    Navigator.push(
      context,
      ForecastAlertsView.route(
        arguments: ForecastAlertsViewArguments(initialIndex: index),
      ),
    );
  }
}
