import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/views/forecast/bloc/bloc.dart';

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
          child: Scaffold(
            extendBody: true,
            body: _buildContent(state),
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
            _buildDayNightSwitch(),
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
              onTap: () => print('settings'), // TODO!
            ),
          ),
        ),
      );

  // TODO! move to widget
  Widget _buildDayNightSwitch() => FlutterSwitch(
        width: 60.0,
        height: 28.0,
        toggleSize: 24.0,
        borderRadius: 24.0,
        padding: 1.0,
        value: (context.read<AppBloc>().state.themeMode == ThemeMode.dark),
        activeToggleColor: Color(0xFF6E40C9),
        inactiveToggleColor: Color(0xFF2F363D),
        activeSwitchBorder: Border.all(
          color: Color(0xFF3C1E70),
          width: 2.0,
        ),
        inactiveSwitchBorder: Border.all(
          color: Color(0xFFD1D5DA),
          width: 2.0,
        ),
        activeColor: Color(0xFF271052),
        inactiveColor: Colors.white,
        activeIcon: Icon(
          Icons.nightlight_round,
          color: Color(0xFFF8E3A1),
          size: 16.0,
        ),
        inactiveIcon: Icon(
          Icons.wb_sunny,
          color: Color(0xFFFFDF5D),
          size: 16.0,
        ),
        onToggle: (val) => context.read<AppBloc>().add(ToggleThemeMode()),
      );
}
