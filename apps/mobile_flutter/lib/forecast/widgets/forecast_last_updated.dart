import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_weather/app/app_localization.dart';
import 'package:flutter_weather/app/utils/utils.dart';
import 'package:flutter_weather/models/models.dart';

class ForecastLastUpdated extends StatelessWidget {
  final Forecast forecast;
  final Color? fillColor;
  final String shortFormat;
  final String longFormat;

  ForecastLastUpdated({
    Key? key,
    required this.forecast,
    this.fillColor,
    this.shortFormat: 'h:mm a',
    this.longFormat: 'EEE, MMM d, yyyy @ h:mm a',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime? lastUpdated = forecast.lastUpdated;
    if (lastUpdated == null) {
      return Container();
    }

    String formattedLastUpdated;

    if (lastUpdated.isToday()) {
      formattedLastUpdated = AppLocalizations.of(context)!.getLastUpdatedAt(
        formatDateTime(
          date: lastUpdated.toLocal(),
          format: shortFormat,
        )!,
      );
    } else {
      formattedLastUpdated = AppLocalizations.of(context)!.getLastUpdatedOn(
        formatDateTime(
          date: lastUpdated.toLocal(),
          format: longFormat,
        )!,
      );
    }

    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: (fillColor == null)
              ? Colors.black.withOpacity(0.1)
              : fillColor!.withOpacity(0.2),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        margin: EdgeInsets.only(
          bottom: (MediaQuery.of(context).padding.bottom + 16.0),
        ),
        child: Text(
          formattedLastUpdated,
          style: Theme.of(context).textTheme.subtitle2,
        ),
      ),
    );
  }
}
