import 'package:equatable/equatable.dart';

abstract class ForecastEvent extends Equatable {
  const ForecastEvent();

  @override
  List<Object> get props => [];
}

class SelectedForecastIndex extends ForecastEvent {
  final int index;

  const SelectedForecastIndex(
    this.index,
  );

  @override
  List<Object> get props => [index];
}
