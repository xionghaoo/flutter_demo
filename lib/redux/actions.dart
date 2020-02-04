
import 'package:flutter/cupertino.dart';
import 'package:flutter_demo/redux/state.dart';
import 'package:flutter_demo/repo/data/todo_item.dart';

class RemoveItemAction {
  final ToDoItem item;

  RemoveItemAction(this.item);
}

class AddItemAction {
  final ToDoItem item;

  AddItemAction(this.item);
}

class DisplayListOnlyAction {}

class DisplayListWithNewItemAction {}

class SaveListAction {}

class LoginAction {
  final String username;
  final String password;
  final BuildContext context;

  LoginAction(this.context, this.username, this.password);
}

class LoginSuccessAction {}
class LoginFailureAction {
  final String message;
  LoginFailureAction(this.message);
}
class LoginLoadingAction {}

class ResponseSuccessAction {
  final ApiResponse response;
  ResponseSuccessAction(this.response);
}
class ResponseFailureAction {
  final ApiResponse response;
  ResponseFailureAction(this.response);
}
class ResponseLoadingAction {
  final ApiResponse response;
  ResponseLoadingAction(this.response);
}