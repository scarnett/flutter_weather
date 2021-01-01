part of 'lookup_bloc.dart';

abstract class LookupEvent extends Equatable {
  const LookupEvent();

  @override
  List<Object> get props => [];
}

class LookupForecast extends LookupEvent {
  final String postalCode;
  final String countryCode;

  const LookupForecast(
    this.postalCode,
    this.countryCode,
  );

  @override
  List<Object> get props => [postalCode, countryCode];
}
