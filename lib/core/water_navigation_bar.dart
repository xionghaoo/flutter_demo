import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WaterNavigationBar extends StatefulWidget {

  final double height;
  final backgroundColor;
  final Function(int) onItemTapped;

  WaterNavigationBar({
    @required this.height,
    @required this.backgroundColor,
    @required this.onItemTapped
  });

  @override
  _WaterNavigationBarState createState() => _WaterNavigationBarState();
}

class _WaterNavigationBarState extends State<WaterNavigationBar> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  int _showIndex;
  int _lastShowIndex;

  Future<void> playAnimation(int index) async {
    _showIndex = index;
    _controller.value = 0;
    try {
      await _controller.forward().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
      print("the animation got canceled, probably because we were disposed");
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: Duration(milliseconds: 500),
        vsync: this
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.ease,
    )..addStatusListener((status) {
      // animation如果想获取field参数，必须手动调用setState，刷新Widget Tree，不然每次生成的动画都是同样的Widget Tree快照
      if (status == AnimationStatus.completed) {
        _lastShowIndex = _showIndex;
      }
      setState(() {});
    });
    _showIndex = 0;
    _lastShowIndex = 0;
  }

  Widget _tabItemWidget(IconData icon, Function onItemTapped) {
    final diameter = MediaQuery.of(context).size.width / 3;
    return Material(
      color: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(diameter / 2),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(diameter / 2),
        ),
        child: InkWell(
          child: Container(
            width: diameter,
            height: diameter,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(icon),
            ),
          ),
          onTap: () {
            onItemTapped();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _WaterAnimationWidget(
      showIndex: _showIndex,
      lastShowIndex: _lastShowIndex,
      height: widget.height,
      color: widget.backgroundColor,
      animation: _animation,
      child: Row(
        children: <Widget>[
          _tabItemWidget(Icons.home, () {
            playAnimation(0);
            widget.onItemTapped(0);
          }),
          _tabItemWidget(Icons.style, () {
            playAnimation(1);
            widget.onItemTapped(1);
          }),
          _tabItemWidget(Icons.person, () {
            playAnimation(2);
            widget.onItemTapped(2);
          })
        ],
      ),
    );
  }
}

class _WaterAnimationWidget extends AnimatedWidget {
  static final double _waterSize = 25;

  static final _pointOneTween = Tween<double>(begin: 0, end: _waterSize);
  static final _pointTwoTween = Tween<double>(begin: 0, end: _waterSize);
  static final _pointThreeTween = Tween<double>(begin: 0, end: _waterSize);

  final int showIndex;
  final int lastShowIndex;
  final double height;
  final Widget child;
  final Color color;

  _WaterAnimationWidget({Key key,
    @required this.showIndex,
    @required this.lastShowIndex,
    @required this.height,
    @required this.child,
    @required this.color,
    Animation<double> animation
  }) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
//    print("showIndex: ${showIndex}, lastIndex: ${lastShowIndex}");
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
      width: MediaQuery.of(context).size.width,
      height: height,
      decoration: ShapeDecoration(
        color: color == null ? Colors.white : color,
        shape: _WaterShape(
            controllerPointOneY: y1,
            controllerPointTwoY: y2,
            controllerPointThreeY: y3
        )
      ),
      child: child,
    );
  }
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