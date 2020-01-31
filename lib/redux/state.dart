import 'package:flutter_demo/repo/data/todo_item.dart';

class AppState {
  final List<ToDoItem> toDos;
  final ListState listState;

  AppState(this.toDos, this.listState);

  // 单例模式
  factory AppState.initial() => AppState(List.unmodifiable([
    ToDoItem("TodoItem1"),
    ToDoItem("TodoItem2"),
    ToDoItem("TodoItem3")
  ]), ListState.ListOnly);
}

enum ListState {
  ListOnly, ListWithNewItem
}