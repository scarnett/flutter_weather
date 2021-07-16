import 'package:equatable/equatable.dart';
import 'package:flutter_weather/app/utils/utils.dart';

class NotificationExtras extends Equatable {
  final NotificationLocation? location;
  final bool? sound;
  final bool? showUnits;

  NotificationExtras({
    required this.location,
    this.sound: true,
    this.showUnits: true,
  });

  NotificationExtras copyWith({
    NotificationLocation? location,
    Nullable<bool?>? sound,
    Nullable<bool?>? showUnits,
  }) =>
      NotificationExtras(
        location: location ?? this.location,
        sound: (sound == null) ? this.sound : sound.value,
        showUnits: (showUnits == null) ? this.showUnits : showUnits.value,
      );

  static NotificationExtras? fromJson(
    dynamic json,
  ) =>
      (json == null)
          ? null
          : NotificationExtras(
              location: NotificationLocation.fromJson(json['location']),
              sound: json['sound'],
              showUnits: json['showUnits'],
            );

  Map<String, dynamic> toJson() => {
        'location': location?.toJson(),
        'sound': sound,
        'showUnits': showUnits,
      };

  @override
  List<Object?> get props => [
        location,
        sound,
        showUnits,
      ];

  @override
  String toString() =>
      'NotificationExtras{location: $location, sound: $sound, ' +
      'showUnits: $showUnits}';
}

class NotificationLocation extends Equatable {
  final String? id;
  final String? name;
  final String? cityName;
  final String? country;
  final num? latitude;
  final num? longitude;

  NotificationLocation({
    this.id,
    this.name,
    this.cityName,
    this.country,
    this.latitude,
    this.longitude,
  });

  NotificationLocation copyWith({
    String? id,
    String? name,
    String? cityName,
    String? country,
    num? latitude,
    num? longitude,
  }) =>
      NotificationLocation(
        id: id ?? this.id,
        name: name ?? this.name,
        cityName: cityName ?? this.cityName,
        country: country ?? this.country,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
      );

  static NotificationLocation fromJson(
    dynamic json,
  ) =>
      (json == null)
          ? NotificationLocation()
          : NotificationLocation(
              id: json['id'],
              name: json['name'],
              cityName: json['cityName'],
              country: json['country'],
              latitude: json['latitude'],
              longitude: json['longitude'],
            );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'cityName': cityName,
        'country': country,
        'latitude': latitude,
        'longitude': longitude,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        cityName,
        country,
        latitude,
        longitude,
      ];

  @override
  String toString() =>
      'NotificationLocation{id: $id, name: $name, cityName: $cityName, ' +
      'country: $country, latitude: $latitude, longitude: $longitude}';
}
