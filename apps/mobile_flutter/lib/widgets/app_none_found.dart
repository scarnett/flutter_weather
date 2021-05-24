import 'package:flutter/material.dart';
import 'package:flutter_weather/theme.dart';

class AppNoneFound extends StatefulWidget {
  final IconData icon;
  final double iconSize;
  final String? text;

  AppNoneFound({
    this.icon: Icons.sentiment_dissatisfied,
    this.iconSize: 70.0,
    this.text,
  });

  @override
  _AppNoneFoundState createState() => _AppNoneFoundState();
}

class _AppNoneFoundState extends State<AppNoneFound> {
  @override
  Widget build(
    BuildContext context,
  ) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Container(
              width: widget.iconSize,
              height: widget.iconSize,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.icon,
                color: AppTheme.primaryColor,
                size: widget.iconSize,
              ),
            ),
          ),
          (widget.text == null)
              ? Container()
              : Text(
                  widget.text!,
                  style: Theme.of(context).textTheme.headline3!.copyWith(
                        fontSize: 30.0,
                      ),
                  textAlign: TextAlign.center,
                ),
        ],
      );
}
