import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_weather/app_keys.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/views/lookup/lookup_view.dart';

class AppFAB extends StatefulWidget {
  final AnimationController animationController;

  AppFAB({
    Key? key,
    required this.animationController,
  }) : super(key: key);

  @override
  _AppFABState createState() => _AppFABState();
}

class _AppFABState extends State<AppFAB> with SingleTickerProviderStateMixin {
  @override
  Widget build(
    BuildContext context,
  ) =>
      FadeTransition(
        opacity: widget.animationController,
        child: ScaleTransition(
          alignment: Alignment.centerRight,
          scale: widget.animationController,
          child: FloatingActionButton(
            key: Key(AppKeys.addLocationKey),
            tooltip: AppLocalizations.of(context)!.addForecast,
            onPressed: _tapAddLocation,
            child: Icon(Icons.add),
            mini: true,
          ),
        ),
      );

  void _tapAddLocation() {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    Navigator.push(context, LookupView.route());
  }
}
