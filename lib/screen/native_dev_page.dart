import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_demo/core/common_widgets.dart';
import 'package:flutter_demo/screen/native_call_page.dart';
import 'package:flutter_demo/screen/native_plugin_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NativeDevPage extends StatefulWidget {

  static const String path = "/nativeDev";

  @override
  _NativeDevPageState createState() => _NativeDevPageState();
}

class _NativeDevPageState extends State<NativeDevPage> with SingleTickerProviderStateMixin {

  AnimationController _controller;
  CurvedAnimation _animation;
  CurvedAnimation _opacityAnimation;

//  AnimationController _opacityAnimController;

  Widget _taiji() {
    final double tajiSize = MediaQuery.of(context).size.width / 2;
    final double magatamaRadius = tajiSize / 8;
    return Stack(
      children: <Widget>[
        Transform.translate(
          offset: Offset(
            Tween<double>(begin: -30, end: 0).evaluate(_animation),
            Tween<double>(begin: -5, end: 0).evaluate(_animation),
          ),
          child: Stack(
            children: <Widget>[
              Container(
                width: tajiSize,
                height: tajiSize,
                decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: MagatamaLeftShape()
                ),
              ),
              Positioned(
                  top: tajiSize / 4 - magatamaRadius / 2,
                  left: tajiSize / 2 - magatamaRadius / 2,
                  child: Container(
                    width: magatamaRadius,
                    height: magatamaRadius,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                  )
              ),
            ],
          ),
        ),
        Transform.translate(
          offset: Offset(
            Tween<double>(begin: 30, end: 0).evaluate(_animation),
            Tween<double>(begin: 5, end: 0).evaluate(_animation),
          ),
          child: Stack(
            children: <Widget>[
              Container(
                width: tajiSize,
                height: tajiSize,
                decoration: ShapeDecoration(
                    color: Colors.black,
                    shape: MagatamaRightShape()
                ),
              ),
              Positioned(
                top: tajiSize / 4 * 3 - magatamaRadius / 2,
                left: tajiSize / 2 - magatamaRadius / 2,
                child: Container(
                  width: magatamaRadius,
                  height: magatamaRadius,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                )
              )
            ],
          ),
        ),
        Opacity(
          opacity: Tween<double>(begin: 0, end: 1).evaluate(_opacityAnimation),
          child: Container(
            width: tajiSize,
            height: tajiSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 2)
            ),
          ),
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this
    );
    _animation = CurvedAnimation(parent: _controller, curve: Interval(0, 0.8, curve: Curves.ease));
    _opacityAnimation = CurvedAnimation(parent: _controller, curve: Interval(0.7, 1, curve: Curves.linear));
//    _controller.addListener((state) {
//
//    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double tajiSize = MediaQuery.of(context).size.width / 2;
    final double magatamaRadius = tajiSize / 8;

    final rotateAnimation = Tween<double>(begin: 0, end: pi).animate(_animation);
    rotateAnimation.addStatusListener((state) {
      if (state == AnimationStatus.completed) {
//        if (_startPage == 0) {
//          Fluttertoast.showToast(msg: "启动A页面");
//        } else {
//          Fluttertoast.showToast(msg: "启动B页面");
//        }
      }
    });

    final topButtonTranslateYAnimation = Tween<double>(begin: -30, end: 0).animate(_animation);
    final bottomButtonTranslateYAnimation = Tween<double>(begin: 30, end: 0).animate(_animation);
    return Scaffold(
      appBar: AppBar(
        title: Text("原生开发"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              if (_controller.isAnimating) {
                Fluttertoast.showToast(msg: "动画正在播放...");
                return;
              }
              _controller.value = 0;
              _controller.forward();
            },
          )
        ],
      ),
      backgroundColor: Colors.yellow,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            AnimatedBuilder(
              animation: topButtonTranslateYAnimation,
              builder: (context, child) => Transform.translate(
                offset: Offset(0, topButtonTranslateYAnimation.value),
                child: InkBox(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black,
                    onTap: () {
                      Navigator.pushNamed(context, NativeCallPage.path);
                    },
                    child: Container(
                      width: 120,
                      height: 40,
                      child: Center(
                          child: Text("非插件方式", style: TextStyle(color: Colors.white),)
                      ),
                    )
                ),
              ),
            ),
            SizedBox(height: 20,),
            AnimatedBuilder(
              animation: rotateAnimation,
              builder: (context, child) {
                return Transform.rotate(angle: rotateAnimation.value, child: _taiji());
              },
              child: _taiji()
            ),
//            _taiji(),
            SizedBox(height: 20,),
            AnimatedBuilder(
              animation: bottomButtonTranslateYAnimation,
              builder: (context, child) => Transform.translate(
                offset: Offset(0, bottomButtonTranslateYAnimation.value),
                child: InkBox(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    onTap: () {
                      Navigator.pushNamed(context, NativePluginPage.path);
                    },
                    child: Container(
                      width: 120,
                      height: 40,
                      child: Center(
                          child: Text("插件方式", style: TextStyle(color: Colors.black),)
                      ),
                    )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MagatamaRightShape extends ShapeBorder {

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(0);

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {
    
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) => null;

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    rect = Rect.fromPoints(rect.topLeft, rect.bottomRight);
    return Path()
      ..moveTo(rect.topCenter.dx, rect.topCenter.dy)
      ..arcTo(Rect.fromCircle(center: rect.topCenter + Offset(0, rect.height / 2), radius: rect.height / 2), pi*1.5, pi, false)
      ..arcTo(Rect.fromCircle(center: rect.topCenter + Offset(0, rect.height / 4 * 3), radius: rect.height / 4), pi/2, pi, false)
      ..arcTo(Rect.fromCircle(center: rect.topCenter + Offset(0, rect.height / 4), radius: rect.height / 4), pi/2, -pi, false)
//      ..addPath(
//          Path()
//            ..moveTo(rect.topCenter.dx, rect.topCenter.dy + rect.height * 0.75 - rect.height / 8)
//            ..addArc(Rect.fromCircle(center: Offset(rect.topCenter.dx, rect.topCenter.dy + rect.height * 0.75), radius: rect.height / 8), 0, pi*2)
//            ..close(),
//          Offset(0, 0)
//      )
      ..close();
  }

  @override
  ShapeBorder scale(double t) => this;
}

class MagatamaLeftShape extends ShapeBorder {

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(0);

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {

  }

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) => null;

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    rect = Rect.fromPoints(rect.topLeft, rect.bottomRight);
    return Path()
      ..moveTo(rect.topCenter.dx, rect.topCenter.dy)
      ..arcTo(Rect.fromCircle(center: rect.topCenter + Offset(0, rect.height / 4), radius: rect.height / 4), pi * 1.5, pi, false)
      ..arcTo(Rect.fromCircle(center: rect.topCenter + Offset(0, rect.height / 4 * 3), radius: rect.height / 4), pi * 1.5, -pi, false)
      ..arcTo(Rect.fromCircle(center: rect.topCenter + Offset(0, rect.height / 2), radius: rect.height / 2), pi*0.5, pi, false)
      ..close();
  }

  @override
  ShapeBorder scale(double t) => this;
}