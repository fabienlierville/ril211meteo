// To parse this JSON data, do
//
//     final weather = weatherFromJson(jsonString);

import 'package:meta/meta.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'weather.freezed.dart';
part 'weather.g.dart';

Weather weatherFromJson(String str) => Weather.fromJson(json.decode(str));

String weatherToJson(Weather data) => json.encode(data.toJson());

@freezed
class Weather with _$Weather {
  const factory Weather({
    required Clouds coord,
    required List<WeatherElement> weather,
    required String base,
    required Main main,
    required int visibility,
    required Clouds wind,
    required Clouds clouds,
    required int dt,
    required Clouds sys,
    required int timezone,
    required int id,
    required String name,
    required int cod,
  }) = _Weather;

  factory Weather.fromJson(Map<String, dynamic> json) => _$WeatherFromJson(json);
}

@freezed
class Clouds with _$Clouds {
  const factory Clouds() = _Clouds;

  factory Clouds.fromJson(Map<String, dynamic> json) => _$CloudsFromJson(json);
}

@freezed
class Main with _$Main {
  const factory Main({
    required double temp,
    required double feels_like,
    required double temp_min,
    required double temp_max,
    required int pressure,
    required int humidity,
  }) = _Main;

  factory Main.fromJson(Map<String, dynamic> json) => _$MainFromJson(json);
}

@freezed
class WeatherElement with _$WeatherElement {
  const factory WeatherElement({
    required int id,
    required String main,
    required String description,
    required String icon,
  }) = _WeatherElement;

  factory WeatherElement.fromJson(Map<String, dynamic> json) => _$WeatherElementFromJson(json);
}
