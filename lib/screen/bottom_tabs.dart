import 'package:flutter/material.dart';
import 'package:flutter_demo/theme/colors.dart';

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

  BottomNavigationBarItem _bottomNavigationBarItem(int index, IconData icon, String title) {
    return BottomNavigationBarItem(
      icon: _iconForIndex(index, icon),
      title: _textForIndex(index, title)
    );
  }

  Icon _iconForIndex(int index, IconData icon) {
    return currentSelectedPage == index
        ? Icon(icon, color: primaryColor, size: 28)
        : Icon(icon, color: Colors.grey);
  }

  Text _textForIndex(int index, String title) {
    return currentSelectedPage == index
        ? Text(title, style: TextStyle(color: primaryColor, fontSize: 15))
        : Text(title, style: TextStyle(color: Colors.grey, fontSize: 14));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tab切换")),
      body: Center(
        child: tabs.elementAt(currentSelectedPage),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          _bottomNavigationBarItem(0, Icons.home, "Home"),
          _bottomNavigationBarItem(1, Icons.business, "Business"),
          _bottomNavigationBarItem(2, Icons.search, "Search"),
          _bottomNavigationBarItem(3, Icons.person, "Profile")
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: currentSelectedPage,
        onTap: _onItemTapped,
      ),
    );
  }
}