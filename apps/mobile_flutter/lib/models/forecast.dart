import 'package:equatable/equatable.dart';
import 'package:flutter_weather/app/utils/utils.dart';

class Forecast extends Equatable {
  final String? id;
  final String? cityName;
  final String? postalCode;
  final String? countryCode;
  final ForecastCity? city;
  final String? cod;
  final num? message;
  final int? cnt;
  final List<ForecastDay>? list;
  final ForecastDetails? details;
  final DateTime? lastUpdated;
  final bool? primary;

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
    this.details,
    this.lastUpdated,
    this.primary,
  });

  Forecast copyWith({
    String? id,
    Nullable<String?>? cityName,
    Nullable<String?>? postalCode,
    Nullable<String?>? countryCode,
    ForecastCity? city,
    String? cod,
    num? message,
    int? cnt,
    List<ForecastDay>? list,
    Nullable<ForecastDetails?>? details,
    DateTime? lastUpdated,
    Nullable<bool?>? primary,
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
        details: (details == null) ? this.details : details.value,
        lastUpdated: lastUpdated ?? this.lastUpdated,
        primary: (primary == null) ? this.primary : primary.value,
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
              details: ForecastDetails.fromJson(json['details']),
              lastUpdated: fromIso8601String(json['lastUpdated']),
              primary: json['primary'],
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
        'city': (city == null) ? null : city!.toJson(),
        'cod': cod,
        'message': message,
        'cnt': cnt,
        'list': ForecastDay.toJsonList(list),
        'details': (details == null) ? null : details!.toJson(),
        'lastUpdated': toIso8601String(lastUpdated),
        'primary': primary,
      };

  static List<dynamic> toJsonList(
    List<Forecast>? list,
  ) =>
      (list == null)
          ? []
          : list.map((Forecast forecast) => forecast.toJson()).toList();

  @override
  List<Object?> get props => [
        id,
        cityName,
        postalCode,
        countryCode,
        city,
        cod,
        message,
        cnt,
        list,
        details,
        lastUpdated,
        primary,
      ];

  @override
  String toString() =>
      'Forecast{id: $id, cityName: $cityName, postalCode: $postalCode, ' +
      'countryCode: $countryCode, city: ${city?.name}, cod: $cod, ' +
      'message: $message, cnt: $cnt, lastUpdated: $lastUpdated, ' +
      'primary: $primary}';
}

class ForecastCity extends Equatable {
  final int? id;
  final String? name;
  final ForecastCityCoord? coord;
  final String? country;
  final int? population;
  final int? timezone;

  ForecastCity({
    this.id,
    this.name,
    this.coord,
    this.country,
    this.population,
    this.timezone,
  });

  ForecastCity copyWith({
    int? id,
    String? name,
    ForecastCityCoord? coord,
    String? country,
    int? population,
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
        'coord': (coord == null) ? null : coord!.toJson(),
        'country': country,
        'population': population,
        'timezone': timezone,
      };

  @override
  List<Object?> get props => [id, name, coord, country, population, timezone];

  @override
  String toString() =>
      'ForecastCity{id: $id, name: $name, coord: $coord, country: $country, ' +
      'population: $population, timezone: $timezone}';
}

class ForecastCityCoord extends Equatable {
  final num? lon;
  final num? lat;

  ForecastCityCoord({
    this.lon,
    this.lat,
  });

  ForecastCityCoord copyWith({
    num? lon,
    num? lat,
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
  List<Object?> get props => [lon, lat];

  @override
  String toString() => 'ForecastCityCoord{lon: $lon, lat: $lat}';
}

class ForecastDay extends Equatable {
  final int? dt;
  final int? sunrise;
  final int? sunset;
  final ForecastDayTemp? temp;
  final ForecastDayFeelsLike? feelsLike;
  final num? pressure;
  final num? humidity;
  final List<ForecastDayWeather>? weather;
  final num? speed;
  final num? deg;
  final num? clouds;
  final num? rain;
  final num? snow;
  final num? pop;

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
    int? dt,
    int? sunrise,
    int? sunset,
    ForecastDayTemp? temp,
    ForecastDayFeelsLike? feelsLike,
    int? pressure,
    int? humidity,
    List<ForecastDayWeather>? weather,
    num? speed,
    int? deg,
    int? clouds,
    num? rain,
    num? snow,
    num? pop,
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
        'temp': (temp == null) ? null : temp!.toJson(),
        'feels_like': (feelsLike == null) ? null : feelsLike!.toJson(),
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
    List<ForecastDay>? list,
  ) =>
      (list == null)
          ? []
          : list.map((ForecastDay day) => day.toJson()).toList();

  @override
  List<Object?> get props => [
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
  final num? day;
  final num? min;
  final num? max;
  final num? night;
  final num? eve;
  final num? morn;

  ForecastDayTemp({
    this.day,
    this.min,
    this.max,
    this.night,
    this.eve,
    this.morn,
  });

  ForecastDayTemp copyWith({
    num? day,
    num? min,
    num? max,
    num? night,
    num? eve,
    num? morn,
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
  List<Object?> get props => [day, min, max, night, eve, morn];

  @override
  String toString() =>
      'ForecastDayTemp{day: $day, min: $min, max: $max ' +
      'night: $night, eve: $eve, morn: $morn}';
}

class ForecastDayFeelsLike extends Equatable {
  final num? day;
  final num? night;
  final num? eve;
  final num? morn;

  ForecastDayFeelsLike({
    this.day,
    this.night,
    this.eve,
    this.morn,
  });

  ForecastDayFeelsLike copyWith({
    num? day,
    num? night,
    num? eve,
    num? morn,
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
  List<Object?> get props => [day, night, eve, morn];

  @override
  String toString() =>
      'ForecastDayFeelsLike{day: $day night: $night, eve: $eve, morn: $morn}';
}

class ForecastDayWeather extends Equatable {
  final int? id;
  final String? main;
  final String? description;
  final String? icon;

  ForecastDayWeather({
    this.id,
    this.main,
    this.description,
    this.icon,
  });

  ForecastDayWeather copyWith({
    int? id,
    String? main,
    String? description,
    String? icon,
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
    List<ForecastDayWeather>? list,
  ) =>
      (list == null)
          ? []
          : list
              .map((ForecastDayWeather forecast) => forecast.toJson())
              .toList();

  @override
  List<Object?> get props => [id, main, description, icon];

  @override
  String toString() =>
      'ForecastDayWeather{id: $id main: $main, description: $description, ' +
      'icon: $icon}';
}

class ForecastDetails extends Equatable {
  final num? lon;
  final num? lat;
  final String? timezone;
  final num? timezoneOffset;
  final ForecastCurrent? current;
  final List<ForecastMinute>? minutely;
  final List<ForecastHour>? hourly;
  final List<ForecastDaily>? daily;
  final List<ForecastAlert>? alerts;

  ForecastDetails({
    this.lon,
    this.lat,
    this.timezone,
    this.timezoneOffset,
    this.current,
    this.minutely,
    this.hourly,
    this.daily,
    this.alerts,
  });

  ForecastDetails copyWith({
    num? lon,
    num? lat,
    String? timezone,
    num? timezoneOffset,
    ForecastCurrent? current,
    List<ForecastMinute>? minutely,
    List<ForecastHour>? hourly,
    List<ForecastDaily>? daily,
    List<ForecastAlert>? alerts,
  }) =>
      ForecastDetails(
        lon: lon ?? this.lon,
        lat: lat ?? this.lat,
        timezone: timezone ?? this.timezone,
        timezoneOffset: timezoneOffset ?? this.timezoneOffset,
        current: current ?? this.current,
        minutely: minutely ?? this.minutely,
        hourly: hourly ?? this.hourly,
        daily: daily ?? this.daily,
        alerts: alerts ?? this.alerts,
      );

  static ForecastDetails fromJson(
    dynamic json,
  ) =>
      (json == null)
          ? ForecastDetails()
          : ForecastDetails(
              lon: json['lon'],
              lat: json['lat'],
              timezone: json['timezone'],
              timezoneOffset: json['timezone_offset'],
              current: ForecastCurrent.fromJson(json['current']),
              minutely: ForecastMinute.fromJsonList(json['minutely']),
              hourly: ForecastHour.fromJsonList(json['hourly']),
              daily: ForecastDaily.fromJsonList(json['daily']),
              alerts: ForecastAlert.fromJsonList(json['alerts']),
            );

  dynamic toJson() => {
        'lon': lon,
        'lat': lat,
        'timezone': timezone,
        'timezone_offset': timezoneOffset,
        'current': (current == null) ? null : current!.toJson(),
        'minutely': ForecastMinute.toJsonList(minutely),
        'hourly': ForecastHour.toJsonList(hourly),
        'daily': ForecastDaily.toJsonList(daily),
        'alerts': ForecastAlert.toJsonList(alerts),
      };

  @override
  List<Object?> get props => [
        lon,
        lat,
        timezone,
        timezoneOffset,
        current,
        minutely,
        hourly,
        daily,
        alerts,
      ];

  @override
  String toString() =>
      'ForecastDetails{lon: $lon, lat: $lat, timezone: $timezone, ' +
      'timezoneOffset: $timezoneOffset, current: $current}';
}

class ForecastCurrent extends Equatable {
  final int? dt;
  final int? sunrise;
  final int? sunset;
  final num? temp;
  final num? feelsLike;
  final num? pressure;
  final num? humidity;
  final num? dewPoint;
  final num? uvi;
  final num? clouds;
  final num? visibility;
  final num? windSpeed;
  final num? windDeg;
  final List<ForecastDayWeather>? weather;

  ForecastCurrent({
    this.dt,
    this.sunrise,
    this.sunset,
    this.temp,
    this.feelsLike,
    this.pressure,
    this.humidity,
    this.dewPoint,
    this.uvi,
    this.clouds,
    this.visibility,
    this.windSpeed,
    this.windDeg,
    this.weather,
  });

  ForecastCurrent copyWith({
    int? dt,
    int? sunrise,
    int? sunset,
    num? temp,
    num? feelsLike,
    num? pressure,
    num? humidity,
    num? dewPoint,
    num? uvi,
    num? clouds,
    num? visibility,
    num? windSpeed,
    num? windDeg,
    List<ForecastDayWeather>? weather,
  }) =>
      ForecastCurrent(
        dt: dt ?? this.dt,
        sunrise: sunrise ?? this.sunrise,
        sunset: sunset ?? this.sunset,
        temp: temp ?? this.temp,
        feelsLike: feelsLike ?? this.feelsLike,
        pressure: pressure ?? this.pressure,
        humidity: humidity ?? this.humidity,
        dewPoint: dewPoint ?? this.dewPoint,
        uvi: uvi ?? this.uvi,
        clouds: clouds ?? this.clouds,
        visibility: visibility ?? this.visibility,
        windSpeed: windSpeed ?? this.windSpeed,
        windDeg: windDeg ?? this.windDeg,
        weather: weather ?? this.weather,
      );

  static ForecastCurrent fromJson(
    dynamic json,
  ) =>
      (json == null)
          ? ForecastCurrent()
          : ForecastCurrent(
              dt: json['dt'],
              sunrise: json['sunrise'],
              sunset: json['sunset'],
              temp: json['temp'],
              feelsLike: json['feels_like'],
              pressure: json['pressure'],
              humidity: json['humidity'],
              dewPoint: json['dew_point'],
              uvi: json['uvi'],
              clouds: json['clouds'],
              visibility: json['visibility'],
              windSpeed: json['wind_speed'],
              windDeg: json['wind_deg'],
              weather: ForecastDayWeather.fromJsonList(json['weather']),
            );

  dynamic toJson() => {
        'dt': dt,
        'sunrise': sunrise,
        'sunset': sunset,
        'temp': temp,
        'feels_like': feelsLike,
        'pressure': pressure,
        'humidity': humidity,
        'dew_point': dewPoint,
        'uvi': uvi,
        'clouds': clouds,
        'visibility': visibility,
        'wind_speed': windSpeed,
        'wind_deg': windDeg,
        'weather': ForecastDayWeather.toJsonList(weather),
      };

  @override
  List<Object?> get props => [
        dt,
        sunrise,
        sunset,
        temp,
        feelsLike,
        pressure,
        humidity,
        dewPoint,
        uvi,
        clouds,
        visibility,
        windSpeed,
        windDeg,
        weather,
      ];

  @override
  String toString() =>
      'ForecastCurrent{dt: $dt, sunrise: $sunrise, sunset: $sunset, ' +
      'temp: $temp, feelsLike: $feelsLike, pressure: $pressure, ' +
      'humidity: $humidity, dewPoint: $dewPoint, uvi: $uvi, clouds: $clouds, ' +
      'visibility: $visibility, windSpeed: $windSpeed, windDeg: $windDeg}';
}

class ForecastMinute extends Equatable {
  final int? dt;
  final num? precipitation;

  ForecastMinute({
    this.dt,
    this.precipitation,
  });

  ForecastMinute copyWith({
    int? dt,
    num? precipitation,
  }) =>
      ForecastMinute(
        dt: dt ?? this.dt,
        precipitation: precipitation ?? this.precipitation,
      );

  static ForecastMinute fromJson(
    dynamic json,
  ) =>
      (json == null)
          ? ForecastMinute()
          : ForecastMinute(
              dt: json['dt'],
              precipitation: json['precipitation'],
            );

  static List<ForecastMinute> fromJsonList(
    dynamic json,
  ) =>
      (json == null)
          ? []
          : List<dynamic>.from(json)
              .map((dynamic minuteJson) => ForecastMinute.fromJson(minuteJson))
              .toList();

  dynamic toJson() => {
        'dt': dt,
        'precipitation': precipitation,
      };

  static List<dynamic> toJsonList(
    List<ForecastMinute>? list,
  ) =>
      (list == null)
          ? []
          : list.map((ForecastMinute minute) => minute.toJson()).toList();

  @override
  List<Object?> get props => [dt, precipitation];

  @override
  String toString() => 'ForecastMinute{dt: $dt, precipitation: $precipitation}';
}

class ForecastHour extends Equatable {
  final int? dt;
  final num? temp;
  final num? feelsLike;
  final num? pressure;
  final num? humidity;
  final num? dewPoint;
  final num? uvi;
  final num? clouds;
  final num? visibility;
  final num? windSpeed;
  final num? windDeg;
  final num? windGust;
  final num? pop;
  final ForecastRain? rain;
  final ForecastSnow? snow;
  final List<ForecastDayWeather>? weather;

  ForecastHour({
    this.dt,
    this.temp,
    this.feelsLike,
    this.pressure,
    this.humidity,
    this.dewPoint,
    this.uvi,
    this.clouds,
    this.visibility,
    this.windSpeed,
    this.windDeg,
    this.windGust,
    this.pop,
    this.rain,
    this.snow,
    this.weather,
  });

  ForecastHour copyWith({
    int? dt,
    num? temp,
    num? feelsLike,
    num? pressure,
    num? humidity,
    num? dewPoint,
    num? uvi,
    num? clouds,
    num? visibility,
    num? windSpeed,
    num? windDeg,
    num? windGust,
    num? pop,
    Nullable<ForecastRain?>? rain,
    Nullable<ForecastSnow?>? snow,
    List<ForecastDayWeather>? weather,
  }) =>
      ForecastHour(
        dt: dt ?? this.dt,
        temp: temp ?? this.temp,
        feelsLike: feelsLike ?? this.feelsLike,
        pressure: pressure ?? this.pressure,
        humidity: humidity ?? this.humidity,
        dewPoint: dewPoint ?? this.dewPoint,
        uvi: uvi ?? this.uvi,
        clouds: clouds ?? this.clouds,
        visibility: visibility ?? this.visibility,
        windSpeed: windSpeed ?? this.windSpeed,
        windDeg: windDeg ?? this.windDeg,
        windGust: windGust ?? this.windGust,
        pop: pop ?? this.pop,
        rain: (rain == null) ? this.rain : rain.value,
        snow: (snow == null) ? this.snow : snow.value,
        weather: weather ?? this.weather,
      );

  static ForecastHour fromJson(
    dynamic json,
  ) =>
      (json == null)
          ? ForecastHour()
          : ForecastHour(
              dt: json['dt'],
              temp: json['temp'],
              feelsLike: json['feels_like'],
              pressure: json['pressure'],
              humidity: json['humidity'],
              dewPoint: json['dew_point'],
              uvi: json['uvi'],
              clouds: json['clouds'],
              visibility: json['visibility'],
              windSpeed: json['wind_speed'],
              windDeg: json['wind_deg'],
              windGust: json['wind_gust'],
              pop: json['pop'],
              rain: ForecastRain.fromJson(json['rain']),
              snow: ForecastSnow.fromJson(json['snow']),
              weather: ForecastDayWeather.fromJsonList(json['weather']),
            );

  static List<ForecastHour> fromJsonList(
    dynamic json,
  ) =>
      (json == null)
          ? []
          : List<dynamic>.from(json)
              .map((dynamic hourJson) => ForecastHour.fromJson(hourJson))
              .toList();

  dynamic toJson() => {
        'dt': dt,
        'temp': temp,
        'feels_like': feelsLike,
        'pressure': pressure,
        'humidity': humidity,
        'dew_point': dewPoint,
        'uvi': uvi,
        'clouds': clouds,
        'visibility': visibility,
        'wind_speed': windSpeed,
        'wind_deg': windDeg,
        'wind_gust': windGust,
        'pop': pop,
        'rain': (rain == null) ? null : rain!.toJson(),
        'snow': (snow == null) ? null : snow!.toJson(),
        'weather':
            (weather == null) ? null : ForecastDayWeather.toJsonList(weather),
      };

  static List<dynamic> toJsonList(
    List<ForecastHour>? list,
  ) =>
      (list == null)
          ? []
          : list.map((ForecastHour hour) => hour.toJson()).toList();

  @override
  List<Object?> get props => [
        dt,
        temp,
        feelsLike,
        pressure,
        humidity,
        dewPoint,
        uvi,
        clouds,
        visibility,
        windSpeed,
        windDeg,
        windGust,
        pop,
        rain,
        snow,
        weather,
      ];

  @override
  String toString() =>
      'ForecastCurrent{dt: $dt, temp: $temp, feelsLike: $feelsLike, ' +
      'pressure: $pressure, humidity: $humidity, dewPoint: $dewPoint, ' +
      'uvi: $uvi, clouds: $clouds, visibility: $visibility, ' +
      'windSpeed: $windSpeed, windDeg: $windDeg, windGust: $windGust, ' +
      'pop: $pop, rain: $rain, snow: $snow}';
}

class ForecastDaily extends Equatable {
  final int? dt;
  final int? sunrise;
  final int? sunset;
  final int? moonrise;
  final int? moonset;
  final num? moonPhase;
  final ForecastDayTemp? temp;
  final ForecastDayFeelsLike? feelsLike;
  final num? pressure;
  final num? humidity;
  final num? dewPoint;
  final num? windSpeed;
  final num? windDeg;
  final num? windGust;
  final List<ForecastDayWeather>? weather;
  final num? clouds;
  final num? pop;
  final num? rain;
  final num? uvi;

  ForecastDaily({
    this.dt,
    this.sunrise,
    this.sunset,
    this.moonrise,
    this.moonset,
    this.moonPhase,
    this.temp,
    this.feelsLike,
    this.pressure,
    this.humidity,
    this.dewPoint,
    this.windSpeed,
    this.windDeg,
    this.windGust,
    this.weather,
    this.clouds,
    this.pop,
    this.rain,
    this.uvi,
  });

  ForecastDaily copyWith({
    int? dt,
    int? sunrise,
  }) =>
      ForecastDaily(
        dt: dt ?? this.dt,
        sunrise: sunrise ?? this.sunrise,
        sunset: sunset ?? this.sunset,
        moonrise: moonrise ?? this.moonrise,
        moonset: moonset ?? this.moonset,
        moonPhase: moonPhase ?? this.moonPhase,
        temp: temp ?? this.temp,
        feelsLike: feelsLike ?? this.feelsLike,
        pressure: pressure ?? this.pressure,
        humidity: humidity ?? this.humidity,
        dewPoint: dewPoint ?? this.dewPoint,
        windSpeed: windSpeed ?? this.windSpeed,
        windDeg: windDeg ?? this.windDeg,
        windGust: windGust ?? this.windGust,
        weather: weather ?? this.weather,
        clouds: clouds ?? this.clouds,
        pop: pop ?? this.pop,
        rain: rain ?? this.rain,
        uvi: uvi ?? this.uvi,
      );

  static ForecastDaily fromJson(
    dynamic json,
  ) =>
      (json == null)
          ? ForecastDaily()
          : ForecastDaily(
              dt: json['dt'],
              sunrise: json['sunrise'],
              sunset: json['sunset'],
              moonrise: json['moonrise'],
              moonset: json['moonset'],
              moonPhase: json['moon_phase'],
              temp: ForecastDayTemp.fromJson(json['temp']),
              feelsLike: ForecastDayFeelsLike.fromJson(json['feels_like']),
              pressure: json['pressure'],
              humidity: json['humidity'],
              dewPoint: json['dew_point'],
              windSpeed: json['wind_speed'],
              windDeg: json['wind_deg'],
              windGust: json['wind_gust'],
              weather: ForecastDayWeather.fromJsonList(json['weather']),
              clouds: json['clouds'],
              pop: json['pop'],
              rain: json['rain'],
              uvi: json['uvi'],
            );

  static List<ForecastDaily> fromJsonList(
    dynamic json,
  ) =>
      (json == null)
          ? []
          : List<dynamic>.from(json)
              .map((dynamic dailyJson) => ForecastDaily.fromJson(dailyJson))
              .toList();

  dynamic toJson() => {
        'dt': dt,
        'sunrise': sunrise,
        'sunset': sunset,
        'moonrise': moonrise,
        'moonset': moonset,
        'moon_phase': moonPhase,
        'temp': temp,
        'feels_like': feelsLike,
        'pressure': pressure,
        'humidity': humidity,
        'dew_point': dewPoint,
        'wind_speed': windSpeed,
        'wind_deg': windDeg,
        'wind_gust': windGust,
        'weather': weather,
        'clouds': clouds,
        'pop': pop,
        'rain': rain,
        'uvi': uvi,
      };

  static List<dynamic> toJsonList(
    List<ForecastDaily>? list,
  ) =>
      (list == null)
          ? []
          : list.map((ForecastDaily daily) => daily.toJson()).toList();

  @override
  List<Object?> get props => [
        dt,
        sunrise,
        sunset,
        moonrise,
        moonset,
        moonPhase,
        temp,
        feelsLike,
        pressure,
        humidity,
        dewPoint,
        windSpeed,
        windDeg,
        windGust,
        weather,
        clouds,
        pop,
        rain,
        uvi,
      ];

  @override
  String toString() =>
      'ForecastMinute{dt: $dt, sunrise: $sunrise, ' +
      'sunset: $sunset, moonrise: $moonrise, moonset: $moonset, ' +
      'moonPhase: $moonPhase, pressure: $pressure, humidity: $humidity, ' +
      'dewPoint: $dewPoint, windSpeed: $windSpeed, windDeg: $windDeg, ' +
      'windGust: $windGust, clouds: $clouds, pop: $pop, rain: $rain, uvi: $uvi}';
}

class ForecastAlert extends Equatable {
  final String? senderName;
  final String? event;
  final int? start;
  final int? end;
  final String? description;

  ForecastAlert({
    this.senderName,
    this.event,
    this.start,
    this.end,
    this.description,
  });

  ForecastAlert copyWith({
    String? senderName,
    String? event,
    int? start,
    int? end,
    String? description,
  }) =>
      ForecastAlert(
        senderName: senderName ?? this.senderName,
        event: event ?? this.event,
        start: start ?? this.start,
        end: end ?? this.end,
        description: description ?? this.description,
      );

  static ForecastAlert fromJson(
    dynamic json,
  ) =>
      (json == null)
          ? ForecastAlert()
          : ForecastAlert(
              senderName: json['sender_name'],
              event: json['event'],
              start: json['start'],
              end: json['end'],
              description: json['description'],
            );

  static List<ForecastAlert> fromJsonList(
    dynamic json,
  ) =>
      (json == null)
          ? []
          : List<dynamic>.from(json)
              .map((dynamic alertJson) => ForecastAlert.fromJson(alertJson))
              .toList();

  dynamic toJson() => {
        'sender_name': senderName,
        'event': event,
        'start': start,
        'end': end,
        'description': description,
      };

  static List<dynamic> toJsonList(
    List<ForecastAlert>? list,
  ) =>
      (list == null)
          ? []
          : list.map((ForecastAlert alert) => alert.toJson()).toList();

  @override
  List<Object?> get props => [
        senderName,
        event,
        start,
        end,
        description,
      ];

  @override
  String toString() =>
      'ForecastAlert{senderName: $senderName, event: $event ' +
      'start: $start, end: $end, description: $description}';
}

class ForecastRain extends Equatable {
  final num? oneHour;

  ForecastRain({
    this.oneHour,
  });

  ForecastRain copyWith({
    num? oneHour,
  }) =>
      ForecastRain(
        oneHour: oneHour ?? this.oneHour,
      );

  static ForecastRain? fromJson(
    dynamic json,
  ) =>
      (json == null)
          ? null
          : ForecastRain(
              oneHour: json['1h'],
            );

  dynamic toJson() => {
        '1h': oneHour,
      };

  @override
  List<Object?> get props => [oneHour];

  @override
  String toString() => 'ForecastRain{oneHour: $oneHour}';
}

class ForecastSnow extends Equatable {
  final num? oneHour;

  ForecastSnow({
    this.oneHour,
  });

  ForecastSnow copyWith({
    num? oneHour,
  }) =>
      ForecastSnow(
        oneHour: oneHour ?? this.oneHour,
      );

  static ForecastSnow? fromJson(
    dynamic json,
  ) =>
      (json == null)
          ? null
          : ForecastSnow(
              oneHour: json['1h'],
            );

  dynamic toJson() => {
        '1h': oneHour,
      };

  @override
  List<Object?> get props => [oneHour];

  @override
  String toString() => 'ForecastSnow{oneHour: $oneHour}';
}
