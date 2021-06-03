import 'package:equatable/equatable.dart';
import 'package:flutter_weather/enums/enums.dart';
import 'package:flutter_weather/enums/pressure_unit.dart';

class Units extends Equatable {
  final TemperatureUnit temperature;
  final WindSpeedUnit windSpeed;
  final PressureUnit pressure;
  final DistanceUnit distance;

  Units({
    this.temperature: TemperatureUnit.fahrenheit,
    this.windSpeed: WindSpeedUnit.mph,
    this.pressure: PressureUnit.inhg,
    this.distance: DistanceUnit.mi,
  });

  const Units.initial({
    this.temperature: TemperatureUnit.fahrenheit,
    this.windSpeed: WindSpeedUnit.mph,
    this.pressure: PressureUnit.inhg,
    this.distance: DistanceUnit.mi,
  });

  Units copyWith({
    TemperatureUnit? temperature,
    WindSpeedUnit? windSpeed,
    PressureUnit? pressure,
    DistanceUnit? distance,
  }) =>
      Units(
        temperature: temperature ?? this.temperature,
        windSpeed: windSpeed ?? this.windSpeed,
        pressure: pressure ?? this.pressure,
        distance: distance ?? this.distance,
      );

  static Units fromJson(
    dynamic json,
  ) =>
      (json == null)
          ? Units()
          : Units(
              temperature: getTemperatureUnit(json['temperatureUnit']),
              windSpeed: getWindSpeedUnit(json['windSpeedUnit']),
              pressure: getPressureUnit(json['pressureUnit']),
              distance: getDistanceUnit(json['distanceUnit']),
            );

  dynamic toJson() => {
        'temperature': temperature.units,
        'windSpeed': windSpeed.units,
        'pressure': pressure.units,
        'distance': distance.units,
      };

  @override
  List<Object?> get props => [
        temperature,
        windSpeed,
        pressure,
        distance,
      ];

  @override
  String toString() =>
      'Units{temperature: $temperature, windSpeed: $windSpeed, ' +
      'pressure: $pressure, distance: $distance}';
}
