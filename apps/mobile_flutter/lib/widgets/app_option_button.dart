import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/theme.dart';

class AppOptionButton extends StatelessWidget {
  final String text;
  final Function()? onTap;
  final bool active;
  final ThemeMode themeMode;
  final bool colorTheme;
  final Color? colorThemeColor;

  const AppOptionButton({
    Key? key,
    required this.text,
    required this.themeMode,
    this.onTap,
    this.active: false,
    this.colorTheme: false,
    this.colorThemeColor,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) =>
      GestureDetector(
        onTap: (onTap == null) ? null : onTap,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            color: active
                ? colorThemeColor ?? AppTheme.primaryColor
                : AppTheme.getSectionColor(themeMode),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 2.0,
                ),
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        color: active
                            ? Colors.white
                            : (colorThemeColor ?? AppTheme.primaryColor),
                        fontWeight: FontWeight.w400,
                      ),
                ),
              ),
            ],
          ),
        ),
      );
}
