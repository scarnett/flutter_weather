import 'package:equatable/equatable.dart';
import 'package:flutter_weather/utils/common_utils.dart';
import 'package:flutter_weather/utils/date_utils.dart';

enum RefreshStatus {
  REFRESHING,
}

class Forecast extends Equatable {
  final String id;
  final String cityName;
  final String postalCode;
  final String countryCode;
  final ForecastCity city;
  final String cod;
  final num message;
  final int cnt;
  final List<ForecastDay> list;
  final DateTime lastUpdated;

  Forecast({
    this.id,
    this.cityName,
    this.postalCode,
    this.countryCode,
    this.city,
    this.cod,
    this.message,
    this.cnt,
    this.list,
    this.lastUpdated,
  });

  Forecast copyWith({
    String id,
    Nullable<String> cityName,
    Nullable<String> postalCode,
    Nullable<String> countryCode,
    ForecastCity city,
    String cod,
    num message,
    int cnt,
    List<ForecastDay> list,
    DateTime lastUpdated,
  }) =>
      Forecast(
        id: id ?? this.id,
        cityName: (cityName == null) ? this.cityName : cityName.value,
        postalCode: (postalCode == null) ? this.postalCode : postalCode.value,
        countryCode:
            (countryCode == null) ? this.countryCode : countryCode.value,
        city: city ?? this.city,
        cod: cod ?? this.cod,
        message: message ?? this.message,
        cnt: cnt ?? this.cnt,
        list: list ?? this.list,
        lastUpdated: lastUpdated ?? this.lastUpdated,
      );

  static Forecast fromJson(
    dynamic json,
  ) =>
      (json == null)
          ? Forecast()
          : Forecast(
              id: json['id'],
              cityName: json['cityName'],
              postalCode: json['postalCode'],
              countryCode: json['countryCode'],
              city: ForecastCity.fromJson(json['city']),
              cod: json['cod'],
              message: json['message'],
              cnt: json['cnt'],
              list: ForecastDay.fromJsonList(json['list']),
              lastUpdated: fromIso8601String(json['lastUpdated']),
            );

  static List<Forecast> fromJsonList(
    dynamic json,
  ) =>
      (json == null)
          ? []
          : List<dynamic>.from(json)
              .map((dynamic forecastJson) => Forecast.fromJson(forecastJson))
              .toList();

  dynamic toJson() => {
        'id': id,
        'cityName': cityName,
        'postalCode': postalCode,
        'countryCode': countryCode,
        'city': city.toJson(),
        'cod': cod,
        'message': message,
        'cnt': cnt,
        'list': ForecastDay.toJsonList(list),
        'lastUpdated': toIso8601String(lastUpdated),
      };

  static List<dynamic> toJsonList(
    List<Forecast> list,
  ) =>
      (list == null)
          ? []
          : list.map((Forecast forecast) => forecast.toJson()).toList();

  @override
  List<Object> get props => [
        id,
        cityName,
        postalCode,
        countryCode,
        city,
        cod,
        message,
        cnt,
        list,
        lastUpdated,
      ];

  @override
  String toString() =>
      'Forecast{id: $id, cityName: $cityName, postalCode: $postalCode, ' +
      'countryCode: $countryCode, city: ${city?.name}, cod: $cod, ' +
      'message: $message, cnt: $cnt, lastUpdated: $lastUpdated}';
}

class ForecastCity extends Equatable {
  final int id;
  final String name;
  final ForecastCityCoord coord;
  final String country;
  final int population;
  final int timezone;

  ForecastCity({
    this.id,
    this.name,
    this.coord,
    this.country,
    this.population,
    this.timezone,
  });

  ForecastCity copyWith({
    int id,
    String name,
    ForecastCityCoord coord,
    String country,
    int population,
  }) =>
      ForecastCity(
        id: id ?? this.id,
        name: name ?? this.name,
        coord: coord ?? this.coord,
        country: country ?? this.country,
        population: population ?? this.population,
        timezone: timezone ?? this.timezone,
      );

  static ForecastCity fromJson(
    dynamic json,
  ) =>
      (json == null)
          ? ForecastCity()
          : ForecastCity(
              id: json['id'],
              name: json['name'],
              coord: ForecastCityCoord.fromJson(json['coord']),
              country: json['country'],
              population: json['population'],
              timezone: json['timezone'],
            );

  dynamic toJson() => {
        'id': id,
        'name': name,
        'coord': coord.toJson(),
        'country': country,
        'population': population,
        'timezone': timezone,
      };

  @override
  List<Object> get props => [id, name, coord, country, population, timezone];

  @override
  String toString() =>
      'ForecastCity{id: $id, name: $name, coord: $coord, country: $country, ' +
      'population: $population, timezone: $timezone}';
}

class ForecastCityCoord extends Equatable {
  final num lon;
  final num lat;

  ForecastCityCoord({
    this.lon,
    this.lat,
  });

  ForecastCityCoord copyWith({
    num lon,
    num lat,
  }) =>
      ForecastCityCoord(
        lon: lon ?? this.lon,
        lat: lat ?? this.lat,
      );

  static ForecastCityCoord fromJson(
    dynamic json,
  ) =>
      (json == null)
          ? ForecastCityCoord()
          : ForecastCityCoord(
              lon: json['lon'],
              lat: json['lat'],
            );

  dynamic toJson() => {
        'lon': lon,
        'lat': lat,
      };

  @override
  List<Object> get props => [lon, lat];

  @override
  String toString() => 'ForecastCityCoord{lon: $lon, lat: $lat}';
}

class ForecastDay extends Equatable {
  final int dt;
  final int sunrise;
  final int sunset;
  final ForecastDayTemp temp;
  final ForecastDayFeelsLike feelsLike;
  final num pressure;
  final num humidity;
  final List<ForecastDayWeather> weather;
  final num speed;
  final num deg;
  final num clouds;
  final num rain;
  final num snow;
  final num pop;

  ForecastDay({
    this.dt,
    this.sunrise,
    this.sunset,
    this.temp,
    this.feelsLike,
    this.pressure,
    this.humidity,
    this.weather,
    this.speed,
    this.deg,
    this.clouds,
    this.rain,
    this.snow,
    this.pop,
  });

  ForecastDay copyWith({
    int dt,
    int sunrise,
    int sunset,
    ForecastDayTemp temp,
    ForecastDayFeelsLike feelsLike,
    int pressure,
    int humidity,
    List<ForecastDayWeather> weather,
    num speed,
    int deg,
    int clouds,
    num rain,
    num snow,
    num pop,
  }) =>
      ForecastDay(
        dt: dt ?? this.dt,
        sunrise: sunrise ?? this.sunrise,
        sunset: sunset ?? this.sunset,
        temp: temp ?? this.temp,
        feelsLike: feelsLike ?? this.feelsLike,
        pressure: pressure ?? this.pressure,
        humidity: humidity ?? this.humidity,
        weather: weather ?? this.weather,
        speed: speed ?? this.speed,
        deg: deg ?? this.deg,
        clouds: clouds ?? this.clouds,
        rain: rain ?? this.rain,
        snow: snow ?? this.snow,
        pop: pop ?? this.pop,
      );

  static ForecastDay fromJson(
    dynamic json,
  ) =>
      (json == null)
          ? ForecastDay()
          : ForecastDay(
              dt: json['dt'],
              sunrise: json['sunrise'],
              sunset: json['sunset'],
              temp: ForecastDayTemp.fromJson(json['temp']),
              feelsLike: ForecastDayFeelsLike.fromJson(json['feels_like']),
              pressure: json['pressure'],
              humidity: json['humidity'],
              weather: ForecastDayWeather.fromJsonList(json['weather']),
              speed: json['speed'],
              deg: json['deg'],
              clouds: json['clouds'],
              rain: json['rain'],
              snow: json['snow'],
              pop: json['pop'],
            );

  static List<ForecastDay> fromJsonList(
    dynamic json,
  ) =>
      (json == null)
          ? []
          : List<dynamic>.from(json)
              .map((dynamic dayJson) => ForecastDay.fromJson(dayJson))
              .toList();

  dynamic toJson() => {
        'dt': dt,
        'sunrise': sunrise,
        'sunset': sunset,
        'temp': temp.toJson(),
        'feels_like': feelsLike.toJson(),
        'pressure': pressure,
        'humidity': humidity,
        'weather': ForecastDayWeather.toJsonList(weather),
        'speed': speed,
        'deg': deg,
        'clouds': clouds,
        'rain': rain,
        'snow': snow,
        'pop': pop,
      };

  static List<dynamic> toJsonList(
    List<ForecastDay> list,
  ) =>
      (list == null)
          ? []
          : list.map((ForecastDay day) => day.toJson()).toList();

  @override
  List<Object> get props => [
        dt,
        sunrise,
        sunset,
        temp,
        feelsLike,
        pressure,
        humidity,
        weather,
        speed,
        deg,
        clouds,
        rain,
        snow,
        pop,
      ];

  @override
  String toString() =>
      'ForecastDay{dt: $dt, sunrise: $sunrise, sunset: $sunset, temp: $temp, ' +
      'feelsLike: $feelsLike, pressure: $pressure, humidity: $humidity, ' +
      'weather: $weather, speed: $speed, deg: $deg, ' +
      'clouds: $clouds, rain: $rain, snow: $snow, pop: $pop}';
}

class ForecastDayTemp extends Equatable {
  final num day;
  final num min;
  final num max;
  final num night;
  final num eve;
  final num morn;

  ForecastDayTemp({
    this.day,
    this.min,
    this.max,
    this.night,
    this.eve,
    this.morn,
  });

  ForecastDayTemp copyWith({
    num day,
    num min,
    num max,
    num night,
    num eve,
    num morn,
  }) =>
      ForecastDayTemp(
        day: day ?? this.day,
        min: min ?? this.min,
        max: max ?? this.max,
        night: night ?? this.night,
        eve: eve ?? this.eve,
        morn: morn ?? this.morn,
      );

  static ForecastDayTemp fromJson(
    dynamic json,
  ) =>
      (json == null)
          ? ForecastDayTemp()
          : ForecastDayTemp(
              day: json['day'],
              min: json['min'],
              max: json['max'],
              night: json['night'],
              eve: json['eve'],
              morn: json['morn'],
            );

  dynamic toJson() => {
        'day': day,
        'min': min,
        'max': max,
        'night': night,
        'eve': eve,
        'morn': morn,
      };

  @override
  List<Object> get props => [day, min, max, night, eve, morn];

  @override
  String toString() =>
      'ForecastDayTemp{day: $day, min: $min, max: $max ' +
      'night: $night, eve: $eve, morn: $morn}';
}

class ForecastDayFeelsLike extends Equatable {
  final num day;
  final num night;
  final num eve;
  final num morn;

  ForecastDayFeelsLike({
    this.day,
    this.night,
    this.eve,
    this.morn,
  });

  ForecastDayFeelsLike copyWith({
    num day,
    num night,
    num eve,
    num morn,
  }) =>
      ForecastDayFeelsLike(
        day: day ?? this.day,
        night: night ?? this.night,
        eve: eve ?? this.eve,
        morn: morn ?? this.morn,
      );

  static ForecastDayFeelsLike fromJson(
    dynamic json,
  ) =>
      (json == null)
          ? ForecastDayFeelsLike()
          : ForecastDayFeelsLike(
              day: json['day'],
              night: json['night'],
              eve: json['eve'],
              morn: json['morn'],
            );

  dynamic toJson() => {
        'day': day,
        'night': night,
        'eve': eve,
        'morn': morn,
      };

  @override
  List<Object> get props => [day, night, eve, morn];

  @override
  String toString() =>
      'ForecastDayFeelsLike{day: $day night: $night, eve: $eve, morn: $morn}';
}

class ForecastDayWeather extends Equatable {
  final int id;
  final String main;
  final String description;
  final String icon;

  ForecastDayWeather({
    this.id,
    this.main,
    this.description,
    this.icon,
  });

  ForecastDayWeather copyWith({
    int id,
    String main,
    String description,
    String icon,
  }) =>
      ForecastDayWeather(
        id: id ?? this.id,
        main: main ?? this.main,
        description: description ?? this.description,
        icon: icon ?? this.icon,
      );

  static ForecastDayWeather fromJson(
    dynamic json,
  ) =>
      (json == null)
          ? ForecastDayWeather()
          : ForecastDayWeather(
              id: json['id'],
              main: json['main'],
              description: json['description'],
              icon: json['icon'],
            );

  static List<ForecastDayWeather> fromJsonList(
    dynamic json,
  ) =>
      (json == null)
          ? []
          : List<dynamic>.from(json)
              .map((dynamic weatherJson) =>
                  ForecastDayWeather.fromJson(weatherJson))
              .toList();

  dynamic toJson() => {
        'id': id,
        'main': main,
        'description': description,
        'icon': icon,
      };

  static List<dynamic> toJsonList(
    List<ForecastDayWeather> list,
  ) =>
      (list == null)
          ? []
          : list
              .map((ForecastDayWeather forecast) => forecast.toJson())
              .toList();

  @override
  List<Object> get props => [id, main, description, icon];

  @override
  String toString() =>
      'ForecastDayWeather{id: $id main: $main, description: $description, ' +
      'icon: $icon}';
}
