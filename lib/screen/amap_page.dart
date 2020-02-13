import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/platform_view/amap_view.dart';

class AmapPage extends StatefulWidget {

  @override
  _AmapPageState createState() => _AmapPageState();
}

class _AmapPageState extends State<AmapPage> {

  static const platform = const MethodChannel("xh.zero/map");

  Future<void> _startNativePage() async {
    await platform.invokeMethod("startAMapPage");
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("高德地图测试"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text("开启原生高德地图页面"),
              onPressed: () {
                _startNativePage();
              },
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text("下面是高德地图的Flutter widget(Android端)"),
            ),
            Expanded(
              child: AmapView(),
            )
          ],
        ),
      ),
    );
  }
}