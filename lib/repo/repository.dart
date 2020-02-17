import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_demo/core/network.dart';
import 'package:flutter_demo/redux/actions.dart';
import 'package:flutter_demo/redux/state.dart';
import 'package:flutter_demo/repo/data/weather_data.dart';
import 'package:flutter_demo/screen/wallie_main_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:redux/redux.dart';

class Repository with RepoMixin {

  Repository();

  factory Repository.instance() => Repository();

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

  Future<List<String>> fetchWallieBillList() async {
    await Future.delayed(Duration(seconds: 2));
    return List.generate(10, (index) => "list item $index");
  }

  // middleware
  Future loadBillList(Store<AppState> store, WallieBillAction action, NextDispatcher next) async {
    print("loadBillList");
    final future = fetchWallieBillList();
    next(WallieBillAction(action.context, ApiResponse(Status.loading, null)));
    future.then((List<String> data) {
      print("success");
      next(WallieBillAction(action.context, ApiResponse(Status.success, data)));
    }).catchError((e) {
      print("error");
      next(WallieBillAction(action.context, ApiResponse(Status.failure, null, errorMessage: e.toString())));
    });
  }


  Future login(Store<AppState> store, LoginAction action, NextDispatcher next) async {
    final future = Future.delayed(Duration(seconds: 1), () {
      if (action.username == "ningque" && action.password == "n123") {
        return "宁缺";
      } else {
        throw Exception("账号或密码错误");
      }
    });
    ProgressDialog progressDialog = ProgressDialog(action.context);
    progressDialog.style(message: "正在登陆...");
    progressDialog.show();
    next(LoginAction(action.context, null, null, ApiResponse(Status.loading, null)));
    future.then((String data) {
      progressDialog.hide();
      Navigator.pushReplacementNamed(action.context, WallieMainPage.path, arguments: data);
      Fluttertoast.showToast(msg: "登陆成功: $data");
      next(LoginAction(action.context, null, null, ApiResponse(Status.success, data)));
    }).catchError((e) {
      Fluttertoast.showToast(msg: e);
      progressDialog.hide();
      next(LoginAction(action.context, null, null, ApiResponse(Status.failure, null, errorMessage: e.toString())));
    });
  }

}

mixin RepoMixin {
  void _requestWrapper<T>({
    @required BuildContext context,
    @required Future<T> future,
    @required Function(T) success,
    @required Function(String) failure,
    @required NextDispatcher next
  }) async {
    ProgressDialog progressDialog = ProgressDialog(context);
    progressDialog.style(message: "正在登陆...");
    progressDialog.show();
//    next(ResponseLoadingAction(ApiResponse(Status.loading, null)));
    future.then((T data) {
      // 在success之前调用，确保当前页面的context还存在
      progressDialog.hide();
      success(data);
//      next(ResponseSuccessAction(ApiResponse(Status.success, data)));
    }).catchError((e) {
      progressDialog.hide();
      failure(e.toString());
//      next(ResponseFailureAction(ApiResponse(Status.failure, null, errorMessage: e.toString())));
    });
  }
}