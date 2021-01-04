import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_weather/bloc/bloc.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/model.dart';
import 'package:flutter_weather/views/lookup/bloc/bloc.dart';
import 'package:flutter_weather/widgets/app_form_button.dart';
import 'package:flutter_weather/widgets/app_select_dialog.dart';
import 'package:iso_countries/country.dart';
import 'package:iso_countries/iso_countries.dart';

class LookupForm extends StatelessWidget {
  const LookupForm({
    Key key,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) =>
      BlocProvider<LookupFormBloc>(
        create: (BuildContext context) => LookupFormBloc(),
        child: LookupPageForm(),
      );
}

class LookupPageForm extends StatefulWidget {
  LookupPageForm({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LookupPageFormState();
}

class _LookupPageFormState extends State<LookupPageForm> {
  bool _submitting = false;

  @override
  Widget build(
    BuildContext context,
  ) =>
      FormBlocListener<LookupFormBloc, String, String>(
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
                textFieldBloc: context.watch<LookupFormBloc>().postalCode,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).postalCode,
                  prefixIcon: Icon(
                    Icons.place,
                    color: Colors.deepPurple[400],
                  ),
                ),
              ),
              AppSelectDialogFieldBlocBuilder(
                selectFieldBloc: context.watch<LookupFormBloc>().country,
              ),
              AppFormButton(
                text: _submitting ? null : AppLocalizations.of(context).lookup,
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

  void _tapLookup() => context.read<LookupFormBloc>().submit();
}
