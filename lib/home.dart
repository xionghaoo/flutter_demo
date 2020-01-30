import 'package:flutter/material.dart';
import 'package:flutter_demo/screen/bottom_tabs.dart';
import 'package:flutter_demo/screen/network.dart';
import 'package:flutter_demo/screen/test.dart';
import 'package:flutter_demo/search.dart';

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
      body: Container(
        alignment: Alignment.topLeft,
        color: Colors.amberAccent,
        child: Column(
          // 主轴对齐方式，对Column来说是竖直方向
          mainAxisAlignment: MainAxisAlignment.start,
          // 横轴对齐方式，对Column来说是水平方向
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              color: Colors.cyan,
              child: Text("测试"),
            ),
            Row(children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                  child: RaisedButton(
                    onPressed: () {
                      print("长按钮");
                    },
                    textColor: Colors.black,
                    child: Text("Hello"),
                  ),
                ),
              )
            ]),
            Padding(
              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: RaisedButton(
                onPressed: () {
//                Fluttertoast.showToast(
//                    msg: "This is Center Short Toast",
//                    toastLength: Toast.LENGTH_SHORT,
//                    gravity: ToastGravity.CENTER,
//                    timeInSecForIos: 1,
//                    backgroundColor: Colors.red,
//                    textColor: Colors.white,
//                    fontSize: 16.0
//                );
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchPage()));
                },
                child: Text("搜索"),
                color: Colors.brown,
                textColor: Colors.white,
              ),
            ),
            Row(children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => NetworkPage()));
                    },
                    textColor: Colors.black,
                    child: Text("网络请求"),
                  ),
                ),
              )
            ]),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: RaisedButton(
                  child: Text("测试页面"),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => TestPage()));
                  },
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: RaisedButton(
                  child: Text("底部Tab切换"),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => BottomTabsPage()));
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}