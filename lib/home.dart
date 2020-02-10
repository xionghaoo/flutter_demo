import 'package:flutter/material.dart';
import 'package:flutter_demo/constants.dart';
import 'package:flutter_demo/core/common_widgets.dart';
import 'package:flutter_demo/screen/camera_test_page.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("首页"),
      ),
      body: _DemoItemsView([
        "搜索",
        "网络请求",
        "底部tabs",
        "Redux",
        "顶部tabs",
        "原生调用",
        "test",
        "Sqlite",
        "Key-Value存储",
        "Wallie app",
        "动画",
        "表单",
        "相机"
      ], (index) {
//        Widget page;
        String page;
        switch (index) {
          case 0:
            page = ScreenPath.SEARCH;
            break;
          case 1:
            page = ScreenPath.NETWORK;
            break;
          case 2:
            page = ScreenPath.BOTTOM_TABS;
            break;
          case 3:
            page = ScreenPath.TODO_LIST;
            break;
          case 4:
            page = ScreenPath.TOP_TABS;
            break;
          case 5:
            page = ScreenPath.NATIVE_CALL;
            break;
          case 6:
            page = ScreenPath.TEST;
            break;
          case 7:
            page = ScreenPath.SQLITE;
            break;
          case 8:
            page = ScreenPath.SHARED_PREFERENCES;
            break;
          case 9:
            page = ScreenPath.LOGIN;
            break;
          case 10:
            page = ScreenPath.TEST_ANIM;
            break;
          case 11:
            page = ScreenPath.FORM_PAGE;
            break;
          case 12:
            page = CameraTestPage.path;
            break;
        }
//        Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
        Navigator.pushNamed(context, page);
      }),
    );
  }
}

class _DemoItemsView extends StatelessWidget {
  
  final List<String> items;
  final Function(int) onTappedItem;
  
  _DemoItemsView(this.items, this.onTappedItem);
  
  @override
  Widget build(BuildContext context) {
    final radius = MediaQuery.of(context).size.width / 3 / 2 + 10;
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(items.length, (index) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: InkBox(
            borderRadius: BorderRadius.circular(radius),
            color: Colors.cyan,
            onTap: () => onTappedItem(index),
            child: Container(
              alignment: Alignment.center,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(items[index], style: TextStyle(color: Colors.white, fontSize: 15), textAlign: TextAlign.center,),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}