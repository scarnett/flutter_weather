part of 'forecast_bloc.dart';

@immutable
class ForecastState extends Equatable {
  final String activeForecastId;

  const ForecastState._({
    this.activeForecastId,
  });

  const ForecastState.initial() : this._();

  const ForecastState.clear() : this._();

  ForecastState copyWith({
    String activeForecastId,
  }) =>
      ForecastState._(
        activeForecastId: activeForecastId ?? this.activeForecastId,
      );

  @override
  List<Object> get props => [activeForecastId];

  @override
  String toString() => 'ForecastState{activeForecastId: $activeForecastId}';
}
