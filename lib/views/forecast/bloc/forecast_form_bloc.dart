import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:iso_countries/country.dart';
import 'package:iso_countries/iso_countries.dart';

class ForecastFormBloc extends FormBloc<String, String> {
  Forecast _initialData;

  final TextFieldBloc postalCode = TextFieldBloc(
    name: 'postalCode',
    validators: [
      FieldBlocValidators.required,
    ],
  );

  final SelectFieldBloc country = SelectFieldBloc(
    name: 'country',
  );

  ForecastFormBloc({
    Forecast initialData,
  }) : super(isLoading: true) {
    _initialData = initialData;

    addFieldBlocs(
      fieldBlocs: [
        postalCode,
        country,
      ],
    );
  }

  @override
  void onLoading() async {
    if (_initialData != null) {
      postalCode.updateInitialValue(_initialData.postalCode);

      final Country isoCountry = (await IsoCountries.iso_countries).firstWhere(
          (e) => e.countryCode == _initialData.countryCode,
          orElse: () => null);

      if (isoCountry != null) {
        country.updateInitialValue(isoCountry.name);
      }
    }

    emitLoaded();
  }

  @override
  void onSubmitting() async => emitSuccess(canSubmitAgain: true);

  @override
  Future<void> close() async {
    super.close();
    postalCode.close();
    country.close();
  }
}
