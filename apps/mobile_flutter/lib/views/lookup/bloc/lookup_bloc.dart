import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/model.dart';
import 'package:flutter_weather/utils/common_utils.dart';
import 'package:flutter_weather/views/forecast/forecast_model.dart';
import 'package:flutter_weather/views/forecast/forecast_service.dart';
import 'package:flutter_weather/views/lookup/lookup_model.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

part 'lookup_events.dart';
part 'lookup_state.dart';

class LookupBloc extends Bloc<LookupEvent, LookupState> {
  LookupBloc() : super(LookupState.initial());

  LookupState get initialState => LookupState.initial();

  @override
  Stream<LookupState> mapEventToState(
    LookupEvent event,
  ) async* {
    if (event is LookupForecast) {
      yield* _mapLookupForecastToState(event);
    } else if (event is ClearLookupForecast) {
      yield* _mapClearLookupForecastToState(event);
    }
  }

  Stream<LookupState> _mapLookupForecastToState(
    LookupForecast event,
  ) async* {
    yield state.copyWith(
      status: Nullable<LookupStatus>(null),
    );

    http.Response forecastResponse = await tryLookupForecast(event.lookupData);
    if (forecastResponse.statusCode == 200) {
      yield state.copyWith(
        cityName: Nullable<String>(event.lookupData['cityName']),
        postalCode: Nullable<String>(event.lookupData['postalCode']),
        countryCode: Nullable<String>(event.lookupData['countryCode']),
        primary: Nullable<bool>(event.lookupData['primary']),
        lookupForecast: Nullable<Forecast>(
            Forecast.fromJson(jsonDecode(forecastResponse.body))),
        status: Nullable<LookupStatus>(LookupStatus.FORECAST_FOUND),
      );
    } else {
      yield state.copyWith(
        status: Nullable<LookupStatus>(LookupStatus.FORECAST_NOT_FOUND),
      );
    }
  }

  Stream<LookupState> _mapClearLookupForecastToState(
    ClearLookupForecast event,
  ) async* {
    yield state.copyWith(
      lookupForecast: Nullable<Forecast>(null),
    );
  }
}
