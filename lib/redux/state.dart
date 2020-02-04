import 'dart:math';

import 'package:flutter_demo/repo/data/todo_item.dart';

class AppState {
  final List<ToDoItem> toDos;
  final ListState listState;

  final LoginPageState loginState;

  AppState(this.toDos, this.listState, this.loginState);

  // 单例模式
  factory AppState.initial() => AppState(List.unmodifiable([
    ToDoItem("TodoItem1"),
    ToDoItem("TodoItem2"),
    ToDoItem("TodoItem3")
  ]), ListState.ListOnly, LoginPageState(ApiResponse(Status.none)));
}

enum ListState {
  ListOnly, ListWithNewItem
}

enum LoginState {
  none, loading, success, failure
}

class LoginPageState {
  final ApiResponse loginResponse;
  LoginPageState(this.loginResponse);
}

class ApiResponse {
  final Status status;
  final String errorMessage;
  ApiResponse(this.status, {this.errorMessage});
}

enum Status {
  success, failure, loading, none
}