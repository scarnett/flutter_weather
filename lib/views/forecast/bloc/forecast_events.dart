part of 'forecast_bloc.dart';

abstract class ForecastEvent extends Equatable {
  const ForecastEvent();

  @override
  List<Object> get props => [];
}

class SetActiveForecastId extends ForecastEvent {
  final String forecastId;

  const SetActiveForecastId(
    this.forecastId,
  );

  @override
  List<Object> get props => [forecastId];
}

class ClearActiveForecastId extends ForecastEvent {
  const ClearActiveForecastId();

  @override
  List<Object> get props => [];
}
