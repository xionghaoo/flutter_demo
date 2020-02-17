import 'package:flutter/material.dart';
import 'package:flutter_demo/core/network.dart';

class NetworkWidget extends StatefulWidget {

//  final double width;
//  final double height;
  final Widget child;
  final Status status;

  NetworkWidget({
    @required this.status,
    @required this.child
  });

  @override
  _NetworkWidgetState createState() => _NetworkWidgetState();
}

class _NetworkWidgetState extends State<NetworkWidget> {

  Widget _statusWidget() {

    switch(widget.status) {
      case Status.none:
        return SizedBox();
      case Status.success:
        return widget.child;
      case Status.loading:
        return Center(child: CircularProgressIndicator());
      case Status.failure:
        return Center(child: Text("加载失败"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return _statusWidget();
  }
}