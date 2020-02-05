import 'package:flutter/material.dart';

class TestAnimPage extends StatefulWidget {

  @override
  _TestAnimPageState createState() => _TestAnimPageState();
}

class _TestAnimPageState extends State<TestAnimPage> with SingleTickerProviderStateMixin {

  Animation<double> animation;
  AnimationController controller;


  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this
    );

    // define the animation object
//    animation = Tween<double>(begin: 0, end: 300).animate(controller)
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      })
      ..addStatusListener((state) => print('$state, ${controller.value}'));
    // 启动动画
//    controller.forward();
  }


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('动画测试'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('开始动画'),
              onPressed: () => controller.forward(),
            ),
            SizedBox(height: 20,),
//              GrowTransition(
//                child: LogWidget(),
//                animation: animation,
//              ),
            AnimatedLogo(animation: animation)
          ],
        ),
      ),
    );
  }
}

// render this transition
// 责任分离，将动画和组件分开实现
class GrowTransition extends StatelessWidget {
  GrowTransition({this.child, this.animation});

  final Widget child;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) => Container(
          height: animation.value,
          width: animation.value,
          child: child,
        ),
        child: child,
      ),
    );
  }
}

// render the logo
class LogWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Container(
    margin: EdgeInsets.symmetric(vertical: 10),
    child: FlutterLogo(),
  );
}

// 动画和组件耦合度较高
class AnimatedLogo extends AnimatedWidget {

  static final _opacityTween = Tween<double>(begin: 0.1, end: 1);
  static final _sizeTween = Tween<double>(begin: 0, end: 300);
  static final _colorTween = ColorTween(begin: Colors.red, end: Colors.blue);

  AnimatedLogo({Key key, Animation<double> animation})
    : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Center(
      child: Opacity(
        opacity: _opacityTween.evaluate(animation),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              height: _sizeTween.evaluate(animation),
              width: _sizeTween.evaluate(animation),
              child: FlutterLogo(),
            ),
            SizedBox(height: 20,),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: _colorTween.evaluate(animation),
                borderRadius: BorderRadius.circular(10)
              ),
            )
          ],
        ),
      ),
    );
  }
}