import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/app/bloc/app_bloc.dart';
import 'package:flutter_weather/app/utils/utils.dart';
import 'package:flutter_weather/app/widgets/widgets.dart';
import 'package:flutter_weather/forecast/forecast.dart';

class ForecastAlertDescription extends StatefulWidget {
  final String? description;

  ForecastAlertDescription({
    Key? key,
    required this.description,
  }) : super(key: key);

  @override
  _ForecastAlertDescriptionState createState() =>
      _ForecastAlertDescriptionState();
}

class _ForecastAlertDescriptionState extends State<ForecastAlertDescription> {
  late List<Map<String, String?>> lines;

  @override
  void initState() {
    lines = scrubAlertDescription(widget.description);
    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        children: _buildContent(),
      );

  List<Widget> _buildContent() {
    List<Widget> children = [];

    for (Map<String, String?> entry in lines) {
      if (entry['label'] == null) {
        children.add(_buildText(entry['text']));
      } else {
        children.add(
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLabel(entry['label']),
              _buildText(entry['text']),
            ],
          ),
        );
      }
    }

    return children;
  }

  Widget _buildLabel(
    String? label,
  ) =>
      AppSectionHeader(text: label ?? '');

  Widget _buildText(
    String? text,
  ) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            text ?? '',
            style: Theme.of(context).textTheme.headline5!.copyWith(
                  height: 1.5,
                  fontSize: 18.0,
                  shadows: context.read<AppBloc>().state.colorTheme
                      ? commonTextShadow()
                      : null,
                ),
          ),
        ),
      );
}
