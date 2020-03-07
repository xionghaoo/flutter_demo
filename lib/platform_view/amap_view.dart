import 'dart:convert';

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
  static final String viewType = "xh.zero/amap";
  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: viewType,
        onPlatformViewCreated: _onPlatformViewCreated,
        creationParams: widget.param.toJson().toString(),
        creationParamsCodec: StandardMessageCodec(),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      print("dart json: ${json.encode(widget.param.toJson())}");
      return UiKitView(
        viewType: viewType,
        onPlatformViewCreated: _onPlatformViewCreated,
        creationParams: json.encode(widget.param.toJson()),
        creationParamsCodec: StandardMessageCodec(),
      );
    }

    return Text("Not support platform");
  }

  void _onPlatformViewCreated(int id) {

  }
}