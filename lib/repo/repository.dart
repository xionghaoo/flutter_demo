import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_demo/core/network.dart';
import 'package:flutter_demo/repo/data/weather_data.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:redux/redux.dart';

class Repository with RepoMixin {
  static const HOST = "https://api.openweathermap.org";
  static const APPID = "64f1e72bacb07a49ce3e8f907f0b3bf4";

  Future<WeatherData> fetchCurrentWeatherByCityName(BuildContext context, String city) async {
    var url = "$HOST/data/2.5/weather?APPID=$APPID&q=$city&units=metric&lang=zh_cn";
    final response = await http.get(url).timeout(Duration(seconds: 5));
    if (response.statusCode == 200) {
      print(response.body);
      return WeatherData.fromJson(json.decode(response.body));
    } else {
      throw Exception("fetchCurrentWeatherByCityName failure");
    }
  }

}

mixin RepoMixin {
  void requestWrapper<T>({
    @required BuildContext context,
    @required Future<T> future,
    @required Function(T) success,
    @required Function(String) failure,
    @required NextDispatcher next
  }) async {
    ProgressDialog progressDialog = ProgressDialog(context);
    progressDialog.style(message: "正在登陆...");
    progressDialog.show();
    next(ResponseLoadingAction(ApiResponse(Status.loading, null)));
    future.then((T data) {
      // 在success之前调用，确保当前页面的context还存在
      progressDialog.hide();
      success(data);
      next(ResponseSuccessAction(ApiResponse(Status.success, data)));
    }).catchError((e) {
      progressDialog.hide();
      failure(e.toString());
      next(ResponseFailureAction(ApiResponse(Status.failure, null, errorMessage: e.toString())));
    });
  }
}