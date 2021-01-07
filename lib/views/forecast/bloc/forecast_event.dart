part of 'forecast_bloc.dart';

abstract class ForecastEvent extends Equatable {
  const ForecastEvent();

  @override
  List<Object> get props => [];
}

class SetActiveForecastId extends ForecastEvent {
  final String activeForecastId;

  const SetActiveForecastId(
    this.activeForecastId,
  );

  @override
  List<Object> get props => [activeForecastId];
}

class ClearActiveForecastId extends ForecastEvent {
  const ClearActiveForecastId();

  @override
  List<Object> get props => [];
}
