import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'forecast_events.dart';
part 'forecast_state.dart';

class ForecastBloc extends Bloc<ForecastEvent, ForecastState> {
  ForecastBloc() : super(ForecastState.initial());

  ForecastState get initialState => ForecastState.initial();

  @override
  Stream<ForecastState> mapEventToState(
    ForecastEvent event,
  ) async* {
    if (event is SetActiveForecastId) {
      yield _mapSetActiveForecastIdToState(event);
    } else if (event is ClearActiveForecastId) {
      yield _mapClearActiveForecastIdToState(event);
    }
  }

  ForecastState _mapSetActiveForecastIdToState(
    SetActiveForecastId event,
  ) =>
      state.copyWith(
        activeForecastId: event.forecastId,
      );

  ForecastState _mapClearActiveForecastIdToState(
    ClearActiveForecastId event,
  ) =>
      state.copyWith(
        activeForecastId: null,
      );
}
