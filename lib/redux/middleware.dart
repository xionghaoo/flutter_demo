import 'package:flutter_demo/redux/actions.dart';
import 'package:flutter_demo/redux/state.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createStoreMiddleware() => [
  TypedMiddleware<AppState, SaveListAction>(_saveList)
];

Future _saveList(Store<AppState> store, SaveListAction action, NextDispatcher next) async {
  print("save list start");
  await Future.sync(() => Duration(seconds: 3));
  print("save list end, next action: ${action}");
  next(action);
}