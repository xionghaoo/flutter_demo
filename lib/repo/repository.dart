import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_demo/repo/data/weather_data.dart';
import 'package:http/http.dart' as http;

class Repository {
  static const HOST = "https://api.openweathermap.org";
  static const APPID = "64f1e72bacb07a49ce3e8f907f0b3bf4";

  Future<WeatherData> fetchCurrentWeatherByCityName(BuildContext context, String city) async {
    var url = "$HOST/data/2.5/weather?APPID=$APPID&q=$city&units=metric&lang=zh_cn";
    final response = await http.get(url);
    if (response.statusCode == 200) {
      print(response.body);
      return WeatherData.fromJson(json.decode(response.body));
    } else {
      throw Exception("fetchCurrentWeatherByCityName failure");
    }
  }
}