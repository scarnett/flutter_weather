import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_weather/app/app_keys.dart';
import 'package:flutter_weather/app/app_localization.dart';
import 'package:flutter_weather/app/utils/common_utils.dart';
import 'package:flutter_weather/app/utils/snackbar_utils.dart';
import 'package:flutter_weather/app/widgets/app_ui_overlay_style.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/enums/enums.dart';
import 'package:flutter_weather/forecast/forecast_form.dart';
import 'package:flutter_weather/forecast/forecast_utils.dart';
import 'package:flutter_weather/forecast/view/forecast_view.dart';
import 'package:flutter_weather/models/models.dart';
import 'package:iso_countries/country.dart';
import 'package:iso_countries/iso_countries.dart';

class ForecastFormView extends StatelessWidget {
  static Route route() =>
      MaterialPageRoute<void>(builder: (_) => ForecastFormView());

  const ForecastFormView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) =>
      ForecastPageView();
}

class ForecastPageView extends StatefulWidget {
  ForecastPageView({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ForecastFormViewState();
}

class _ForecastFormViewState extends State<ForecastPageView> {
  ForecastFormController? _formController;
  num _currentPage = 0;

  @override
  void initState() {
    _formController = ForecastFormController();
    super.initState();
  }

  @override
  void dispose() {
    _formController!.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) =>
      AppUiOverlayStyle(
        systemNavigationBarIconBrightness:
            (context.watch<AppBloc>().state.colorTheme)
                ? Brightness.dark
                : null,
        child: Scaffold(
          appBar: AppBar(
            title: Text(getTitle(context, _currentPage)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () async => await _tapBack(),
            ),
          ),
          body: BlocListener<AppBloc, AppState>(
            listener: _blocListener,
            child: WillPopScope(
              onWillPop: () => _willPopCallback(context.read<AppBloc>().state),
              child: _buildBody(context.watch<AppBloc>().state),
            ),
          ),
          extendBody: true,
          extendBodyBehindAppBar: true,
        ),
      );

  void _blocListener(
    BuildContext context,
    AppState state,
  ) {
    if (state.crudStatus != null) {
      switch (state.crudStatus) {
        case CRUDStatus.updated:
          closeKeyboard(context);
          Navigator.of(context)
              .pushAndRemoveUntil(ForecastView.route(), (route) => false);
          break;

        case CRUDStatus.deleted:
          closeKeyboard(context);
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
    if (_currentPage > 0) {
      await _formController!.animateToPage!(0);
      return Future.value(false);
    }

    context.read<AppBloc>().add(ClearActiveForecastId());
    return Future.value(true);
  }

  Widget _buildBody(
    AppState state,
  ) =>
      ForecastForm(
        buttonKey: Key(AppKeys.saveForecastButtonKey),
        formController: _formController,
        saveButtonText: AppLocalizations.of(context)!.save,
        deleteButtonText: AppLocalizations.of(context)!.delete,
        forecast: state.forecasts.isNullOrZeroLength()
            ? null
            : state.forecasts[state.selectedForecastIndex],
        forecasts: state.forecasts,
        onSuccess: _onSuccess,
        onFailure: _onFailure,
        onPageChange: _onPageChange,
      );

  Future<void> _tapBack() async {
    if (_currentPage > 0) {
      await _formController!.animateToPage!(0);
    } else {
      context.read<AppBloc>().add(ClearActiveForecastId());
      Navigator.of(context).pop();
    }
  }

  void _onSuccess(
    BuildContext context,
    FormBlocSuccess<String, String> formState,
  ) async {
    closeKeyboard(context);
    Map<String, dynamic> forecastData = formState.toJson();

    final AppState appState = context.read<AppBloc>().state;
    final Country? country = (await IsoCountries.iso_countries)
        .firstWhereOrNull(
            (Country _country) => _country.name == forecastData['countryCode']);

    forecastData['countryCode'] = (country == null)
        ? null // AppConfig.instance.defaultCountryCode
        : country.countryCode;

    if (forecastData['primary']) {
      Forecast? primaryForecast = appState.forecasts
          .firstWhereOrNull((Forecast forecast) => forecast.primary!);

      if (primaryForecast != null) {
        // Remove the status from the current primary forecast
        context.read<AppBloc>().add(RemovePrimaryStatus(primaryForecast));
      }
    }

    context
        .read<AppBloc>()
        .add(UpdateForecast(context, appState.activeForecastId, forecastData));
  }

  void _onFailure(
    BuildContext context,
    FormBlocFailure<String, String> state,
  ) {
    closeKeyboard(context);
    showSnackbar(context, state.failureResponse!);
  }

  void _onPageChange(
    num currentPage,
  ) {
    setState(() => _currentPage = currentPage);
  }
}
