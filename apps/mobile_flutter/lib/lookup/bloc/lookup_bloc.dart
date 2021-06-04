import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/app/utils/utils.dart';
import 'package:flutter_weather/enums/enums.dart';
import 'package:flutter_weather/models/models.dart';
import 'package:flutter_weather/services/services.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:sentry/sentry.dart';

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
      status: Nullable<LookupStatus?>(null),
    );

    try {
      Response forecastResponse = await tryLookupForecast(event.lookupData);

      if (forecastResponse.statusCode == 200) {
        Forecast forecast =
            Forecast.fromJson(jsonDecode(forecastResponse.body));

        // TODO! premium
        Response forecastDetailsResponse = await fetchDetailedForecast(
          longitude: forecast.city!.coord!.lon!,
          latitude: forecast.city!.coord!.lat!,
        );

        if (forecastDetailsResponse.statusCode == 200) {
          forecast = forecast.copyWith(
              details: Nullable<ForecastDetails?>(ForecastDetails.fromJson(
                  jsonDecode(forecastDetailsResponse.body))));
        }

        yield state.copyWith(
          cityName: Nullable<String?>(event.lookupData['cityName']),
          postalCode: Nullable<String?>(event.lookupData['postalCode']),
          countryCode: Nullable<String?>(event.lookupData['countryCode']),
          primary: Nullable<bool?>(event.lookupData['primary']),
          lookupForecast: Nullable<Forecast>(forecast),
          status: Nullable<LookupStatus>(LookupStatus.forecastFound),
        );
      } else {
        yield state.copyWith(
          status: Nullable<LookupStatus>(LookupStatus.forecastNotFound),
        );
      }
    } on Exception catch (exception, stackTrace) {
      await Sentry.captureException(exception, stackTrace: stackTrace);

      yield state.copyWith(
        status: Nullable<LookupStatus>(LookupStatus.forecastNotFound),
      );
    }
  }

  Stream<LookupState> _mapClearLookupForecastToState(
    ClearLookupForecast event,
  ) async* {
    yield state.copyWith(
      lookupForecast: Nullable<Forecast?>(null),
    );
  }
}
