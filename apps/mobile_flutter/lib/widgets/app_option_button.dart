import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/theme.dart';

class AppOptionButton extends StatelessWidget {
  final String text;
  final Function()? onTap;
  final bool active;
  final Color? colorThemeColor;

  const AppOptionButton({
    Key? key,
    required this.text,
    this.onTap,
    this.active: false,
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
                ? context.read<AppBloc>().state.colorTheme
                    ? Colors.white
                    : AppTheme.primaryColor
                : context.read<AppBloc>().state.colorTheme
                    ? (colorThemeColor ?? AppTheme.primaryColor)
                    : AppTheme.getSectionColor(
                        context.read<AppBloc>().state.themeMode),
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
                            ? context.read<AppBloc>().state.colorTheme
                                ? (colorThemeColor ?? AppTheme.primaryColor)
                                : Colors.white
                            : context.read<AppBloc>().state.colorTheme
                                ? Colors.white
                                : AppTheme.primaryColor,
                        fontWeight: FontWeight.w400,
                      ),
                ),
              ),
            ],
          ),
        ),
      );
}
