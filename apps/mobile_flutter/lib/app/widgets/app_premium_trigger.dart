import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';
import 'package:flutter_weather/premium/widgets/widgets.dart';

class AppPremiumTrigger extends StatefulWidget {
  const AppPremiumTrigger({
    Key? key,
  }) : super(key: key);

  _AppPremiumTrigger createState() => _AppPremiumTrigger();
}

class _AppPremiumTrigger extends State<AppPremiumTrigger> {
  bool _colorTheme = false;

  @override
  void initState() {
    _colorTheme = context.read<AppBloc>().state.colorTheme;
    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) =>
      Container(
        height: 40.0,
        width: 40.0,
        child: InkWell(
          borderRadius: BorderRadius.circular(40.0),
          child: PremiumStar(
            color: _colorTheme ? Colors.white : Colors.amber,
          ),
          onTap: () => _tapPremium(),
        ),
      );

  void _tapPremium() => context.read<AppBloc>().add(
      SetShowPremiumInfo(true)); // Navigator.push(context, PremiumView.route())
}
