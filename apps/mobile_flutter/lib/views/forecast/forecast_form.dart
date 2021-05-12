import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_weather/app_keys.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/enums.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/theme.dart';
import 'package:flutter_weather/utils/common_utils.dart';
import 'package:flutter_weather/views/forecast/bloc/forecast_form_bloc.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/widgets/forecast_country_picker.dart';
import 'package:flutter_weather/widgets/app_form_button.dart';
import 'package:iso_countries/country.dart';

class ForecastFormController {
  Function(num page)? animateToPage;

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
        case CRUDStatus.DELETING:
          setState(() => _deleting = true);
          break;

        case CRUDStatus.DELETED:
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
            onTap: _tapCountry,
          ),
        ],
      );

  Widget _buildForm() => SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFieldBlocBuilder(
              key: Key(AppKeys.locationCityKey),
              textFieldBloc: context.watch<ForecastFormBloc>().cityName,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.city,
                prefixIcon: Icon(
                  Icons.location_city,
                  color: AppTheme.primaryColor,
                ),
              ),
              padding: const EdgeInsets.only(bottom: 0.0),
            ),
            TextFieldBlocBuilder(
              key: Key(AppKeys.locationPostalCodeKey),
              textFieldBloc: context.watch<ForecastFormBloc>().postalCode,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.postalCode,
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
            SwitchFieldBlocBuilder(
              booleanFieldBloc: context.watch<ForecastFormBloc>().primary,
              body: GestureDetector(
                onTap: _tapPrimaryFieldText,
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(AppLocalizations.of(context)!.primaryForecast),
                ),
              ),
              padding: const EdgeInsets.all(0.0),
            ),
            _buildButtons(),
          ],
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
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Icon(Icons.check, size: 16.0),
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
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Icon(Icons.close, size: 16.0),
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

  void _animateToPage(
    num page,
  ) =>
      animatePage(_pageController!, page: page);

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
        style: TextStyle(color: AppTheme.dangerColor),
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

  void _tapCountry(
    Country? country,
  ) {
    if (country != null) {
      context
          .read<ForecastFormBloc>()
          .countryCode
          .updateInitialValue(country.countryCode);

      animatePage(_pageController!, page: 0);
    }
  }

  void _tapPrimaryFieldText() {
    // ignore: close_sinks
    BooleanFieldBloc primaryField = context.read<ForecastFormBloc>().primary;
    primaryField.updateInitialValue(!primaryField.value!);
  }

  void _tapConfirmDelete() =>
      context.read<AppBloc>().add(DeleteForecast(widget.forecast!.id));
}
