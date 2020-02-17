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

/// 异步任务
List<Middleware<AppState>> createStoreMiddleware() => [
  TypedMiddleware<AppState, SaveListAction>(_saveList),
  // 将逻辑转移到Repository中
  TypedMiddleware<AppState, LoginAction>(Repository.instance().login),
  TypedMiddleware<AppState, WallieBillAction>(Repository.instance().loadBillList)
];

Future _saveList(Store<AppState> store, SaveListAction action, NextDispatcher next) async {
  print("save list start");
  await Future.sync(() => Duration(seconds: 3));
  print("save list end, next action: ${action}");
  next(action);
}
