// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherData _$WeatherDataFromJson(Map<String, dynamic> json) {
  return WeatherData(
      json['id'] as int, json['name'] as String, json['visibility'] as int);
}

Map<String, dynamic> _$WeatherDataToJson(WeatherData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.cityName,
      'visibility': instance.visibility
    };
