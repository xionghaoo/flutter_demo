import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_demo/core/network.dart';
import 'package:flutter_demo/redux/actions.dart';
import 'package:flutter_demo/redux/state.dart';
import 'package:flutter_demo/repo/data/weather_data.dart';
import 'package:flutter_demo/repo/repository.dart';
import 'package:flutter_demo/screen/wallie_main_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:redux/redux.dart';

import '../constants.dart';

List<Middleware<AppState>> createStoreMiddleware() => [
  TypedMiddleware<AppState, SaveListAction>(_saveList),
  TypedMiddleware<AppState, LoginAction>(_login)
];

Future _saveList(Store<AppState> store, SaveListAction action, NextDispatcher next) async {
  print("save list start");
  await Future.sync(() => Duration(seconds: 3));
  print("save list end, next action: ${action}");
  next(action);
}

Future _login(Store<AppState> store, LoginAction action, NextDispatcher next) async {
  print("login loading -> username: ${action.username}, password: ${action.password}");
  requestWrapper<String>(
    action.context,
    // 模拟后端登陆校验
    Future.delayed(Duration(seconds: 1), () {
      if (action.username == "ningque" && action.password == "n123") {
        return "宁缺";
      } else {
        throw Exception("账号或密码错误");
      }
    }),
    (String data) {
      Navigator.pushReplacementNamed(action.context, WallieMainPage.path, arguments: data);
      Fluttertoast.showToast(msg: "登陆成功: $data");
    },
    (String error) {
      print("error: " + error);
      Fluttertoast.showToast(msg: error);
    },
    next
  );
}

void requestWrapper<T>(BuildContext context, Future<T> future, Function(T) success, Function(String) failure, NextDispatcher next) async {
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

