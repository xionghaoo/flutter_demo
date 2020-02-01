import 'package:flutter/material.dart';
import 'package:flutter_demo/screen/bottom_tabs.dart';
import 'package:flutter_demo/screen/native_call.dart';
import 'package:flutter_demo/screen/network.dart';
import 'package:flutter_demo/screen/page_view.dart';
import 'package:flutter_demo/screen/test.dart';
import 'package:flutter_demo/screen/todo_list.dart';
import 'package:flutter_demo/search.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
        "搜索", "网络请求", "底部tabs", "Redux", "顶部tabs", "原生调用", "test"
      ], (index) {
        Widget page;
        switch (index) {
          case 0:
            page = SearchPage();
            break;
          case 1:
            page = NetworkPage();
            break;
          case 2:
            page = BottomTabsPage();
            break;
          case 3:
            page = ToDoListPage();
            break;
          case 4:
            page = PageViewPage();
            break;
          case 5:
            page = NativeCallPage();
            break;
          case 5:
            page = TestPage();
            break;
        }
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
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
        return InkWell(
          child: Container(
            margin: EdgeInsets.all(15.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.cyan,
              borderRadius: BorderRadius.circular(radius),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(items[index], style: TextStyle(color: Colors.white, fontSize: 15), textAlign: TextAlign.center,),
              ),
            ),
          ),
          onTap: () => onTappedItem(index),
        );
      }),
    );
  }
}