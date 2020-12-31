enum TemperatureUnit {
  celsius,
  fahrenheit,
}

TemperatureUnit getTemperatureUnit(
  String temperatureUnit,
) {
  switch (temperatureUnit) {
    case 'TemperatureUnit.celsius':
      return TemperatureUnit.celsius;

    case 'TemperatureUnit.fahrenheit':
    default:
      return TemperatureUnit.fahrenheit;
  }
}
