import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_weather/localization.dart';
import 'package:flutter_weather/utils/common_utils.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:iso_countries/country.dart';
import 'package:iso_countries/iso_countries.dart';

class ForecastFormBloc extends FormBloc<String, String> {
  BuildContext? _context;
  Forecast? _initialForecast;
  List<Forecast>? _forecasts;

  final TextFieldBloc cityName = TextFieldBloc(name: 'cityName');
  final TextFieldBloc postalCode = TextFieldBloc(name: 'postalCode');
  final TextFieldBloc countryCode = TextFieldBloc(name: 'countryCode');
  final BooleanFieldBloc primary = BooleanFieldBloc(name: 'primary');

  ForecastFormBloc({
    BuildContext? context,
    Forecast? initialForecast,
    List<Forecast>? forecasts,
  }) : super(isLoading: true) {
    _context = context;
    _initialForecast = initialForecast;
    _forecasts = forecasts;

    addFieldBlocs(
      fieldBlocs: [
        cityName,
        postalCode,
        countryCode,
        primary,
      ],
    );
  }

  @override
  void onLoading() async {
    if (_initialForecast != null) {
      if (_initialForecast!.city != null) {
        cityName.updateInitialValue(_initialForecast!.cityName);
      }

      if (_initialForecast!.postalCode != null) {
        postalCode.updateInitialValue(_initialForecast!.postalCode);
      }

      if (_initialForecast!.countryCode != null) {
        final Country? isoCountry = (await IsoCountries.iso_countries)
            .firstWhereOrNull(
                (e) => e.countryCode == _initialForecast!.countryCode);

        if (isoCountry != null) {
          countryCode.updateInitialValue(isoCountry.name);
        }
      }

      if (_forecasts.isNullOrZeroLength()) {
        primary.updateInitialValue(true);
      } else {
        primary.updateInitialValue(_initialForecast!.primary);
      }
    } else if (_forecasts.isNullOrZeroLength()) {
      primary.updateInitialValue(true);
    }

    emitLoaded();
  }

  @override
  void onSubmitting() async {
    bool _hasError = false;

    if (cityName.value.isNullOrEmpty() && postalCode.value.isNullOrEmpty()) {
      emitFailure(
          failureResponse:
              AppLocalizations.of(_context!)!.forecastBadForecastInput);
      return;
    }

    _forecasts!.forEach((Forecast forecast) {
      if (!forecast.cityName.isNullOrEmpty() &&
          !forecast.countryCode.isNullOrEmpty() &&
          (forecast.cityName!.toLowerCase() == cityName.value!.toLowerCase()) &&
          (forecast.countryCode!.toLowerCase() ==
              countryCode.value!.toLowerCase())) {
        if ((_initialForecast == null) ||
            (_initialForecast!.id != forecast.id)) {
          cityName.addFieldError(
            AppLocalizations.of(_context!)!.forecastCityAlreadyExists,
            isPermanent: true,
          );

          emitFailure(
              failureResponse:
                  AppLocalizations.of(_context!)!.forecastAlreadyExists);

          _hasError = true;
        }
      } else if (!forecast.postalCode.isNullOrEmpty() &&
          (forecast.postalCode!.toLowerCase() ==
              postalCode.value!.toLowerCase()) &&
          (forecast.postalCode!.toLowerCase() ==
              postalCode.value!.toLowerCase())) {
        if ((_initialForecast == null) ||
            (_initialForecast!.id != forecast.id)) {
          postalCode.addFieldError(
            AppLocalizations.of(_context!)!.forecastPostalCodeAlreadyExists,
            isPermanent: true,
          );

          emitFailure(
              failureResponse:
                  AppLocalizations.of(_context!)!.forecastAlreadyExists);

          _hasError = true;
        }
      }
    });

    if (!_hasError) {
      emitSuccess(canSubmitAgain: true);
    }
  }

  @override
  Future<void> close() async {
    super.close();
    cityName.close();
    postalCode.close();
    countryCode.close();
  }
}
