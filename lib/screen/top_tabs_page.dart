import 'package:flutter/material.dart';

class PageViewPage extends StatefulWidget {

  @override
  _PageViewPageState createState() => _PageViewPageState();
}

class _PageViewPageState extends State<PageViewPage> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        print("onback");
        Navigator.pop(context, "Hello, I'm Back");
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("PageViewWidget"),
          bottom: TabBar(
            indicatorPadding: EdgeInsets.symmetric(horizontal: 10.0),
            controller: _tabController,
            tabs: <Widget>[
              Tab(text: "Tab1"),
              Tab(text: "Tab2",),
              Tab(text: "Tab3",),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            _Page("page1"),
            _Page("page2"),
            _Page("page3")
          ],
        )
      ),
    );
  }
}

class _Page extends StatelessWidget {
  final String title;

  _Page(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(title),
      ),
    );
  }
}