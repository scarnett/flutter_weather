import 'package:flutter/material.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/theme.dart';

class AppSectionHeader extends StatefulWidget {
  final AppBloc bloc;
  final String text;
  final bool borderTop;
  final bool borderBottom;
  final List<Widget>? options;
  final EdgeInsets padding;

  AppSectionHeader({
    required this.bloc,
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
  _AppSectionHeaderState createState() => _AppSectionHeaderState();
}

class _AppSectionHeaderState extends State<AppSectionHeader> {
  @override
  Widget build(
    BuildContext context,
  ) =>
      Container(
        decoration: BoxDecoration(
          color: AppTheme.getSectionColor(widget.bloc.state.themeMode),
          border: Border(
            bottom: BorderSide(
              color: AppTheme.getBorderColor(
                widget.bloc.state.themeMode,
                colorTheme: widget.bloc.state.colorTheme,
              ),
              width: widget.borderBottom ? 1.0 : 0.0,
            ),
            top: BorderSide(
              color: AppTheme.getBorderColor(
                widget.bloc.state.themeMode,
                colorTheme: widget.bloc.state.colorTheme,
              ),
              width: widget.borderTop ? 1.0 : 0.0,
            ),
          ),
        ),
        padding: widget.padding,
        child: _buildContent(),
      );

  Widget _buildContent() => Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Text(
              widget.text,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          _buildOptions(),
        ],
      );

  Widget _buildOptions() {
    if ((widget.options == null) || widget.options!.isEmpty) {
      return Container();
    }

    return Container(child: Row(children: widget.options!));
  }
}
