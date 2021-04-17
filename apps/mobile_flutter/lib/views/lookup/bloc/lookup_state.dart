part of 'lookup_bloc.dart';

@immutable
class LookupState extends Equatable {
  final String cityName;
  final String postalCode;
  final String countryCode;
  final bool primary;
  final Forecast lookupForecast;
  final LookupStatus status;

  LookupState({
    this.cityName,
    this.postalCode,
    this.countryCode,
    this.primary,
    this.lookupForecast,
    this.status,
  });

  const LookupState._({
    this.cityName,
    this.postalCode,
    this.countryCode,
    this.primary,
    this.lookupForecast,
    this.status,
  });

  const LookupState.initial() : this._();

  const LookupState.clear() : this._();

  LookupState copyWith({
    Nullable<String> cityName,
    Nullable<String> postalCode,
    Nullable<String> countryCode,
    Nullable<bool> primary,
    Nullable<Forecast> lookupForecast,
    Nullable<LookupStatus> status,
  }) =>
      LookupState._(
        cityName: (cityName == null) ? this.cityName : cityName.value,
        postalCode: (postalCode == null) ? this.postalCode : postalCode.value,
        countryCode:
            (countryCode == null) ? this.countryCode : countryCode.value,
        primary: (primary == null) ? this.primary : primary.value,
        lookupForecast: (lookupForecast == null)
            ? this.lookupForecast
            : lookupForecast.value,
        status: (status == null) ? this.status : status.value,
      );

  @override
  List<Object> get props => [
        cityName,
        postalCode,
        countryCode,
        primary,
        lookupForecast,
        status,
      ];

  @override
  String toString() =>
      'LookupState{cityName: $cityName, postalCode: $postalCode, ' +
      'countryCode: $countryCode, primary: $primary, ' +
      'lookupForecast: $lookupForecast, status: $status}';
}
