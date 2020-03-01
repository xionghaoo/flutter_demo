import 'package:flutter/material.dart';
import 'package:flutter_demo/constants.dart';
import 'package:flutter_demo/screen/address_select_page.dart';
import 'package:flutter_demo/screen/general_dev_page.dart';
import 'package:flutter_demo/redux/middleware.dart';
import 'package:flutter_demo/redux/reducers.dart';
import 'package:flutter_demo/redux/state.dart';
import 'package:flutter_demo/screen/bottom_tabs_page.dart';
import 'package:flutter_demo/screen/camera_test_page.dart';
import 'package:flutter_demo/screen/category_page.dart';
import 'package:flutter_demo/screen/form_page.dart';
import 'package:flutter_demo/screen/native_dev_page.dart';
import 'package:flutter_demo/screen/native_plugin_page.dart';
import 'package:flutter_demo/screen/wallie_login_page.dart';
import 'package:flutter_demo/screen/native_call_page.dart';
import 'package:flutter_demo/screen/network_page.dart';
import 'package:flutter_demo/screen/top_tabs_page.dart';
import 'package:flutter_demo/screen/prefs_page.dart';
import 'package:flutter_demo/screen/sqlite_page.dart';
import 'package:flutter_demo/screen/test.dart';
import 'package:flutter_demo/screen/animation_page.dart';
import 'package:flutter_demo/screen/redux_page.dart';
import 'package:flutter_demo/screen/wallie_bill_page.dart';
import 'package:flutter_demo/screen/wallie_main_page.dart';
import 'package:flutter_demo/screen/wallie_profile_page.dart';
import 'package:flutter_demo/screen/search_page.dart';
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
      initialRoute: CategoryPage.path,
      routes: {
        CategoryPage.path: (context) => CategoryPage(),
        GeneralDevPage.path: (context) => GeneralDevPage(),
        ScreenPath.SEARCH: (context) => SearchPage(),
        ScreenPath.NETWORK: (context) => NetworkPage(),
        ScreenPath.BOTTOM_TABS: (context) => BottomTabsPage(),
        ScreenPath.TODO_LIST: (context) => ToDoListPage(),
        ScreenPath.TOP_TABS: (context) => PageViewPage(),
        NativeCallPage.path: (context) => NativeCallPage(),
        ScreenPath.TEST: (context) => TestPage(),
        ScreenPath.SQLITE: (context) => SqlitePage(),
        ScreenPath.SHARED_PREFERENCES: (context) => SharedPreferencesPage(),
        ScreenPath.TEST_ANIM: (context) => TestAnimPage(),
        ScreenPath.FORM_PAGE: (context) => FormPage(),
        AddressSelectPage.path: (context) => AddressSelectPage(),
        CameraTestPage.path: (context) => CameraTestPage(),
        NativeDevPage.path: (context) => NativeDevPage(),
        NativePluginPage.path: (context) => NativePluginPage(),
        // wallie app
        WallieLoginPage.path: (context) => WallieLoginPage(),
        WallieMainPage.path: (context) => WallieMainPage(),
        WallieBillPage.path: (context) => WallieBillPage(),
      },
    ),
  );
}
