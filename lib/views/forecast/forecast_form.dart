import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/theme.dart';
import 'package:flutter_weather/views/forecast/bloc/forecast_form_bloc.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/widgets/app_form_button.dart';
import 'package:flutter_weather/widgets/app_select_dialog.dart';

class ForecastForm extends StatelessWidget {
  final Forecast forecast;
  final String buttonText;
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
    this.forecast,
    this.buttonText,
    this.onSuccess,
    this.onFailure,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) =>
      BlocProvider<ForecastFormBloc>(
        create: (BuildContext context) =>
            ForecastFormBloc(initialData: forecast),
        child: ForecastPageForm(
          forecast: forecast,
          buttonText: buttonText,
          onSuccess: onSuccess,
          onFailure: onFailure,
        ),
      );
}

class ForecastPageForm extends StatefulWidget {
  final Forecast forecast;
  final String buttonText;
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
    this.forecast,
    this.buttonText,
    this.onSuccess,
    this.onFailure,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ForecastPageFormState();
}

class _ForecastPageFormState extends State<ForecastPageForm> {
  bool _submitting = false;

  @override
  Widget build(
    BuildContext context,
  ) =>
      FormBlocListener<ForecastFormBloc, String, String>(
        onSubmitting: _onSubmitting,
        onSuccess: _onSuccess,
        onFailure: _onFailure,
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFieldBlocBuilder(
                textFieldBloc: context.watch<ForecastFormBloc>().postalCode,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).postalCode,
                  prefixIcon: Icon(
                    Icons.place,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
              AppSelectDialogFieldBlocBuilder(
                selectFieldBloc: context.watch<ForecastFormBloc>().country,
              ),
              AppFormButton(
                text: _submitting ? null : widget.buttonText,
                icon: _submitting
                    ? SizedBox(
                        height: 25.0,
                        width: 25.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : null,
                onTap: _submitting ? null : _tapSubmit,
              ),
            ],
          ),
        ),
      );

  void _onSubmitting(
    BuildContext context,
    FormBlocSubmitting<String, String> state,
  ) =>
      setState(() {
        _submitting = true;
      });

  void _onSuccess(
    BuildContext context,
    FormBlocSuccess<String, String> state,
  ) {
    widget.onSuccess(context, state);

    setState(() {
      _submitting = false;
    });
  }

  void _onFailure(
    BuildContext context,
    FormBlocFailure<String, String> state,
  ) =>
      widget.onFailure(context, state);

  void _tapSubmit() => context.read<ForecastFormBloc>().submit();
}
