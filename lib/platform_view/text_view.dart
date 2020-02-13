import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef void TextViewCreateCallback(TextViewController controller);

class TextView extends StatefulWidget {

  final TextViewCreateCallback onTextViewCreated;

  TextView({Key key, this.onTextViewCreated}) : super(key: key);

  @override
  _TextViewState createState() => _TextViewState();
}

class _TextViewState extends State<TextView> {
  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: "xh.zero/textview",
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    }

    return Text("not support");
  }

  void _onPlatformViewCreated(int id) {
    if (widget.onTextViewCreated == null) return;

    widget.onTextViewCreated(TextViewController._(id));
  }
}

class TextViewController {
  final MethodChannel _channel;

  TextViewController._(int id) : _channel = MethodChannel("xh.zero/textview_$id");

  Future<void> setText(String txt) async {
    assert(txt != null);
    return _channel.invokeMethod("setText", txt);
  }
}