import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/model.dart';
import 'package:flutter_weather/views/forecast/forecast_form.dart';
import 'package:flutter_weather/widgets/app_ui_overlay_style.dart';
import 'package:iso_countries/country.dart';
import 'package:iso_countries/iso_countries.dart';

class ForecastFormView extends StatelessWidget {
  static Route route() =>
      MaterialPageRoute<void>(builder: (_) => ForecastFormView());

  const ForecastFormView({
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
  State<StatefulWidget> createState() => _ForecastFormViewState();
}

class _ForecastFormViewState extends State<ForecastPageView> {
  @override
  Widget build(
    BuildContext context,
  ) =>
      AppUiOverlayStyle(
        themeMode: context.watch<AppBloc>().state.themeMode,
        colorTheme: context.watch<AppBloc>().state.colorTheme,
        systemNavigationBarIconBrightness:
            context.watch<AppBloc>().state.colorTheme ? Brightness.dark : null,
        child: Scaffold(
          extendBody: true,
          appBar: AppBar(
            title: Text(AppLocalizations.of(context).editLocation),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: _tapBack,
            ),
          ),
          body: BlocListener<AppBloc, AppState>(
            listener: _blocListener,
            child: WillPopScope(
              onWillPop: () => _willPopCallback(context.read<AppBloc>().state),
              child: _buildBody(context.watch<AppBloc>().state),
            ),
          ),
        ),
      );

  void _blocListener(
    BuildContext context,
    AppState state,
  ) {
    if (state.crudStatus != null) {
      switch (state.crudStatus) {
        case CRUDStatus.UPDATED:
        case CRUDStatus.DELETED:
          FocusScope.of(context).unfocus();
          Navigator.of(context).pop();
          break;

        default:
          break;
      }
    }
  }

  Future<bool> _willPopCallback(
    AppState state,
  ) async {
    context.read<AppBloc>().add(ClearActiveForecastId());
    return Future.value(true);
  }

  Widget _buildBody(
    AppState state,
  ) =>
      SafeArea(
        child: ForecastForm(
          buttonText: AppLocalizations.of(context).save,
          forecast: state.forecasts[state.selectedForecastIndex],
          onSuccess: _onSuccess,
          onFailure: _onFailure,
        ),
      );

  _tapBack() {
    context.read<AppBloc>().add(ClearActiveForecastId());
    Navigator.of(context).pop();
  }

  void _onSuccess(
    BuildContext context,
    FormBlocSuccess<String, String> formState,
  ) async {
    FocusScope.of(context).unfocus();
    Map<String, dynamic> json = formState.toJson();
    print(json);

    final AppState appState = context.read<AppBloc>().state;
    final Country country = (await IsoCountries.iso_countries)
        .firstWhere((e) => e.name == json['country'], orElse: () => null);

    json['country'] = country.countryCode;

    context
        .read<AppBloc>()
        .add(UpdateForecast(appState.activeForecastId, json));
  }

  void _onFailure(
    BuildContext context,
    FormBlocFailure<String, String> state,
  ) {
    FocusScope.of(context).unfocus();

    // TODO!
    /*
    Scaffold.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).lookupFailure)));
    */
  }
}
