import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_weather/app_keys.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/enums.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/theme.dart';
import 'package:flutter_weather/utils/common_utils.dart';
import 'package:flutter_weather/utils/date_utils.dart';
import 'package:flutter_weather/utils/snackbar_utils.dart';
import 'package:flutter_weather/views/forecast/forecast_form.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_display.dart';
import 'package:flutter_weather/views/lookup/bloc/bloc.dart';
import 'package:flutter_weather/views/lookup/lookup_model.dart';
import 'package:flutter_weather/views/lookup/lookup_utils.dart';
import 'package:flutter_weather/widgets/app_form_button.dart';
import 'package:flutter_weather/widgets/app_ui_overlay_style.dart';
import 'package:flutter_weather/widgets/app_ui_safe_area.dart';
import 'package:iso_countries/country.dart';
import 'package:iso_countries/iso_countries.dart';
import 'package:uuid/uuid.dart';

class LookupView extends StatelessWidget {
  static Route route() => MaterialPageRoute<void>(builder: (_) => LookupView());

  const LookupView({
    Key? key,
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
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LookupPageViewState();
}

class _LookupPageViewState extends State<LookupPageView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
      MultiBlocListener(
        listeners: [
          BlocListener<AppBloc, AppState>(listener: _appBlocListener),
          BlocListener<LookupBloc, LookupState>(listener: _lookupBlocListener),
        ],
        child: BlocBuilder<LookupBloc, LookupState>(
          builder: (
            BuildContext context,
            LookupState state,
          ) =>
              AppUiOverlayStyle(
            themeMode: context.watch<AppBloc>().state.themeMode,
            colorTheme: (context.watch<AppBloc>().state.colorTheme),
            systemNavigationBarIconBrightness:
                context.watch<AppBloc>().state.colorTheme
                    ? Brightness.dark
                    : null,
            child: Theme(
              data: (context.watch<AppBloc>().state.themeMode == ThemeMode.dark)
                  ? appDarkThemeData
                  : appLightThemeData,
              child: Scaffold(
                key: _scaffoldKey,
                appBar: AppBar(
                  title: Text(
                    getTitle(AppLocalizations.of(context), _currentPage)!,
                  ),
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => _handleBack(state),
                  ),
                ),
                body: WillPopScope(
                  onWillPop: () => _willPopCallback(state),
                  child: _buildContent(),
                ),
                extendBody: true,
                extendBodyBehindAppBar: true,
              ),
            ),
          ),
        ),
      );

  void _appBlocListener(
    BuildContext context,
    AppState state,
  ) {
    if (state.crudStatus != null) {
      switch (state.crudStatus) {
        case CRUDStatus.CREATED:
          closeKeyboard(context);
          Navigator.of(context).pop();
          break;

        default:
          break;
      }
    }
  }

  void _lookupBlocListener(
    BuildContext context,
    LookupState state,
  ) {
    if (state.status != null) {
      AppLocalizations? i18n = AppLocalizations.of(context);

      switch (state.status) {
        case LookupStatus.FORECAST_NOT_FOUND:
          closeKeyboard(context);
          showSnackbar(context, i18n!.lookupFailure);
          break;

        default:
          break;
      }
    }
  }

  Future<bool> _willPopCallback(
    LookupState state,
  ) {
    if (_currentPage > 0) {
      _formController!.animateToPage!(0);
      return Future.value(false);
    } else if (state.lookupForecast != null) {
      context.read<LookupBloc>().add(ClearLookupForecast());
      return Future.value(false);
    }

    return Future.value(true);
  }

  Widget _buildContent() {
    AppState appState = context.read<AppBloc>().state;
    Forecast? lookupForecast = context.read<LookupBloc>().state.lookupForecast;
    if (lookupForecast != null) {
      return SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: AppUiSafeArea(
          child: Column(
            children: <Widget>[
              ForecastDisplay(
                temperatureUnit: appState.temperatureUnit,
                themeMode: appState.themeMode,
                forecast: lookupForecast,
                showSixDayForecast: true,
                sliverView: false,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: AppFormButton(
                  key: Key(AppKeys.addThisForecastKey),
                  text: AppLocalizations.of(context)!.addThisForecast,
                  icon: Icon(Icons.add, size: 16.0),
                  onTap: _tapAddLocation,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ForecastForm(
      buttonKey: Key(AppKeys.locationLookupButtonKey),
      formController: _formController,
      saveButtonText: AppLocalizations.of(context)!.lookup,
      forecasts: context.read<AppBloc>().state.forecasts,
      onSuccess: _onSuccess,
      onFailure: _onFailure,
      onPageChange: _onPageChange,
    );
  }

  void _handleBack(
    LookupState state,
  ) {
    if (_currentPage > 0) {
      _formController!.animateToPage!(0);
    } else if (state.lookupForecast != null) {
      context.read<LookupBloc>().add(ClearLookupForecast());
    } else {
      Navigator.of(context).pop();
    }
  }

  void _tapAddLocation() {
    LookupState lookupState = context.read<LookupBloc>().state;
    Forecast forecast = lookupState.lookupForecast!.copyWith(
      id: Uuid().v4(),
      cityName: Nullable<String?>(lookupState.cityName),
      postalCode: Nullable<String?>(lookupState.postalCode),
      countryCode: Nullable<String?>(lookupState.countryCode),
      primary: Nullable<bool?>(lookupState.primary),
      lastUpdated: getNow(),
    );

    if (lookupState.primary!) {
      List<Forecast> forecasts = context.read<AppBloc>().state.forecasts;
      Forecast? primaryForecast =
          forecasts.firstWhereOrNull((Forecast forecast) => forecast.primary!);

      if (primaryForecast != null) {
        // Remove the status from the current primary forecast
        context.read<AppBloc>().add(RemovePrimaryStatus(primaryForecast));
      }
    }

    context.read<AppBloc>().add(AddForecast(forecast));
  }

  void _onSuccess(
    BuildContext context,
    FormBlocSuccess<String, String> state,
  ) async {
    Map<String, dynamic> lookupData = state.toJson();
    if (lookupData.containsKey('countryCode')) {
      final Country? country = (await IsoCountries.iso_countries)
          .firstWhereOrNull(
              (Country _country) => _country.name == lookupData['countryCode']);

      lookupData['countryCode'] = (country == null)
          ? null // AppConfig.instance.defaultCountryCode
          : country.countryCode;
    }

    context.read<LookupBloc>().add(LookupForecast(
          lookupData,
          context.read<AppBloc>().state.temperatureUnit,
        ));
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
