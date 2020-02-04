
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

  LoginAction(this.username, this.password);
}

class LoginSuccessAction {}
class LoginFailureAction {
  final String message;
  LoginFailureAction(this.message);
}
class LoginLoadingAction {}

class ResponseSuccessAction {}
class ResponseFailureAction {
  final String message;
  ResponseFailureAction(this.message);
}
class ResponseLoadingAction {}