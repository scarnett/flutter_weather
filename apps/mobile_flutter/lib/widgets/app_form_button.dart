import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/theme.dart';

class AppFormButton extends StatelessWidget {
  final Function()? onTap;
  final String? text;
  final Widget? icon;
  final Color? buttonColor;
  final Color? textColor;

  AppFormButton({
    Key? key,
    this.onTap,
    this.text,
    this.icon,
    this.buttonColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) =>
      TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 10.0,
          ),
          backgroundColor:
              (buttonColor == null) ? AppTheme.primaryColor : buttonColor,
          primary: Colors.white,
          onSurface: AppTheme.disabledTextColor,
          minimumSize: Size(100, 10),
          textStyle: TextStyle(
            color: Colors.white,
          ),
        ),
        child: (icon == null)
            ? (text == null)
                ? Container()
                : Text(text!,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: textColor,
                    ))
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                      padding: EdgeInsets.only(
                        right: (text == null) ? 0.0 : 5.0,
                      ),
                      child: icon),
                  (text == null)
                      ? Container()
                      : Text(text!,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: textColor,
                          )),
                ],
              ),
        onPressed: onTap,
      );
}
