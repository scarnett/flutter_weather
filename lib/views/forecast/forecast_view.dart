import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/views/forecast/bloc/bloc.dart';
import 'package:flutter_weather/views/settings/settings_view.dart';
import 'package:flutter_weather/widgets/app_day_night_switch.dart';
import 'package:flutter_weather/widgets/app_ui_overlay_style.dart';

class ForecastView extends StatelessWidget {
  static Route route() =>
      MaterialPageRoute<void>(builder: (_) => ForecastView());

  const ForecastView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) =>
      BlocProvider<ForecastBloc>(
        create: (BuildContext context) => ForecastBloc(),
        child: ForecastPageView(),
      );
}

class ForecastPageView extends StatefulWidget {
  ForecastPageView({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ForecastPageViewState();
}

class _ForecastPageViewState extends State<ForecastPageView> {
  PageController _pageController;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(
      initialPage: context.read<ForecastBloc>().state.selectedForecastIndex,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) =>
      BlocBuilder<ForecastBloc, ForecastState>(
        builder: (
          BuildContext context,
          ForecastState state,
        ) =>
            WillPopScope(
          onWillPop: () => _willPopCallback(state),
          child: AppUiOverlayStyle(
            bloc: context.watch<AppBloc>(),
            child: Scaffold(
              extendBody: true,
              body: _buildContent(state),
            ),
          ),
        ),
      );

  /// Handles the android back button
  Future<bool> _willPopCallback(
    ForecastState state,
  ) async {
    setState(() {
      if (state.selectedForecastIndex == 0) {
        // Exits the app
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      } else {
        // Go back to the first forecast
        context.read<ForecastBloc>().add(SelectedForecastIndex(0));
        _pageController.jumpToPage(0);
      }
    });

    return Future.value(false);
  }

  /// Builds the content
  Widget _buildContent(
    ForecastState state,
  ) {
    List<Widget> children = [];
    children..add(_buildBody())..add(_buildOptions());

    return SafeArea(
      child: Stack(
        children: children,
      ),
    );
  }

  /// Builds the pageview
  Widget _buildBody() => Column(
        children: <Widget>[
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: <Widget>[],
            ),
          ),
        ],
      );

  Widget _buildOptions() => Padding(
        padding: const EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          top: 20.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            AppDayNightSwitch(bloc: context.read<AppBloc>()),
            _buildSettingsButton(),
          ],
        ),
      );

  Widget _buildSettingsButton() => Container(
        padding: EdgeInsets.only(left: 10.0),
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            height: 40.0,
            width: 40.0,
            child: InkWell(
              borderRadius: BorderRadius.circular(40.0),
              child: Icon(Icons.settings),
              onTap: () => Navigator.push(context, SettingsView.route()),
            ),
          ),
        ),
      );
}
