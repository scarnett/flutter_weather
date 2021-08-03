import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_weather/app/app_keys.dart';
import 'package:flutter_weather/app/app_localization.dart';
import 'package:flutter_weather/app/app_theme.dart';
import 'package:flutter_weather/app/bloc/bloc.dart';
import 'package:flutter_weather/app/utils/utils.dart';
import 'package:flutter_weather/app/widgets/widgets.dart';
import 'package:flutter_weather/enums/enums.dart';
import 'package:flutter_weather/forecast/forecast.dart';
import 'package:flutter_weather/models/models.dart';
import 'package:iso_countries/country.dart';

class ForecastFormController {
  Future<void> Function(num page)? animateToPage;

  void dispose() {
    animateToPage = null;
  }
}

class ForecastForm extends StatelessWidget {
  final Key? buttonKey;
  final ForecastFormController? formController;
  final Forecast? forecast;
  final List<Forecast>? forecasts;
  final String? saveButtonText;
  final String? deleteButtonText;

  final Function(
    BuildContext context,
    FormBlocSuccess<String, String> state,
  )? onSuccess;

  final Function(
    BuildContext context,
    FormBlocFailure<String, String> state,
  )? onFailure;

  final Function(
    num currentPage,
  )? onPageChange;

  const ForecastForm({
    Key? key,
    this.buttonKey,
    this.formController,
    this.forecast,
    this.forecasts,
    this.saveButtonText,
    this.deleteButtonText,
    this.onSuccess,
    this.onFailure,
    this.onPageChange,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) =>
      BlocProvider<ForecastFormBloc>(
        create: (BuildContext context) => ForecastFormBloc(
          context: context,
          initialForecast: forecast,
          forecasts: forecasts,
        ),
        child: ForecastPageForm(
          buttonKey: buttonKey,
          formController: formController,
          forecast: forecast,
          saveButtonText: saveButtonText,
          deleteButtonText: deleteButtonText,
          onSuccess: onSuccess,
          onFailure: onFailure,
          onPageChange: onPageChange,
        ),
      );
}

class ForecastPageForm extends StatefulWidget {
  final Key? buttonKey;
  final ForecastFormController? formController;
  final Forecast? forecast;
  final String? saveButtonText;
  final String? deleteButtonText;
  final Function(
    BuildContext context,
    FormBlocSuccess<String, String> state,
  )? onSuccess;

  final Function(
    BuildContext context,
    FormBlocFailure<String, String> state,
  )? onFailure;

  final Function(
    num currentPage,
  )? onPageChange;

  ForecastPageForm({
    Key? key,
    this.buttonKey,
    this.formController,
    this.forecast,
    this.saveButtonText,
    this.deleteButtonText,
    this.onSuccess,
    this.onFailure,
    this.onPageChange,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ForecastPageFormState();
}

class _ForecastPageFormState extends State<ForecastPageForm> {
  PageController? _pageController;
  bool _submitting = false;
  bool _deleting = false;

  late FocusNode _cityFocusNode;
  late FocusNode _postalCodeFocusNode;

  @override
  void initState() {
    super.initState();
    ForecastFormController? _formController = widget.formController;
    if (_formController != null) {
      _formController.animateToPage = _animateToPage;
      // _onPageChange(0);
    }

    _pageController = PageController(keepPage: true)
      ..addListener(() {
        _onPageChange(_pageController!.page ?? 0);
      });

    _cityFocusNode = FocusNode()..addListener(() => setState(() => {}));
    _postalCodeFocusNode = FocusNode()..addListener(() => setState(() => {}));
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) =>
      MultiBlocListener(
        listeners: [
          FormBlocListener<ForecastFormBloc, String, String>(
            onSubmitting: _onSubmitting,
            onSuccess: _onSuccess,
            onFailure: _onFailure,
          ),
          BlocListener<AppBloc, AppState>(listener: _blocListener),
        ],
        child: _buildContent(),
      );

  void _blocListener(
    BuildContext context,
    AppState state,
  ) {
    if (state.crudStatus != null) {
      switch (state.crudStatus) {
        case CRUDStatus.deleting:
          setState(() => _deleting = true);
          break;

        case CRUDStatus.deleted:
          Navigator.of(context).pop();
          setState(() => _deleting = false);
          break;

        default:
          break;
      }
    }
  }

  Widget _buildContent() => PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildForm(),
          ForecastCountryPicker(
            selectedCountryCode:
                context.watch<ForecastFormBloc>().countryCode.value,
            onTap: (Country country) async => await _tapCountry(country),
          ),
        ],
      );

  Widget _buildForm() => SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: AppUiSafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFieldBlocBuilder(
                key: Key(AppKeys.locationCityKey),
                focusNode: _cityFocusNode,
                textFieldBloc: context.watch<ForecastFormBloc>().cityName,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.city,
                  labelStyle: getInputTextLabelStyle(_cityFocusNode),
                  prefixIcon: Icon(
                    Icons.location_city,
                    color: AppTheme.primaryColor,
                  ),
                ),
                padding: const EdgeInsets.only(bottom: 0.0),
              ),
              TextFieldBlocBuilder(
                key: Key(AppKeys.locationPostalCodeKey),
                focusNode: _postalCodeFocusNode,
                textFieldBloc: context.watch<ForecastFormBloc>().postalCode,
                keyboardType: TextInputType.streetAddress,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.postalCode,
                  labelStyle: getInputTextLabelStyle(_postalCodeFocusNode),
                  prefixIcon: Icon(
                    Icons.place,
                    color: AppTheme.primaryColor,
                  ),
                ),
                padding: const EdgeInsets.only(bottom: 0.0),
              ),
              TextFieldBlocBuilder(
                key: Key(AppKeys.locationCountryKey),
                textFieldBloc: context.watch<ForecastFormBloc>().countryCode,
                keyboardType: TextInputType.text,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.country,
                  prefixIcon: Icon(
                    Icons.language,
                    color: AppTheme.primaryColor,
                  ),
                ),
                padding: const EdgeInsets.only(bottom: 10.0),
                onTap: () => animatePage(_pageController!, page: 1),
              ),
              _buildButtons(),
            ],
          ),
        ),
      );

  Widget _buildButtons() {
    AppState state = context.watch<AppBloc>().state;
    List<Widget> buttons = <Widget>[]..add(
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: AppFormButton(
            key: widget.buttonKey,
            text: _submitting ? null : widget.saveButtonText,
            icon: _submitting
                ? SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child: AppProgressIndicator(color: Colors.white),
                  )
                : const Icon(Icons.check, size: 16.0),
            onTap: _submitting ? null : _tapSubmit,
          ),
        ),
      );

    if (state.activeForecastId != null) {
      buttons.add(
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: AppFormButton(
            key: Key(AppKeys.deleteForecastButtonKey),
            text: _deleting ? null : widget.deleteButtonText,
            buttonColor: AppTheme.dangerColor,
            icon: _deleting
                ? SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child: AppProgressIndicator(color: Colors.white),
                  )
                : const Icon(Icons.close, size: 16.0),
            onTap: _deleting ? null : _tapDelete,
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: buttons,
    );
  }

  void _onSubmitting(
    BuildContext context,
    FormBlocSubmitting<String, String> state,
  ) =>
      setState(() => _submitting = true);

  void _onSuccess(
    BuildContext context,
    FormBlocSuccess<String, String> state,
  ) {
    widget.onSuccess!(context, state);
    setState(() => _submitting = false);
  }

  void _onFailure(
    BuildContext context,
    FormBlocFailure<String, String> state,
  ) {
    widget.onFailure!(context, state);
    setState(() => _submitting = false);
  }

  void _onPageChange(
    num currentPage,
  ) {
    widget.onPageChange!(currentPage);
  }

  void _tapSubmit() => context.read<ForecastFormBloc>().submit();

  Future<void> _animateToPage(
    num page,
  ) async =>
      await animatePage(_pageController!, page: page);

  void _tapDelete() {
    Widget noButton = TextButton(
      child: Text(
        AppLocalizations.of(context)!.no,
        style: TextStyle(color: AppTheme.primaryColor),
      ),
      onPressed: () => Navigator.of(context).pop(),
    );

    Widget yesButton = TextButton(
      child: Text(
        AppLocalizations.of(context)!.yes,
        style: const TextStyle(color: Colors.white),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(AppTheme.dangerColor),
      ),
      onPressed: _tapConfirmDelete,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteForecast),
        content: Text(AppLocalizations.of(context)!.forecastDeletedText),
        actions: [
          noButton,
          yesButton,
        ],
      ),
    );
  }

  Future<void> _tapCountry(
    Country? country,
  ) async {
    if (country != null) {
      context
          .read<ForecastFormBloc>()
          .countryCode
          .updateInitialValue(country.countryCode);

      await animatePage(_pageController!, page: 0);
    }
  }

  void _tapConfirmDelete() =>
      context.read<AppBloc>().add(DeleteForecast(widget.forecast!.id));
}
