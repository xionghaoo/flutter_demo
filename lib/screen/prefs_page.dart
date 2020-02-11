import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesPage extends StatefulWidget {

  @override
  _SharedPreferencesPageState createState() => _SharedPreferencesPageState();
}

class _SharedPreferencesPageState extends State<SharedPreferencesPage> {

  TableRow _tableRow;
  String _key;
  int _value;

  Future<void> _saveIntData(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  Future<int> _getIntData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.get(key);
  }

  void _set() {
    _saveIntData(_key, _value).then((_) {
      _updateTableData();
    }).catchError((e) => print(e));
  }

  void _updateTableData() {
    _getIntData(_key).then((v) {
      setState(() {
        _tableRow = TableRow(
            children: [
              Text(_key),
              Text(v.toString())
            ]
        );
      });
    }).catchError((e) => print(e));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SharedPreferences测试"),
      ),
      body: LayoutBuilder(
        builder: (context, viewportConstraints) => ConstrainedBox(
          constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Table(
                    children: [
                      TableRow(
                        children: [
                          Text("key"),
                          Text("value")
                        ]
                      )
                    ] + (_tableRow == null ? [] : [_tableRow]),
                  ),
                  Row(
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Key",
                            ),
                            onChanged: (value) {
                              _key = value;
                            },
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "输入整数",
                            ),
                            onChanged: (value) {
                              try {
                                _value = int.parse(value);
                              } catch(e) {
                                Fluttertoast.showToast(msg: "数据格式错误");
                              }
                            },
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: RaisedButton(
                          child: Text("添加数据"),
                          onPressed: _set,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}