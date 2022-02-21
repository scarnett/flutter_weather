import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_weather/app/app_keys.dart';
import 'package:flutter_weather/app/app_localization.dart';
import 'package:flutter_weather/app/app_theme.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';
import 'package:flutter_weather/app/utils/utils.dart';
import 'package:flutter_weather/app/widgets/widgets.dart';
import 'package:flutter_weather/enums/enums.dart';
import 'package:flutter_weather/enums/message_type.dart';
import 'package:flutter_weather/forecast/forecast.dart';
import 'package:flutter_weather/lookup/lookup.dart';
import 'package:flutter_weather/models/models.dart';
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
                    getLookupTitle(AppLocalizations.of(context), _currentPage),
                  ),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () async => await _handleBack(state),
                  ),
                ),
                body: WillPopScope(
                  onWillPop: () async => await _willPopCallback(state),
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
        case CRUDStatus.created:
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
        case LookupStatus.forecastNotFound:
          closeKeyboard(context);
          showSnackbar(
            context,
            i18n!.lookupFailure,
            messageType: MessageType.danger,
          );

          break;

        case LookupStatus.forecastConnectivity:
          closeKeyboard(context);
          showSnackbar(
            context,
            i18n!.connectivityFailure,
            messageType: MessageType.danger,
          );

          break;

        default:
          break;
      }
    }
  }

  Future<bool> _willPopCallback(
    LookupState state,
  ) async {
    if (_currentPage > 0) {
      await _formController!.animateToPage!(0);
      return Future.value(false);
    } else if (state.lookupForecast != null) {
      context.read<LookupBloc>().add(ClearLookupForecast());
      return Future.value(false);
    }

    return Future.value(true);
  }

  Widget _buildContent() {
    Forecast? lookupForecast = context.read<LookupBloc>().state.lookupForecast;
    if (lookupForecast != null) {
      return SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: AppUiSafeArea(
          child: Column(
            children: <Widget>[
              ForecastDisplay(
                forecast: lookupForecast,
                sliverView: false,
                detailsEnabled: false,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: AppFormButton(
                  key: Key(AppKeys.addThisForecastKey),
                  text: AppLocalizations.of(context)!.addThisForecast,
                  icon: const Icon(Icons.add, size: 16.0),
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

  Future<void> _handleBack(
    LookupState state,
  ) async {
    if (_currentPage > 0) {
      await _formController!.animateToPage!(0);
    } else if (state.lookupForecast != null) {
      context.read<LookupBloc>().add(ClearLookupForecast());
    } else {
      Navigator.of(context).pop();
    }
  }

  void _tapAddLocation() {
    DateTime now = getNow();
    LookupState lookupState = context.read<LookupBloc>().state;
    Forecast forecast = lookupState.lookupForecast!.copyWith(
      id: Uuid().v4(),
      cityName: Nullable<String?>(lookupState.cityName),
      postalCode: Nullable<String?>(lookupState.postalCode),
      countryCode: Nullable<String?>(lookupState.countryCode),
      created: now,
      lastUpdated: now,
    );

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

    AppState appState = context.read<AppBloc>().state;
    context.read<LookupBloc>().add(LookupForecast(
          lookupData,
          appState.units.temperature,
          appState.isPremium,
        ));
  }

  void _onFailure(
    BuildContext context,
    FormBlocFailure<String, String> state,
  ) {
    closeKeyboard(context);
    showSnackbar(
      context,
      state.failureResponse!,
      messageType: MessageType.danger,
    );
  }

  void _onPageChange(
    num currentPage,
  ) {
    setState(() => _currentPage = currentPage);
  }
}
