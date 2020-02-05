import 'package:flutter/material.dart';
import 'package:flutter_demo/constants.dart';
import 'package:flutter_demo/home.dart';
import 'package:flutter_demo/redux/middleware.dart';
import 'package:flutter_demo/redux/reducers.dart';
import 'package:flutter_demo/redux/state.dart';
import 'package:flutter_demo/screen/bottom_tabs.dart';
import 'package:flutter_demo/screen/login_page.dart';
import 'package:flutter_demo/screen/native_call.dart';
import 'package:flutter_demo/screen/network.dart';
import 'package:flutter_demo/screen/page_view.dart';
import 'package:flutter_demo/screen/prefs_test.dart';
import 'package:flutter_demo/screen/sqlite_test.dart';
import 'package:flutter_demo/screen/test.dart';
import 'package:flutter_demo/screen/test_animation.dart';
import 'package:flutter_demo/screen/todo_list.dart';
import 'package:flutter_demo/screen/wallie_page.dart';
import 'package:flutter_demo/search.dart';
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
      debugShowCheckedModeBanner: false,
      // 全局主题对象，Theme.of(context)会查找离父级widget最近的theme，如果没有，返回app theme
      theme: ThemeData(
        primaryColor: primaryColor,
        accentColor: accentColor,
      ),
      initialRoute: ScreenPath.HOME,
      routes: {
        ScreenPath.HOME: (context) => HomePage(),
        ScreenPath.SEARCH: (context) => SearchPage(),
        ScreenPath.NETWORK: (context) => NetworkPage(),
        ScreenPath.BOTTOM_TABS: (context) => BottomTabsPage(),
        ScreenPath.TODO_LIST: (context) => ToDoListPage(),
        ScreenPath.TOP_TABS: (context) => PageViewPage(),
        ScreenPath.NATIVE_CALL: (context) => NativeCallPage(),
        ScreenPath.TEST: (context) => TestPage(),
        ScreenPath.SQLITE: (context) => SqlitePage(),
        ScreenPath.SHARED_PREFERENCES: (context) => SharedPreferencesPage(),
        ScreenPath.LOGIN: (context) => LoginPage(),
        ScreenPath.WALLIE: (context) => WalliePage(),
        ScreenPath.TEST_ANIM: (context) => TestAnimPage()
      },
//      home: HomePage(),
    ),
  );
}
