import 'package:equatable/equatable.dart';
import 'package:flutter_weather/enums/enums.dart';

class Units extends Equatable {
  final TemperatureUnit temperature;
  final WindSpeedUnit windSpeed;

  Units({
    this.temperature: TemperatureUnit.fahrenheit,
    this.windSpeed: WindSpeedUnit.mph,
  });

  const Units.initial({
    this.temperature: TemperatureUnit.fahrenheit,
    this.windSpeed: WindSpeedUnit.mph,
  });

  Units copyWith({
    TemperatureUnit? temperature,
    WindSpeedUnit? windSpeed,
  }) =>
      Units(
        temperature: temperature ?? this.temperature,
        windSpeed: windSpeed ?? this.windSpeed,
      );

  static Units fromJson(
    dynamic json,
  ) =>
      (json == null)
          ? Units()
          : Units(
              temperature: getTemperatureUnit(json['temperatureUnit']),
              windSpeed: getWindSpeedUnit(json['windSpeedUnit']),
            );

  dynamic toJson() => {
        'temperature': temperature.units,
        'windSpeed': windSpeed.units,
      };

  @override
  List<Object?> get props => [
        temperature,
        windSpeed,
      ];

  @override
  String toString() =>
      'Units{temperature: $temperature, windSpeed: $windSpeed}';
}
