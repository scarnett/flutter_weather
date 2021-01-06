import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/model.dart';
import 'package:flutter_weather/views/forecast/bloc/forecast_form_bloc.dart';
import 'package:flutter_weather/views/lookup/bloc/bloc.dart';
import 'package:flutter_weather/widgets/app_form_button.dart';
import 'package:flutter_weather/widgets/app_select_dialog.dart';
import 'package:iso_countries/country.dart';
import 'package:iso_countries/iso_countries.dart';

class ForecastForm extends StatelessWidget {
  final String buttonText;

  const ForecastForm({
    Key key,
    this.buttonText,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) =>
      BlocProvider<ForecastFormBloc>(
        create: (BuildContext context) => ForecastFormBloc(),
        child: ForecastPageForm(buttonText: buttonText),
      );
}

class ForecastPageForm extends StatefulWidget {
  final String buttonText;

  ForecastPageForm({
    Key key,
    this.buttonText,
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
        onSuccess: (
          BuildContext context,
          FormBlocSuccess<String, String> state,
        ) =>
            _onSuccess(
                context, state, context.read<AppBloc>().state.temperatureUnit),
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
                    color: Colors.deepPurple[400],
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
                    : Icon(Icons.search),
                onTap: _submitting ? null : _tapLookup,
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
    TemperatureUnit temperatureUnit,
  ) async {
    setState(() {
      _submitting = false;
    });

    FocusScope.of(context).unfocus();
    Map<String, dynamic> json = state.toJson();
    final Country country = (await IsoCountries.iso_countries)
        .firstWhere((e) => e.name == json['country'], orElse: () => null);

    if (country != null) {
      context.read<LookupBloc>().add(LookupForecast(
            json['postalCode'],
            country.countryCode,
            temperatureUnit,
          ));
    } else {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).lookupFailure)));
    }
  }

  void _onFailure(
    BuildContext context,
    FormBlocFailure<String, String> state,
  ) {
    setState(() {
      _submitting = false;
    });

    FocusScope.of(context).unfocus();
    Scaffold.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).lookupFailure)));
  }

  void _tapLookup() => context.read<ForecastFormBloc>().submit();
}
