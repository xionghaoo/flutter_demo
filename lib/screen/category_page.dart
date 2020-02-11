import 'package:flutter/material.dart';
import 'package:flutter_demo/core/common_widgets.dart';
import 'package:flutter_demo/screen/general_dev_page.dart';
import 'package:flutter_demo/screen/native_dev_page.dart';
import 'package:flutter_demo/screen/wallie_login_page.dart';
import 'package:flutter_demo/screen/wallie_main_page.dart';

class CategoryPage extends StatefulWidget {

  static final String path = "/";

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {

  final List<String> categories = ["常规Flutter开发", "Wallie App", "原生开发"];

  Widget _itemViewForIndex(int index, BuildContext context) {
    switch (index) {
      case 0:
        return _itemView(index, () => Navigator.pushNamed(context, GeneralDevPage.path));
      case 1:
        return _itemView(index, () => Navigator.pushNamed(context, WallieLoginPage.path));
      case 2:
        return _itemView(index, () => Navigator.pushNamed(context, NativeDevPage.path));
    }
  }

  Widget _itemView(int index, Function onTap) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: InkBox(
        borderRadius: BorderRadius.circular(10),
        color: Colors.brown,
        onTap: onTap,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 60,
          child: Center(
            child: Text(categories[index], style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold是Material样式的布局结构
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Demo"),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) => _itemViewForIndex(index, context)
      ),
    );
  }
}