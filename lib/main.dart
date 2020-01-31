import 'package:flutter/material.dart';
import 'package:flutter_demo/home.dart';
import 'package:flutter_demo/redux/middleware.dart';
import 'package:flutter_demo/redux/reducers.dart';
import 'package:flutter_demo/redux/state.dart';
import 'package:flutter_demo/theme/colors.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

void main() => runApp(MyApp());

/// This Reducer updates the Store with a new State depending on what Action it receives
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Store<AppState> store = Store<AppState>(
      appReducer,
      initialState: AppState.initial(),
      middleware: createStoreMiddleware()
  );

  @override
  Widget build(BuildContext context) => StoreProvider(
    store: store,
    child: MaterialApp(
      theme: ThemeData(
        primaryColor: primaryColor
      ),
      home: HomePage(),
    ),
  );
}
