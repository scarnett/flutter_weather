import 'package:flutter/material.dart';
import 'package:flutter_weather/bloc/bloc.dart';

class AppSectionHeader extends StatefulWidget {
  final AppBloc bloc;
  final String text;
  final bool borderTop;
  final bool borderBottom;

  AppSectionHeader({
    @required this.bloc,
    @required this.text,
    this.borderTop = false,
    this.borderBottom = true,
  });

  @override
  _AppSectionHeaderState createState() => _AppSectionHeaderState();
}

class _AppSectionHeaderState extends State<AppSectionHeader> {
  @override
  Widget build(
    BuildContext context,
  ) {
    bool _isDark = (widget.bloc.state.themeMode == ThemeMode.dark);

    return Container(
      decoration: BoxDecoration(
        color: _isDark ? Colors.black.withOpacity(0.3) : Colors.grey[100],
        border: Border(
          bottom: BorderSide(
            color: _isDark ? Colors.black : Colors.grey[300],
            width: widget.borderBottom ? 1.0 : 0.0,
          ),
          top: BorderSide(
            color: _isDark ? Colors.black : Colors.grey[300],
            width: widget.borderTop ? 1.0 : 0.0,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 10.0,
      ),
      child: _buildText(),
    );
  }

  Widget _buildText() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            widget.text,
            style: Theme.of(context).textTheme.headline6,
          ),
        ],
      );
}
