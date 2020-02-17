
import 'package:flutter/cupertino.dart';
import 'package:flutter_demo/core/network.dart';
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
  final ApiResponse response;

  LoginAction(this.context, this.username, this.password, this.response);
}

// 两处地方用到，Middleware拦截时、Reducer处理时
class WallieBillAction {
  final BuildContext context;
  final ApiResponse response;
  WallieBillAction(this.context, this.response);
}