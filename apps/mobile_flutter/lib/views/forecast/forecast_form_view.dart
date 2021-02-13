import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_weather/app_keys.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/env_config.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/model.dart';
import 'package:flutter_weather/utils/common_utils.dart';
import 'package:flutter_weather/views/forecast/forecast_form.dart';
import 'package:flutter_weather/views/forecast/forecast_view.dart';
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
        colorTheme: (context.watch<AppBloc>().state.colorTheme ?? false),
        systemNavigationBarIconBrightness:
            (context.watch<AppBloc>().state.colorTheme ?? false)
                ? Brightness.dark
                : null,
        child: Scaffold(
          extendBody: true,
          appBar: AppBar(
            title: Text(AppLocalizations.of(context).editForecast),
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
          FocusScope.of(context).unfocus();
          Navigator.of(context)
              .pushAndRemoveUntil(ForecastView.route(), (route) => false);
          break;

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
          buttonKey: Key(AppKeys.saveForecastButtonKey),
          saveButtonText: AppLocalizations.of(context).save,
          deleteButtonText: AppLocalizations.of(context).delete,
          forecast: state.forecasts.isNullOrZeroLength()
              ? null
              : state.forecasts[state.selectedForecastIndex],
          forecasts: state.forecasts,
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
    Map<String, dynamic> forecastData = formState.toJson();

    final AppState appState = context.read<AppBloc>().state;
    final Country country = (await IsoCountries.iso_countries).firstWhere(
        (Country _country) => _country.name == forecastData['countryCode'],
        orElse: () => null);

    forecastData['countryCode'] = (country == null)
        ? EnvConfig.DEFAULT_COUNTRY_CODE
        : country.countryCode;

    context
        .read<AppBloc>()
        .add(UpdateForecast(appState.activeForecastId, forecastData));
  }

  void _onFailure(
    BuildContext context,
    FormBlocFailure<String, String> state,
  ) {
    FocusScope.of(context).unfocus();
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text(state.failureResponse)));
  }
}
