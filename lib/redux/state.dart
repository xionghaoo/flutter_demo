import 'dart:math';

import 'package:flutter_demo/core/network.dart';
import 'package:flutter_demo/repo/data/todo_item.dart';

class AppState {
  // todoList 测试页
  final List<ToDoItem> toDos;
  final ListState listState;

  // wallie app login
  final LoginPageState loginState;
  // wallie app bill
  final WallieBillState billState;


  AppState(this.toDos, this.listState, this.loginState, this.billState);

  // 单例模式
  factory AppState.initial() => AppState(
      List.unmodifiable([
        ToDoItem("TodoItem1"),
        ToDoItem("TodoItem2"),
        ToDoItem("TodoItem3")]),
      ListState.ListOnly,

      // wallie app
      LoginPageState(ApiResponse(Status.none)),
      WallieBillState(ApiResponse(Status.none))
  );
}

enum ListState {
  ListOnly, ListWithNewItem
}

// wallie app
class LoginPageState {
  final ApiResponse loginResponse;
  LoginPageState(this.loginResponse);
}

class WallieBillState {
  final ApiResponse response;
  WallieBillState(this.response);
}