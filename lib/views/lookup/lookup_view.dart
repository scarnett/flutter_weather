import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/utils/date_utils.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_display.dart';
import 'package:flutter_weather/views/lookup/bloc/bloc.dart';
import 'package:flutter_weather/views/lookup/lookup_form.dart';
import 'package:flutter_weather/widgets/app_form_button.dart';
import 'package:flutter_weather/widgets/app_ui_overlay_style.dart';

class LookupView extends StatelessWidget {
  static Route route() => MaterialPageRoute<void>(builder: (_) => LookupView());

  const LookupView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) =>
      BlocProvider<LookupBloc>(
        create: (BuildContext context) => LookupBloc(),
        child: LookupPageView(),
      );
}

class LookupPageView extends StatefulWidget {
  LookupPageView({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LookupPageViewState();
}

class _LookupPageViewState extends State<LookupPageView> {
  @override
  Widget build(
    BuildContext context,
  ) =>
      BlocBuilder<LookupBloc, LookupState>(
        builder: (
          BuildContext context,
          LookupState state,
        ) =>
            WillPopScope(
          onWillPop: () => _willPopCallback(state),
          child: AppUiOverlayStyle(
            bloc: context.watch<AppBloc>(),
            child: Scaffold(
              extendBody: true,
              appBar: AppBar(
                title: Text(AppLocalizations.of(context).addLocation),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => _handleBack(state),
                ),
              ),
              body: SafeArea(
                child: _buildContent(),
              ),
            ),
          ),
        ),
      );

  Future<bool> _willPopCallback(
    LookupState state,
  ) async {
    if (state.lookupForecast != null) {
      context.read<LookupBloc>().add(ClearForecast());
      return Future.value(false);
    }

    return Future.value(true);
  }

  Widget _buildContent() {
    Forecast lookupForecast = context.read<LookupBloc>().state.lookupForecast;
    if (lookupForecast != null) {
      return Column(
        children: <Widget>[
          ForecastDisplay(
            bloc: context.read<AppBloc>(),
            forecast: lookupForecast,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: AppFormButton(
              text: AppLocalizations.of(context).addThisLocation,
              icon: Icon(Icons.add),
              onTap: _tapAddLocation,
            ),
          ),
        ],
      );
    }

    return LookupForm();
  }

  void _handleBack(
    LookupState state,
  ) {
    if (state.lookupForecast != null) {
      context.read<LookupBloc>().add(ClearForecast());
    } else {
      Navigator.of(context).pop();
    }
  }

  void _tapAddLocation() {
    LookupState lookupState = context.read<LookupBloc>().state;
    Forecast forecast = lookupState.lookupForecast.copyWith(
      postalCode: lookupState.postalCode,
      countryCode: lookupState.countryCode,
      lastUpdated: getNow(),
    );

    context.read<AppBloc>().add(AddForecast(forecast));
    Navigator.of(context).pop();
  }
}
