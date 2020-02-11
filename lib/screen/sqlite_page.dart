import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_demo/repo/data/dog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlitePage extends StatefulWidget {

  @override
  _SqlitePageState createState() => _SqlitePageState();
}

class _SqlitePageState extends State<SqlitePage> {

  Future<Database> _database;
  List<TableRow> _tableRows = [];
  String _addName;
  int _addAge;
  int _deleteId;
  int _updateId;
  String _updateName;
  int _updateAge;

  // 创建数据库
  Future<Database> _getDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'dogs_database.db'),
      onCreate: (db, version) {
        return db.execute("CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)");
      },
      version: 1
    );
  }

  Future<void> _insertDog(Dog dog) async {
    final Database db = await _database;
    db.insert('dogs', dog.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Dog>> _getDogs() async {
    final Database db = await _database;
    final List<Map<String, dynamic>> maps = await db.query('dogs');
    return List.generate(maps.length, (index) =>
      Dog(
        maps[index]["id"],
        maps[index]["name"],
        maps[index]["age"],
      )
    );
  }

  Future<void> _deleteDog(int id) async {
    final Database db = await _database;
    db.delete('dogs', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> _deleteAll() async {
    final Database db = await _database;
    db.delete('dogs');
  }

  Future<void> _updateDog(Dog dog) async {
    final Database db = await _database;
    db.update('dogs', dog.toMap(), where: 'id = ?', whereArgs: [dog.id]);
  }

  void _add() {
    if (_addAge == null || _addName == null || _addName.isEmpty) return;
    final dog = Dog(_tableRows.length + 1, _addName, _addAge);
    _insertDog(dog).then((_) {
      Fluttertoast.showToast(msg: "插入成功");
      _updateTableContent();
    }).catchError((e) => print(e));
  }

  void _delete() {
    _deleteDog(_deleteId).then((_) {
      Fluttertoast.showToast(msg: "删除成功");
      _updateTableContent();
    }).catchError((e) => print(e));
  }

  void _update() {
    _updateDog(Dog(_updateId, _updateName, _updateAge)).then((_) {
      Fluttertoast.showToast(msg: "更新成功");
      _updateTableContent();
    }).catchError((e) => print(e));
  }

  void _clear() {
    _deleteAll().then((_) {
      _updateTableContent();
    }).catchError((e) => print(e));
  }

  void _updateTableContent() {
    _getDogs().then((dogs) {
      List<TableRow> tmp = [];
      dogs.forEach((dog) {
        tmp.add(
          TableRow(children: [
            Text(dog.id.toString()),
            Text(dog.name),
            Text(dog.age.toString()),
          ])
        );
      });
      setState(() {
        _tableRows = tmp;
      });
    }).catchError((e) => print(e));
  }

  @override
  void initState() {
    super.initState();
    _database = _getDatabase();
    _updateTableContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sqlite测试"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Table(
                border: TableBorder.all(),
                children: [
                  TableRow(children: [
                    Text("id"),
                    Text("name"),
                    Text("age")
                  ])
                ] + _tableRows,
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    flex: 2,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "姓名"
                      ),
                      autofocus: false,
                      onChanged: (value) {
                        _addName = value;
                      },
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "年龄"
                      ),
                      autofocus: false,
                      onChanged: (value) {
                        _addAge = int.parse(value);
                      },
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: RaisedButton(
                      child: Text("插入条目"),
                      onPressed: _add,
                    ),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    flex: 4,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "条目id"
                      ),
                      autofocus: false,
                      onChanged: (value) {
                        _deleteId = int.parse(value);
                      },
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: RaisedButton(
                      child: Text("删除条目"),
                      onPressed: _delete,
                    ),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "id"
                      ),
                      autofocus: false,
                      onChanged: (value) {
                        _updateId = int.parse(value);
                      },
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "姓名"
                      ),
                      autofocus: false,
                      onChanged: (value) {
                        _updateName = value;
                      },
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "年龄"
                      ),
                      autofocus: false,
                      onChanged: (value) {
                        _updateAge = int.parse(value);
                      },
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: RaisedButton(
                      child: Text("更新条目"),
                      onPressed: _update,
                    ),
                  )
                ],
              ),
              RaisedButton(
                child: Text("清空表"),
                onPressed: _clear,
              )
            ],
          ),
        ),
      ),
    );
  }
}