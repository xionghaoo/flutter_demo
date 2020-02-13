import 'package:flutter/material.dart';
import 'package:flutter_demo/platform_view/text_view.dart';

class NativeTextView extends StatefulWidget {

  @override
  _NativeTextViewState createState() => _NativeTextViewState();
}

class _NativeTextViewState extends State<NativeTextView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Android原生TextView"),
      ),
      body: Center(
        // AndroidView默认会撑满父组件容器
        child: Container(
          width: 130,
          height: 100,
          color: Colors.deepPurpleAccent,
          child: TextView(
            onTextViewCreated: (controller) => controller.setText("Hello from Android!"),
          ),
        ),
      ),
    );
  }
}