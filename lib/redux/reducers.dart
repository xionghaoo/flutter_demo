import 'package:flutter_demo/core/network.dart';
import 'package:flutter_demo/redux/actions.dart';
import 'package:flutter_demo/redux/state.dart';
import 'package:flutter_demo/repo/data/todo_item.dart';
import 'package:redux/redux.dart';

/// 用新的state对象更新store
// 分化state，将appState分为toDos和listState两种state
// reducer如何区分state是否变化，猜测是combineReducers循环过程中，
// 1、如果没有执行action的state，那么返回的是最初传入的对象，可以判定相同，不需要更新ui
// 2、执行过action的state，是新创建的state，判定与原始对象不同，不需要更新ui
AppState appReducer(AppState state, action) => AppState(
  _toDoListStateReducer(state.toDos, action),
  _listStateReducer(state.listState, action),
  _loginStateReducer(state.loginState, action),
  _wallieStateReducer(state.billState, action)
);

Reducer<List<ToDoItem>> _toDoListStateReducer = combineReducers([
  TypedReducer<List<ToDoItem>, AddItemAction>(_addItem),
  TypedReducer<List<ToDoItem>, RemoveItemAction>(_deleteItem)
]);

List<ToDoItem> _addItem(List<ToDoItem> state, AddItemAction action) => List.unmodifiable(List.from(state)..add(action.item));
List<ToDoItem> _deleteItem(List<ToDoItem> state, RemoveItemAction action) => List.unmodifiable(List.from(state)..remove(action.item));

// TypedReducer会检查传入的Action是否是泛型的Action，如果相同返回reducer函数，不相同则返回state
// combineReducers会遍历传入的reducers，分别执行reducer，并返回一个可供调用的reducer，
// combineReducers只是简单的执行所有的reducer，TypedReducer完成了Action的检查工作，只执行符合条件的Action，不符合条件的返回原始state
Reducer<ListState> _listStateReducer = combineReducers([
  TypedReducer<ListState, DisplayListOnlyAction>(_displayListOnly),
  TypedReducer<ListState, DisplayListWithNewItemAction>(_displayListWithNewItem)
]);

// 创建一个reducer
ListState _displayListOnly(ListState state, DisplayListOnlyAction action) => ListState.ListOnly;
ListState _displayListWithNewItem(ListState state, DisplayListWithNewItemAction action) => ListState.ListWithNewItem;


// -------------- wallie app start --------------
Reducer<LoginPageState> _loginStateReducer = combineReducers([
  TypedReducer<LoginPageState, LoginAction>((LoginPageState state, LoginAction action) => LoginPageState(action.response)),
]);

Reducer<WallieBillState> _wallieStateReducer = combineReducers([
  TypedReducer<WallieBillState, WallieBillAction>((WallieBillState state, WallieBillAction action) => WallieBillState(action.response))
]);
// -------------- wallie app end --------------

