enum TemperatureUnit {
  kelvin,
  celsius,
  fahrenheit,
}

extension TemperatureUnitExtension on TemperatureUnit {
  String get units {
    switch (this) {
      case TemperatureUnit.kelvin:
        return 'standard';

      case TemperatureUnit.celsius:
        return 'metric';

      case TemperatureUnit.fahrenheit:
      default:
        return 'imperial';
    }
  }
}

TemperatureUnit getTemperatureUnit(
  String temperatureUnit,
) {
  switch (temperatureUnit) {
    case 'TemperatureUnit.kelvin':
      return TemperatureUnit.kelvin;

    case 'TemperatureUnit.celsius':
      return TemperatureUnit.celsius;

    case 'TemperatureUnit.fahrenheit':
    default:
      return TemperatureUnit.fahrenheit;
  }
}

enum CRUDStatus {
  CREATING,
  CREATED,
  READING,
  READ,
  UPDATING,
  UPDATED,
  DELETING,
  DELETED,
}
