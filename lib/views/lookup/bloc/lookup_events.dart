part of 'lookup_bloc.dart';

abstract class LookupEvent extends Equatable {
  const LookupEvent();

  @override
  List<Object> get props => [];
}

class LookupForecast extends LookupEvent {
  final String postalCode;
  final String countryCode;
  final TemperatureUnit temperatureUnit;

  const LookupForecast(
    this.postalCode,
    this.countryCode,
    this.temperatureUnit,
  );

  @override
  List<Object> get props => [postalCode, countryCode, temperatureUnit];
}

class ClearForecast extends LookupEvent {
  const ClearForecast();

  @override
  List<Object> get props => [];
}
