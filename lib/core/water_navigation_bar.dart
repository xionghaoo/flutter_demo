import 'package:flutter/material.dart';

class WaterNavigationBar extends StatefulWidget {

  final double height;
  final Color backgroundColor;
  final Color fabColor;
  final List<Widget> icons;
  final List<Widget> fabIcons;
  final Function(int) onItemTapped;

  WaterNavigationBar({
    @required this.height,
    @required this.backgroundColor,
    @required this.fabColor,
    @required this.icons,
    @required this.fabIcons,
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
//  bool _isInitial = true;
  MenuStatus _menuStatus = MenuStatus.initial;

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
      width: MediaQuery.of(context).size.width,
      color: widget.backgroundColor,
      fabColor: widget.fabColor,
      icons: widget.icons,
      fabIcons: widget.fabIcons,
      menuStatus: _menuStatus,
      onItemClick: (index) {
        switch (index) {
          case 0: _menuStatus = MenuStatus.showOne; break;
          case 1: _menuStatus = MenuStatus.showTwo; break;
          case 2: _menuStatus = MenuStatus.showThree; break;
        }
        playAnimation(index);
        widget.onItemTapped(index);
      },
      animation: _animation,
//      child: Row(
//        children: <Widget>[
//          _tabItemWidget(Icons.home, () {
//            playAnimation(0);
//            widget.onItemTapped(0);
//          }),
//          _tabItemWidget(Icons.style, () {
//            playAnimation(1);
//            widget.onItemTapped(1);
//          }),
//          _tabItemWidget(Icons.person, () {
//            playAnimation(2);
//            widget.onItemTapped(2);
//          })
//        ],
//      ),
    );
  }
}

enum MenuStatus {
  initial, showOne, showTwo, showThree
}

class _WaterAnimationWidget extends AnimatedWidget {
  static final double _waterSize = 25;

  static final _pointOneTween = Tween<double>(begin: 0, end: _waterSize);
  static final _pointTwoTween = Tween<double>(begin: 0, end: _waterSize);
  static final _pointThreeTween = Tween<double>(begin: 0, end: _waterSize);
  static final _scaleTween = Tween<double>(begin: 0, end: 1);
  static final _scaleDisappearTween = Tween<double>(begin: 1, end: 0);
  static final _opacityOneTween = Tween<double>(begin: 1, end: 0);
  static final _opacityTwoTween = Tween<double>(begin: 1, end: 0);
  static final _opacityThreeTween = Tween<double>(begin: 1, end: 0);

  final MenuStatus menuStatus;
  final int showIndex;
  final int lastShowIndex;
  final double height;
  final double width;
//  final Widget child;
  final Color color;
  final Color fabColor;
  final List<Widget> icons;
  final List<Widget> fabIcons;
  final Function(int) onItemClick;

  _WaterAnimationWidget({Key key,
    @required this.showIndex,
    @required this.lastShowIndex,
    @required this.height,
    @required this.width,
//    @required this.child,
    @required this.color,
    @required this.fabColor,
    @required this.icons,
    @required this.fabIcons,
    @required this.menuStatus,
    @required this.onItemClick,
    Animation<double> animation
  }) : super(key: key, listenable: animation);

  Widget _floatActionButton(Widget icon, Color color, Color iconColor) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        // 在Material组件外部自己添加阴影，
        // Material的阴影太硬，在这添加更加柔和的阴影
        boxShadow: [
          BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.1), blurRadius: 10)
        ]
      ),
      child: Material(
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(30),
//      shadowColor: Color.fromRGBO(0, 0, 0, 0.5),
//      elevation: 16,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: color,
          ),
          child: InkWell(
            child: Container(
              width: 56,
              height: 56,
              child: Center(
                child: icon,
              ),
            ),
            onTap: () => print("Clicked"),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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

//    print("menuStatus: $menuStatus, showIndex: $showIndex, lastShowIndex: $lastShowIndex, _opacityOneTween: ${_opacityOneTween.evaluate(animation)}");

    // 赋值消失动画
    Offset iconOneTranslate = lastShowIndex != 0 && showIndex != 0
        ? Offset(0, 0)
        : Offset(0, Tween<double>(begin: -63, end: 0).evaluate(animation));
    double iconOneOpacity = lastShowIndex != 0 && showIndex != 0
        ? 1
        : 1 - _opacityOneTween.evaluate(animation);
    double fabOneScale = lastShowIndex != 0 && showIndex != 0
        ? 0
        : Tween<double>(begin: 1, end: 0).evaluate(animation);

    // 赋值消失动画
    Offset iconTwoTranslate = lastShowIndex != 1 && showIndex != 1
        ? Offset(0, 0)
        : Offset(0, Tween<double>(begin: -63, end: 0).evaluate(animation));
    double iconTwoOpacity = lastShowIndex != 1 && showIndex != 1
        ? 1
        : 1 - _opacityTwoTween.evaluate(animation);
    double fabTwoScale = lastShowIndex != 1 && showIndex != 1
        ? 0
        : Tween<double>(begin: 1, end: 0).evaluate(animation);

    // 赋值消失动画
    Offset iconThreeTranslate = lastShowIndex != 2 && showIndex != 2
        ? Offset(0, 0)
        : Offset(0, Tween<double>(begin: -63, end: 0).evaluate(animation));
    double iconThreeOpacity = lastShowIndex != 2 && showIndex != 2
        ? 1
        : 1 - _opacityThreeTween.evaluate(animation);
    double fabThreeScale = lastShowIndex != 2 && showIndex != 2
        ? 0
        : _scaleDisappearTween.evaluate(animation) ;

    // 赋值消失动画
//    Offset iconThreeTranslate = Offset(0, Tween<double>(begin: -63, end: 0).evaluate(animation));
//    double iconThreeOpacity = 1 - _opacityThreeTween.evaluate(animation);
//    double fabThreeScale = Tween<double>(begin: 1, end: 0).evaluate(animation);
    switch (menuStatus) {
      case MenuStatus.initial:
        iconOneTranslate = Offset(0, 0);
        iconOneOpacity = 0;
        fabOneScale = 1;
        break;
      case MenuStatus.showOne:
        iconOneTranslate = Offset(0, Tween<double>(begin: 0, end: -63).evaluate(animation));
        iconOneOpacity = _opacityOneTween.evaluate(animation);
        fabOneScale = _scaleTween.evaluate(animation);
        break;
      case MenuStatus.showTwo:
        iconTwoTranslate = Offset(0, Tween<double>(begin: 0, end: -63).evaluate(animation));
        iconTwoOpacity = _opacityTwoTween.evaluate(animation);
        fabTwoScale = _scaleTween.evaluate(animation);
        break;
      case MenuStatus.showThree:
        iconThreeTranslate = Offset(0, Tween<double>(begin: 0, end: -63).evaluate(animation));
        iconThreeOpacity = _opacityThreeTween.evaluate(animation);
        fabThreeScale = _scaleTween.evaluate(animation);
        break;
    }

    return Stack(
      children: <Widget>[
        Container(
          alignment: Alignment.bottomCenter,
          width: width,
          height: height + _waterSize + 15,
          decoration: BoxDecoration(
            color: Colors.transparent
          ),
          child: Container(
            width: width,
            height: height,
            decoration: ShapeDecoration(
              color: color == null ? Colors.white : color,
              shape: _WaterShape(
                  controllerPointOneY: y1,
                  controllerPointTwoY: y2,
                  controllerPointThreeY: y3
              ),
              shadows: [
                BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.1), blurRadius: 10)
              ]
            ),
            child: Row(
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: Transform.translate(
                    offset: iconOneTranslate,
                    child: Opacity(
                      opacity: iconOneOpacity,
                      child: Center(
                        child: GestureDetector(
                          child: Container(
                            width: height,
                            height: height,
                            decoration: BoxDecoration(
                              color: Colors.transparent
                            ),
                            child: icons[0],
                          ),
                          onTap: () {onItemClick(0);},
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Transform.translate(
                    offset: iconTwoTranslate,
                    child: Opacity(
                      opacity: iconTwoOpacity,
                      child: Center(
                        child: GestureDetector(
                          child: Container(
                            width: height,
                            height: height,
                            decoration: BoxDecoration(
                                color: Colors.transparent
                            ),
                            child: icons[1],
                          ),
                          onTap: () {onItemClick(1);},
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Transform.translate(
                    offset: iconThreeTranslate,
                    child: Opacity(
                      opacity: iconThreeOpacity,
                      child: Center(
                        child: GestureDetector(
                          child: Container(
                            width: height,
                            height: height,
                            decoration: BoxDecoration(
                                color: Colors.transparent
                            ),
                            child: icons[2],
                          ),
                          onTap: () {onItemClick(2);},
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned(
//          top: 0,
          left: width / 3 * 0.5 - 28,
          child: Transform.scale(
            scale: fabOneScale,
            child: _floatActionButton(fabIcons[0], color == null ? Colors.blue : fabColor, Colors.white),
          )
        ),
        Positioned(
//            top: -(_waterSize + 15),
            left: width / 3 * 1.5 - 28,
            child: Transform.scale(
              scale: fabTwoScale,
              child: _floatActionButton(fabIcons[1], color == null ? Colors.blue : fabColor, Colors.white),
            )
        ),
        Positioned(
//            top: -(_waterSize + 15),
            left: width / 3 * 2.5 - 28,
            child: Transform.scale(
              scale: fabThreeScale,
              child: _floatActionButton(fabIcons[2], color == null ? Colors.blue : fabColor, Colors.white),
            )
        )
//        Positioned(
//            top: -(_waterSize + 15),
//            left: width / 3 * 2.5 - 28,
//            child: Transform.scale(
//              scale: fabThreeScale,
//              child: FloatingActionButton(
//                elevation: 4,
//                child: Icon(Icons.home),
//                onPressed: () {},
//              ),
//            )
//        )
      ],
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

    final waterSize = partWidth / 2.5;

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