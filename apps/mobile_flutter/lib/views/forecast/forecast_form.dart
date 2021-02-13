import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_weather/app_keys.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/model.dart';
import 'package:flutter_weather/theme.dart';
import 'package:flutter_weather/views/forecast/bloc/forecast_form_bloc.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/widgets/app_form_button.dart';
import 'package:flutter_weather/widgets/app_select_dialog.dart';

class ForecastForm extends StatelessWidget {
  final Key buttonKey;
  final Forecast forecast;
  final List<Forecast> forecasts;
  final String saveButtonText;
  final String deleteButtonText;
  final Function(
    BuildContext context,
    FormBlocSuccess<String, String> state,
  ) onSuccess;

  final Function(
    BuildContext context,
    FormBlocFailure<String, String> state,
  ) onFailure;

  const ForecastForm({
    Key key,
    this.buttonKey,
    this.forecast,
    this.forecasts,
    this.saveButtonText,
    this.deleteButtonText,
    this.onSuccess,
    this.onFailure,
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
          forecast: forecast,
          saveButtonText: saveButtonText,
          deleteButtonText: deleteButtonText,
          onSuccess: onSuccess,
          onFailure: onFailure,
        ),
      );
}

class ForecastPageForm extends StatefulWidget {
  final Key buttonKey;
  final Forecast forecast;
  final String saveButtonText;
  final String deleteButtonText;
  final Function(
    BuildContext context,
    FormBlocSuccess<String, String> state,
  ) onSuccess;

  final Function(
    BuildContext context,
    FormBlocFailure<String, String> state,
  ) onFailure;

  ForecastPageForm({
    Key key,
    this.buttonKey,
    this.forecast,
    this.saveButtonText,
    this.deleteButtonText,
    this.onSuccess,
    this.onFailure,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ForecastPageFormState();
}

class _ForecastPageFormState extends State<ForecastPageForm> {
  bool _submitting = false;
  bool _deleting = false;

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
          BlocListener<AppBloc, AppState>(
            listener: _blocListener,
          ),
        ],
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFieldBlocBuilder(
                key: Key(AppKeys.locationCityKey),
                textFieldBloc: context.watch<ForecastFormBloc>().cityName,
                keyboardType: TextInputType.streetAddress,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).city,
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
                  labelText: AppLocalizations.of(context).postalCode,
                  prefixIcon: Icon(
                    Icons.place,
                    color: AppTheme.primaryColor,
                  ),
                ),
                padding: const EdgeInsets.only(bottom: 0.0),
              ),
              AppSelectDialogFieldBlocBuilder(
                key: Key(AppKeys.locationCountryKey),
                selectFieldBloc: context.watch<ForecastFormBloc>().countryCode,
              ),
              _buildButtons(),
            ],
          ),
        ),
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
            color: AppTheme.dangerColor,
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
    widget.onSuccess(context, state);
    setState(() => _submitting = false);
  }

  void _onFailure(
    BuildContext context,
    FormBlocFailure<String, String> state,
  ) {
    widget.onFailure(context, state);
    setState(() => _submitting = false);
  }

  void _tapSubmit() => context.read<ForecastFormBloc>().submit();

  void _tapDelete() {
    Widget noButton = FlatButton(
      child: Text(
        AppLocalizations.of(context).no,
        style: TextStyle(color: AppTheme.primaryColor),
      ),
      onPressed: () => Navigator.of(context).pop(),
    );

    Widget yesButton = FlatButton(
      child: Text(
        AppLocalizations.of(context).yes,
        style: TextStyle(color: AppTheme.dangerColor),
      ),
      onPressed: _tapConfirmDelete,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(AppLocalizations.of(context).deleteForecast),
        content: Text(AppLocalizations.of(context).forecastDeletedText),
        actions: [
          noButton,
          yesButton,
        ],
      ),
    );
  }

  void _tapConfirmDelete() =>
      context.read<AppBloc>().add(DeleteForecast(widget.forecast.id));
}
