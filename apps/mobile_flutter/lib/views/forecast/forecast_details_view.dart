import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ForecastDetailsView extends StatelessWidget {
  static Route route() =>
      MaterialPageRoute<void>(builder: (_) => ForecastDetailsView());

  const ForecastDetailsView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) =>
      ForecastPageView();
}

class ForecastPageView extends StatefulWidget {
  ForecastPageView({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ForecastDetailsViewState();
}

class _ForecastDetailsViewState extends State<ForecastPageView> {
  @override
  Widget build(
    BuildContext context,
  ) {
    // TODO!
    return Container();
  }
}
