import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/app/app_config.dart';
import 'package:flutter_weather/app/utils/utils.dart';
import 'package:flutter_weather/enums/enums.dart';
import 'package:flutter_weather/models/models.dart';
import 'package:flutter_weather/services/services.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:sentry/sentry.dart';

part 'lookup_events.dart';
part 'lookup_state.dart';

class LookupBloc extends Bloc<LookupEvent, LookupState> {
  LookupBloc() : super(LookupState.initial()) {
    on<LookupForecast>(_onLookupForecast);
    on<ClearLookupForecast>(_onClearLookupForecast);
  }

  LookupState get initialState => LookupState.initial();

  void _onLookupForecast(
    LookupForecast event,
    Emitter<LookupState> emit,
  ) async {
    emit(
      state.copyWith(
        status: Nullable<LookupStatus?>(null),
      ),
    );

    try {
      http.Client httpClient = http.Client();

      if (await hasConnectivity(
        client: httpClient,
        config: AppConfig.instance.config,
      )) {
        http.Response forecastResponse = await tryLookupForecast(
          client: httpClient,
          lookupData: event.lookupData,
          isPremium: event.isPremium,
        );

        if (forecastResponse.statusCode == 200) {
          Forecast forecast =
              Forecast.fromJson(jsonDecode(forecastResponse.body));

          http.Response forecastDetailsResponse = await fetchDetailedForecast(
            client: httpClient,
            longitude: forecast.city!.coord!.lon!,
            latitude: forecast.city!.coord!.lat!,
          );

          if (forecastDetailsResponse.statusCode == 200) {
            forecast = forecast.copyWith(
                details: Nullable<ForecastDetails?>(ForecastDetails.fromJson(
                    jsonDecode(forecastDetailsResponse.body))));
          }

          emit(
            state.copyWith(
              cityName: Nullable<String?>(event.lookupData['cityName']),
              postalCode: Nullable<String?>(event.lookupData['postalCode']),
              countryCode: Nullable<String?>(event.lookupData['countryCode']),
              lookupForecast: Nullable<Forecast>(forecast),
              status: Nullable<LookupStatus>(LookupStatus.forecastFound),
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: Nullable<LookupStatus>(LookupStatus.forecastNotFound),
            ),
          );
        }
      } else {
        emit(
          state.copyWith(
            status: Nullable<LookupStatus>(LookupStatus.forecastConnectivity),
          ),
        );
      }
    } on Exception catch (exception, stackTrace) {
      await Sentry.captureException(exception, stackTrace: stackTrace);

      emit(
        state.copyWith(
          status: Nullable<LookupStatus>(LookupStatus.forecastNotFound),
        ),
      );
    }
  }

  void _onClearLookupForecast(
    ClearLookupForecast event,
    Emitter<LookupState> emit,
  ) {
    emit(
      state.copyWith(
        lookupForecast: Nullable<Forecast?>(null),
      ),
    );
  }
}
