import 'package:flutter/material.dart';
import 'package:flutter_weather/theme.dart';

class AppNoneFound extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final String? text;

  AppNoneFound({
    this.icon: Icons.sentiment_dissatisfied,
    this.iconSize: 70.0,
    this.text,
  });

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
              width: iconSize,
              height: iconSize,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppTheme.primaryColor,
                size: iconSize,
              ),
            ),
          ),
          (text == null)
              ? Container()
              : Text(
                  text!,
                  style: Theme.of(context).textTheme.headline3!.copyWith(
                        fontSize: 30.0,
                      ),
                  textAlign: TextAlign.center,
                ),
        ],
      );
}
