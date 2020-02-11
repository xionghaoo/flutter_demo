import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var textController = TextEditingController();
  FocusNode focusNode;

  bool isSearching = false;

  List<Widget> _searchResult() {
    if (!isSearching || textController.text.isEmpty) {
      return [];
    }
    var widgets = List<Widget>();
    for (var i = 0; i < 20; i++) {
      final itemWidget = Container(
        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
        alignment: Alignment.topLeft,
        child: Text("result $i"),
      );
      widgets.add(itemWidget);
    }
    return widgets;
  }

  @override
  void initState() {
    textController.addListener(() {
      setState(() {
        isSearching = focusNode.hasFocus;
      });
    });
    super.initState();

    focusNode = FocusNode();
  }
  
  @override
  void dispose() {
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("搜索"),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 50,
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.cyan,
              ),
              borderRadius: BorderRadius.circular(25)
            ),
            child: TextField(
              autofocus: false,
              controller: textController,
              focusNode: focusNode,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "请输入关键词",
                prefixIcon: Icon(Icons.search),
                suffixIcon: focusNode.hasFocus && textController.text.isNotEmpty
                    ? IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        focusNode.unfocus();
                        textController.clear();
                      })
                    : null
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: _searchResult(),
            ),
          )
        ],
      ),
    );
  }
}