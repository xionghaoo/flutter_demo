import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_demo/core/water_navigation_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TestPage extends StatefulWidget {

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  int _showIndex;
  int _lastShowIndex;

  Future<void> playAnimation(int index) async {
    print("playAnimation index: $index");
    _showIndex = index;
    _controller.value = 0;
    try {
      await _controller.forward().orCancel;
      setState(() {});
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
      print("the animation got canceled, probably because we were disposed");
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    )..addStatusListener((status) {
      // animation如果想获取field参数，必须手动调用setState，刷新Widget Tree，不然每次生成的动画都是同样的Widget Tree快照
      if (status == AnimationStatus.completed) {
        _lastShowIndex = _showIndex;
      }
      setState(() {});
      print("status: ${status}");
    });
    _showIndex = 0;
    _lastShowIndex = 0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("测试页面"),
      ),
      body: Column(
        children: <Widget>[
//          AnimatedContainer(
//            height: 200,
//            duration: Duration(seconds: 3),
//            child: Center(child: Text("Hello")),
//          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            decoration: ShapeDecoration(
              color: Colors.red,
              shape: _WaterShape(
                controllerPointOneY: 0,
                controllerPointTwoY: 0,
                controllerPointThreeY: 20,
              )
            ),
          ),
          SizedBox(height: 30,),
          RaisedButton(
            child: Text("change shape 1"),
            onPressed: () {
              playAnimation(0);
            },
          ),
          RaisedButton(
            child: Text("change shape 2"),
            onPressed: () {
              playAnimation(1);
            },
          ),
          RaisedButton(
            child: Text("change shape 3"),
            onPressed: () {
              playAnimation(2);
            },
          ),
          SizedBox(height: 30,),
          WaterNavigationBar(
            height: 60,
            backgroundColor: Colors.red,
            fabColor: Colors.green[500],
            onItemTapped: (index) {
              Fluttertoast.showToast(msg: "you clicked $index");
            },
          )
        ],
      ),
    );
  }
}

class WaterAnimationWidget extends AnimatedWidget {
  static final double _waterSize = 30;

  static final _pointOneTween = Tween<double>(begin: 0, end: _waterSize);
  static final _pointTwoTween = Tween<double>(begin: 0, end: _waterSize);
  static final _pointThreeTween = Tween<double>(begin: 0, end: _waterSize);

  final int showIndex;
  final int lastShowIndex;

  WaterAnimationWidget(this.showIndex, this.lastShowIndex, {Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    print("showIndex: ${showIndex}, lastIndex: ${lastShowIndex}");
    final animation = listenable as Animation<double>;
    double y1 = 0;
    double y2 = 0;
    double y3 = 0;
    if (showIndex == 0) {
      if (showIndex == lastShowIndex) {
        y1 = _waterSize;
      } else {
        y1 = _pointOneTween.evaluate(animation);
      }
    } else if (showIndex == 1) {
      if (showIndex == lastShowIndex) {
        y2 = _waterSize;
      } else {
        y2 = _pointTwoTween.evaluate(animation);
      }
    } else if (showIndex == 2) {
      if (showIndex == lastShowIndex) {
        y3 = _waterSize;
      } else {
        y3 = _pointThreeTween.evaluate(animation);
      }
    }

    if (lastShowIndex != showIndex) {
      if (lastShowIndex == 0) {
        y1 = _waterSize -_pointOneTween.evaluate(animation);
      } else if (lastShowIndex == 1) {
        y2 = _waterSize -_pointTwoTween.evaluate(animation);
      } else if (lastShowIndex == 2) {
        y3 = _waterSize - _pointThreeTween.evaluate(animation);
      }
    }

    return Container(
      width: 300,
      height: 200,
      decoration: ShapeDecoration(
          color: Colors.blue,
          shape: _WaterShape(
              controllerPointOneY: y1,
              controllerPointTwoY: y2,
              controllerPointThreeY: y3
          )
      ),
    );
  }
}

//class TestShape extends ShapeBorder {
//
//}

class CustomShape extends ShapeBorder {

  final bool usePadding;

  final double controllerPointY;

  CustomShape(this.controllerPointY, {this.usePadding = true});

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(0);

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {}

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) => null;

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
//    rect = Rect.fromPoints(rect.topLeft, rect.bottomRight - Offset(0, 20));
//    num degToRad(num deg) => deg * (Math.pi / 180.0);
    rect = Rect.fromPoints(rect.topLeft, rect.bottomRight);

//    final double mainRadius = 40;
//    final double subRadius = 10;
//    return Path()
//      ..moveTo(rect.topLeft.dx, rect.topLeft.dy)
//      ..lineTo(rect.topCenter.dx - (mainRadius + subRadius), rect.topCenter.dy)
//      ..arcTo(Rect.fromCircle(center: rect.topCenter + Offset(-(mainRadius + subRadius), subRadius), radius: subRadius), pi * 1.5, pi * 0.5, false)
//      ..arcTo(Rect.fromCircle(center: rect.topCenter + Offset(0, subRadius), radius: mainRadius), pi - atan(subRadius/mainRadius), -(pi - atan(subRadius/mainRadius) * 2), false)
//      ..arcTo(Rect.fromCircle(center: rect.topCenter + Offset(mainRadius + subRadius, subRadius), radius: subRadius), pi, pi / 2, false)
//      ..lineTo(rect.topRight.dx, rect.topRight.dy)
//      ..lineTo(rect.bottomRight.dx, rect.bottomRight.dy)
//      ..lineTo(rect.bottomLeft.dx, rect.bottomLeft.dy)
//      ..close();

    return Path()
      ..moveTo(rect.topLeft.dx, rect.topLeft.dy)
      ..lineTo(rect.topCenter.dx - 60, rect.topCenter.dy)
      ..cubicTo(
          rect.topCenter.dx - 30, rect.topCenter.dy,
          rect.topCenter.dx - 30, rect.topCenter.dy + controllerPointY,
          rect.topCenter.dx, rect.topCenter.dy + controllerPointY
      )
      ..cubicTo(
          rect.topCenter.dx + 30, rect.topCenter.dy + controllerPointY,
          rect.topCenter.dx + 30, rect.topCenter.dy,
          rect.topCenter.dx + 60, rect.topCenter.dy
      )
      ..lineTo(rect.topRight.dx, rect.topRight.dy)
      ..lineTo(rect.bottomRight.dx, rect.bottomRight.dy)
      ..lineTo(rect.bottomLeft.dx, rect.bottomLeft.dy)
      ..close();

  }

  @override
  ShapeBorder scale(double t) => this;
}

class _WaterShape extends ShapeBorder {

  final bool usePadding;

  final double controllerPointOneY;
  final double controllerPointTwoY;
  final double controllerPointThreeY;

  _WaterShape({
    @required this.controllerPointOneY,
    @required this.controllerPointTwoY,
    @required this.controllerPointThreeY,
    this.usePadding = true
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(0);

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {}

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) => null;

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    rect = Rect.fromPoints(rect.topLeft, rect.bottomRight);
    final double partWidth = rect.width / 3;
    final Offset partOneCenter = Offset(rect.topLeft.dx + partWidth * 0.5, rect.topCenter.dy);
    final Offset partTwoCenter = Offset(rect.topLeft.dx + partWidth * 1.5, rect.topCenter.dy);
    final Offset partThreeCenter = Offset(rect.topLeft.dx + partWidth * 2.5, rect.topCenter.dy);

    final waterSize = partWidth / 3;

    return Path()
      ..moveTo(rect.topLeft.dx, rect.topLeft.dy)
    // part one
      ..lineTo(partOneCenter.dx - waterSize, rect.topCenter.dy)
      ..cubicTo(
          partOneCenter.dx - waterSize / 2, rect.topCenter.dy,
          partOneCenter.dx - waterSize / 2, rect.topCenter.dy + controllerPointOneY,
          partOneCenter.dx, rect.topCenter.dy + controllerPointOneY
      )
      ..cubicTo(
          partOneCenter.dx + waterSize / 2, rect.topCenter.dy + controllerPointOneY,
          partOneCenter.dx + waterSize / 2, rect.topCenter.dy,
          partOneCenter.dx + waterSize, rect.topCenter.dy
      )
    // part two
      ..lineTo(partTwoCenter.dx - waterSize, rect.topCenter.dy)
      ..cubicTo(
          partTwoCenter.dx - waterSize / 2, rect.topCenter.dy,
          partTwoCenter.dx - waterSize / 2, rect.topCenter.dy + controllerPointTwoY,
          partTwoCenter.dx, rect.topCenter.dy + controllerPointTwoY
      )
      ..cubicTo(
          partTwoCenter.dx + waterSize / 2, rect.topCenter.dy + controllerPointTwoY,
          partTwoCenter.dx + waterSize / 2, rect.topCenter.dy,
          partTwoCenter.dx + waterSize, rect.topCenter.dy
      )
    // part three
      ..lineTo(partThreeCenter.dx - waterSize, rect.topCenter.dy)
      ..cubicTo(
          partThreeCenter.dx - waterSize / 2, rect.topCenter.dy,
          partThreeCenter.dx - waterSize / 2, rect.topCenter.dy + controllerPointThreeY,
          partThreeCenter.dx, rect.topCenter.dy + controllerPointThreeY
      )
      ..cubicTo(
          partThreeCenter.dx + waterSize / 2, rect.topCenter.dy + controllerPointThreeY,
          partThreeCenter.dx + waterSize / 2, rect.topCenter.dy,
          partThreeCenter.dx + waterSize, rect.topCenter.dy
      )
      ..lineTo(rect.topRight.dx, rect.topRight.dy)
      ..lineTo(rect.bottomRight.dx, rect.bottomRight.dy)
      ..lineTo(rect.bottomLeft.dx, rect.bottomLeft.dy)
      ..close();

  }

  @override
  ShapeBorder scale(double t) => this;
}