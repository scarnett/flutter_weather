import 'package:flutter_weather/views/forecast/bloc/bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ForecastBloc extends HydratedBloc<ForecastEvent, ForecastState> {
  ForecastBloc() : super(ForecastState.initial());

  ForecastState get initialState => ForecastState.initial();

  @override
  Stream<ForecastState> mapEventToState(
    ForecastEvent event,
  ) async* {
    if (event is SelectedForecastIndex) {
      yield _mapSelectedForecastIndexToStates(event);
    }
  }

  ForecastState _mapSelectedForecastIndexToStates(
    SelectedForecastIndex event,
  ) =>
      state.copyWith(
        selectedForecastIndex: event.index,
      );

  @override
  ForecastState fromJson(
    Map<String, dynamic> json,
  ) =>
      ForecastState(
        selectedForecastIndex: json['SelectedForecastIndex'],
      );

  @override
  Map<String, dynamic> toJson(
    ForecastState state,
  ) =>
      {
        'SelectedForecastIndex': state.selectedForecastIndex,
      };
}
