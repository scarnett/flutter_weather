import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/theme.dart';

class AppFormButton extends StatelessWidget {
  final Function? onTap;
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
      FlatButton(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 10.0,
        ),
        color: (buttonColor == null) ? AppTheme.primaryColor : buttonColor,
        disabledTextColor: AppTheme.disabledTextColor,
        disabledColor: AppTheme.disabledColor,
        textColor: Colors.white,
        height: 50.0,
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
        onPressed: onTap as void Function()?,
      );
}
