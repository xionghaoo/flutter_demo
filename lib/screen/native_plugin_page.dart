import 'package:flutter/material.dart';
import 'package:flutter_demo/plugin/build_config.dart';
import 'package:flutter_demo/screen/amap_page.dart';
import 'package:flutter_demo/screen/native_text_view.dart';

class NativePluginPage extends StatefulWidget {
  static const String path = "/nativePlugin";
  @override
  _NativePluginPageState createState() => _NativePluginPageState();
}

class _NativePluginPageState extends State<NativePluginPage> {

  String _appVersion = '---';

  @override
  void initState() {
    super.initState();
    // 通过插件调用原生
    BuildConfig().applicationVersion.then((version) {
      setState(() {
        _appVersion = version;
      });
    }).catchError((e) => print(e));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("插件方式的原生交互"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text("当前app版本：$_appVersion"),
            RaisedButton(
              child: Text("启动高德地图"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => AmapPage()));
              },
            ),
            RaisedButton(
              child: Text("原生视图"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => NativeTextView()));
              },
            )
          ],
        )
      ),
    );
  }
}