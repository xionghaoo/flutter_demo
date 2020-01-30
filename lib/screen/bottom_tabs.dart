import 'package:flutter/material.dart';

class BottomTabsPage extends StatefulWidget {

  @override
  _BottomTabsPageState createState() => _BottomTabsPageState();
}

class _BottomTabsPageState extends State<BottomTabsPage> {

  var currentSelectedPage = 0;

  final tabs = <Widget>[
    Text("page1"),
    Text("page2"),
    Text("page3"),
    Text("page4"),
  ];

  void _onItemTapped(int index) {
    setState(() {
      currentSelectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tab切换")),
      body: Center(
        child: tabs.elementAt(currentSelectedPage),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.grey,),
            title: Text("Home"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business, color: Colors.grey),
            title: Text("Business")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Colors.grey),
            title: Text("Search")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.grey),
            title: Text("Profile")
          )
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: currentSelectedPage,
        selectedItemColor: Colors.red[500],
        onTap: _onItemTapped,
      ),
    );
  }
}