import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FormPage extends StatefulWidget {

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("表单测试"),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
//                    hintText: "用户名",
                  labelText: "用户名"
                ),
                // validator返回的error是显示在输入框下面的信息
                validator: (value) {
                  if (value.isEmpty) {
                    return "请输入用户名";
                  }
                  return null;
                },
              ),
              RaisedButton(
                child: Text("Submit"),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    Fluttertoast.showToast(msg: "提交成功");
                  } else {

                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}