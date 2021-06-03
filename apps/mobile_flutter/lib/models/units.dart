import 'package:equatable/equatable.dart';
import 'package:flutter_weather/enums/enums.dart';
import 'package:flutter_weather/enums/pressure_unit.dart';

class Units extends Equatable {
  final TemperatureUnit temperature;
  final WindSpeedUnit windSpeed;
  final PressureUnit pressure;

  Units({
    this.temperature: TemperatureUnit.fahrenheit,
    this.windSpeed: WindSpeedUnit.mph,
    this.pressure: PressureUnit.inhg,
  });

  const Units.initial({
    this.temperature: TemperatureUnit.fahrenheit,
    this.windSpeed: WindSpeedUnit.mph,
    this.pressure: PressureUnit.inhg,
  });

  Units copyWith({
    TemperatureUnit? temperature,
    WindSpeedUnit? windSpeed,
    PressureUnit? pressure,
  }) =>
      Units(
        temperature: temperature ?? this.temperature,
        windSpeed: windSpeed ?? this.windSpeed,
        pressure: pressure ?? this.pressure,
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
            );

  dynamic toJson() => {
        'temperature': temperature.units,
        'windSpeed': windSpeed.units,
        'pressure': pressure.units,
      };

  @override
  List<Object?> get props => [
        temperature,
        windSpeed,
        pressure,
      ];

  @override
  String toString() =>
      'Units{temperature: $temperature, windSpeed: $windSpeed, ' +
      'pressure: $pressure}';
}
