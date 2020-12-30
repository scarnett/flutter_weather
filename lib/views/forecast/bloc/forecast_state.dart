import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class ForecastState extends Equatable {
  final int selectedForecastIndex;

  ForecastState({
    this.selectedForecastIndex,
  });

  const ForecastState._({
    this.selectedForecastIndex = 0,
  });

  const ForecastState.initial() : this._();

  ForecastState copyWith({
    int selectedForecastIndex,
  }) =>
      ForecastState._(
        selectedForecastIndex:
            selectedForecastIndex ?? this.selectedForecastIndex,
      );

  @override
  List<Object> get props => [selectedForecastIndex];

  @override
  String toString() =>
      'ForecastState{selectedForecastIndex: $selectedForecastIndex}';
}
