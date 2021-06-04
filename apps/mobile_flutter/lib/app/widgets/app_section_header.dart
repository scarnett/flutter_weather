import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/app/app_theme.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';

class AppSectionHeader extends StatelessWidget {
  final String text;
  final bool borderTop;
  final bool borderBottom;
  final List<Widget>? options;
  final EdgeInsets padding;

  AppSectionHeader({
    required this.text,
    this.borderTop: false,
    this.borderBottom: false,
    this.options,
    this.padding: const EdgeInsets.symmetric(
      horizontal: 16.0,
      vertical: 16.0,
    ),
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    AppState state = context.read<AppBloc>().state;
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.getSectionColor(state.themeMode),
        border: Border(
          bottom: BorderSide(
            color: AppTheme.getBorderColor(
              state.themeMode,
              colorTheme: state.colorTheme,
            ),
            width: borderBottom ? 1.0 : 0.0,
          ),
          top: BorderSide(
            color: AppTheme.getBorderColor(
              state.themeMode,
              colorTheme: state.colorTheme,
            ),
            width: borderTop ? 1.0 : 0.0,
          ),
        ),
      ),
      padding: padding,
      child: _buildContent(context),
    );
  }

  Widget _buildContent(
    BuildContext context,
  ) =>
      Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          _buildOptions(),
        ],
      );

  Widget _buildOptions() {
    if ((options == null) || options!.isEmpty) {
      return Container();
    }

    return Container(child: Row(children: options!));
  }
}
