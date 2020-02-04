import 'dart:io';

import 'package:flutter_demo/redux/actions.dart';
import 'package:flutter_demo/redux/state.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:redux/redux.dart';

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
  // 同步执行，阻塞3秒
  print("login loading -> username: ${action.username}, password: ${action.password}");
  ProgressDialog progressDialog = ProgressDialog(action.context);
  progressDialog.style(message: "正在登陆...");
  progressDialog.show();
  next(ResponseLoadingAction(ApiResponse(Status.loading)));
//  print("login loading completed");
  await Future.delayed(Duration(seconds: 3));
  progressDialog.hide();
  if (action.username == "username" && action.password == "password") {
//    print("login success");
    Fluttertoast.showToast(msg: "登陆成功");
    next(ResponseSuccessAction(ApiResponse(Status.success)));
  } else {
//    print("login failure");
    Fluttertoast.showToast(msg: "账号密码错误");
    next(ResponseFailureAction(ApiResponse(Status.failure, errorMessage: "账号密码错误")));
  }
}

