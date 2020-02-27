import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/platform_view/amap_param.dart';

class AmapView extends StatefulWidget {

  final AmapParam param;

  AmapView(this.param);

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
        creationParams: widget.param.toJson().toString(),
        creationParamsCodec: StandardMessageCodec(),
      );
    }

    return Text("Not support platform");
  }

  void _onPlatformViewCreated(int id) {

  }
}