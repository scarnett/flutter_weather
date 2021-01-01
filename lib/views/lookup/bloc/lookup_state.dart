part of 'lookup_bloc.dart';

@immutable
class LookupState extends Equatable {
  final String postalCode;
  final String countryCode;
  final Forecast lookupForecast;
  final LookupStatus status;

  const LookupState._({
    this.postalCode,
    this.countryCode,
    this.lookupForecast,
    this.status,
  });

  const LookupState.initial() : this._();

  const LookupState.clear() : this._();

  LookupState copyWith({
    String postalCode,
    String countryCode,
    Forecast lookupForecast,
    Nullable<LookupStatus> status,
  }) =>
      LookupState._(
        postalCode: postalCode ?? this.postalCode,
        countryCode: countryCode ?? this.countryCode,
        lookupForecast: lookupForecast ?? this.lookupForecast,
        status: (status == null) ? this.status : status.value,
      );

  @override
  List<Object> get props => [postalCode, countryCode, lookupForecast, status];

  @override
  String toString() =>
      'LookupState{postalCode: $postalCode, countryCode: $countryCode, ' +
      'lookupForecast: $lookupForecast, status: $status}';
}
