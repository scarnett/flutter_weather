import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:iso_countries/country.dart';
import 'package:iso_countries/iso_countries.dart';

class ForecastFormBloc extends FormBloc<String, String> {
  Forecast _initialData;

  final TextFieldBloc cityName = TextFieldBloc(
    name: 'cityName',
  );

  final TextFieldBloc postalCode = TextFieldBloc(
    name: 'postalCode',
  );

  final SelectFieldBloc countryCode = SelectFieldBloc(
    name: 'countryCode',
  );

  ForecastFormBloc({
    Forecast initialData,
  }) : super(isLoading: true) {
    _initialData = initialData;

    addFieldBlocs(
      fieldBlocs: [
        cityName,
        postalCode,
        countryCode,
      ],
    );
  }

  @override
  void onLoading() async {
    if (_initialData != null) {
      if (_initialData.city != null) {
        cityName.updateInitialValue(_initialData.cityName);
      }

      if (_initialData.postalCode != null) {
        postalCode.updateInitialValue(_initialData.postalCode);
      }

      if (_initialData.countryCode != null) {
        final Country isoCountry = (await IsoCountries.iso_countries)
            .firstWhere((e) => e.countryCode == _initialData.countryCode,
                orElse: () => null);

        if (isoCountry != null) {
          countryCode.updateInitialValue(isoCountry.name);
        }
      }
    }

    emitLoaded();
  }

  @override
  void onSubmitting() async => emitSuccess(canSubmitAgain: true);

  @override
  Future<void> close() async {
    super.close();
    cityName.close();
    postalCode.close();
    countryCode.close();
  }
}
