import 'package:flutter/material.dart';

class InkBox extends StatelessWidget {

  final BorderRadius borderRadius;
  final Color color;
  final Widget child;
  final Function onTap;

  InkBox({
    @required this.borderRadius,
    @required this.color,
    @required this.onTap,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      // 必须指定裁剪类型，默认是不裁剪
      clipBehavior: Clip.antiAlias,
      borderRadius: borderRadius,
      child: Ink(
        // 对InkWell包裹的widget进行装饰，可以添加padding
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
        ),
        child: InkWell(
          child: child,
          onTap: onTap,
        ),
      ),
    );
  }
}