part of 'lookup_bloc.dart';

abstract class LookupEvent extends Equatable {
  const LookupEvent();

  @override
  List<Object> get props => [];
}

class LookupForecast extends LookupEvent {
  final Map<String, dynamic> lookupData;
  final TemperatureUnit temperatureUnit;
  final bool isPremium;

  const LookupForecast(
    this.lookupData,
    this.temperatureUnit,
    this.isPremium,
  );

  @override
  List<Object> get props => [
        lookupData,
        temperatureUnit,
        isPremium,
      ];
}

class ClearLookupForecast extends LookupEvent {
  const ClearLookupForecast();

  @override
  List<Object> get props => [];
}
