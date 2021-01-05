import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/bloc/bloc.dart';

class AppRadioTile<T> extends StatelessWidget {
  final AppBloc bloc;
  final String title;
  final T value;
  final T groupValue;
  final Function(T) onTap;

  const AppRadioTile({
    Key key,
    this.bloc,
    this.title,
    this.value,
    this.groupValue,
    this.onTap,
  })  : assert(bloc != null),
        assert(title != null),
        assert(value != null),
        super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) =>
      RadioListTile<T>(
        title: Text(
          title,
          style: TextStyle(
            color: (bloc.state.themeMode == ThemeMode.dark)
                ? (value == groupValue)
                    ? Colors.white
                    : Colors.grey[700]
                : (value == groupValue)
                    ? Colors.grey[900]
                    : Colors.grey[400],
          ),
        ),
        value: value,
        groupValue: groupValue,
        onChanged: onTap,
        controlAffinity: ListTileControlAffinity.trailing,
        activeColor: Colors.deepPurple[400],
      );
}
