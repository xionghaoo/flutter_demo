import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/platform_view/text_view.dart';

class NativeTextView extends StatefulWidget {

  @override
  _NativeTextViewState createState() => _NativeTextViewState();
}

class _NativeTextViewState extends State<NativeTextView> {

  String _currentPlatform;
  String _viewName;

  @override
  void initState() {
    super.initState();
    if (defaultTargetPlatform == TargetPlatform.android) {
      _currentPlatform = "Android";
      _viewName = "TextView";
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      _currentPlatform = "iOS";
      _viewName = "UILabel";
    } else {
      _currentPlatform = "error platform";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("原生TextView"),
      ),
      body: Center(
        // AndroidView或UIKitView默认会撑满父组件容器
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text("当前平台为$_currentPlatform, 下面的视图由原生$_viewName提供。", style: TextStyle(fontSize: 16),),
            ),
            SizedBox(height: 20,),
            Container(
              width: 200,
              height: 100,
              color: Colors.yellow,
              child: TextView(
                onTextViewCreated: (controller) => controller.setText("Hello from Native!"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}