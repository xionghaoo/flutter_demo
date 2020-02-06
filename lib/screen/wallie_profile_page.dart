import 'package:flutter/material.dart';
import 'package:flutter_demo/core/utils.dart' as utils;

class WallieProfilePage extends StatefulWidget {

  @override
  _WallieProfilePageState createState() => _WallieProfilePageState();
}

class _WallieProfilePageState extends State<WallieProfilePage> {
  @override
  Widget build(BuildContext context) {
    utils.setStatusBarDark();
    return SafeArea(
      child: Center(
        child: Text("Profile"),
      ),
    );
  }
}