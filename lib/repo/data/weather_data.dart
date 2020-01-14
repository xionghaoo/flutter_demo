import 'package:json_annotation/json_annotation.dart';

part 'weather_data.g.dart';

@JsonSerializable(explicitToJson: true)
class WeatherData {
  WeatherData(this.id, this.cityName, this.visibility);

  int id;

  @JsonKey(name: 'name')
  String cityName;
  int visibility;
//  Sys sys;
//  List<Weather> weather;
//  Main main;
//  Wind wind;


}