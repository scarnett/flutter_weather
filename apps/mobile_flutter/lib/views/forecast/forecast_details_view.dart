import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/widgets/app_ui_overlay_style.dart';

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(
    BuildContext context,
  ) =>
      Scaffold(
        key: _scaffoldKey,
        extendBody: true,
        body: BlocListener<AppBloc, AppState>(
          listener: _blocListener,
          child: WillPopScope(
            onWillPop: () => _willPopCallback(context.read<AppBloc>().state),
            child: _buildBody(context.watch<AppBloc>().state),
          ),
        ),
      );

  void _blocListener(
    BuildContext context,
    AppState state,
  ) {}

  Future<bool> _willPopCallback(
    AppState state,
  ) async {
    // ...
    return Future.value(true);
  }

  Widget _buildBody(
    AppState state,
  ) =>
      AppUiOverlayStyle(
        themeMode: state.themeMode,
        colorTheme: state.colorTheme,
        child: SafeArea(child: Container()),
      );
}
