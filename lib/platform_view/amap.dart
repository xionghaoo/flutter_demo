import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AmapView extends StatefulWidget {

  @override
  _AmapViewState createState() => _AmapViewState();
}

class _AmapViewState extends State<AmapView> {
  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: "xh.zero/amap",
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    }

    return Text("Not support platform");
  }

  void _onPlatformViewCreated(int id) {

  }
}