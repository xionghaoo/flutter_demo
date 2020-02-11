import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/constants.dart';
import 'package:flutter_demo/core/water_navigation_bar.dart';
import 'package:flutter_demo/screen/wallie_home_page.dart';
import 'package:flutter_demo/screen/wallie_profile_page.dart';
import 'package:flutter_demo/screen/wallie_scan_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WallieMainPage extends StatefulWidget {

  static final String path = "/wallieApp";

  @override
  _WallieMainPageState createState() => _WallieMainPageState();
}

class _WallieMainPageState extends State<WallieMainPage> {

  int pageIndex;

  Widget _contentPage(String username) {
    switch(pageIndex) {
      case 0:
        return WallieHomePage(username: username,);
      case 1:
        return WallieScanPage();
      case 2:
        return WallieProfilePage(username: username,);
    }
    return WallieHomePage(username: username,);
  }

  @override
  void initState() {
    super.initState();
    pageIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    // 获取传递到本页面的参数
    final String username = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          _contentPage(username),
          WaterNavigationBar(
            height: 60,
            backgroundColor: Colors.white,
            fabColor: Colors.green[400],
            icons: <Widget>[
              Icon(Icons.home),
              Icon(Icons.apps),
              Icon(Icons.person),
            ],
            fabIcons: <Widget>[
              Icon(Icons.home, color: Colors.white,),
              Icon(Icons.apps, color: Colors.white),
              Icon(Icons.person, color: Colors.white),
            ],
            onItemTapped: (index) {
              setState(() {
                pageIndex = index;
              });
            },
          )
        ],
      ),
    );
  }
}