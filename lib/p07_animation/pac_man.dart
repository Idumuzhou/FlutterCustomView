import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_custom_view/utils/screen_utils.dart';

/// create by LXL
/// description: 吃豆人
/// date: 2021/2/3 14:32

class PacMan extends StatefulWidget {
  final Color color; //控制颜色
  final double angle; //控制开口大小

  PacMan({Key key, this.color = Colors.lightBlue, this.angle = 30}) : super(key: key);

  @override
  _PacManState createState() => _PacManState();
}

class _PacManState extends State<PacMan> with SingleTickerProviderStateMixin {
  AnimationController _animationController; // 动画控制器

  Animation<Color> _colorCtrl; //声明颜色控制器
  Animation<double> _angleCtrl; //声明角度控制器

  @override
  void initState() {
    super.initState();
    ScreenUtils.setScreenHorizontal();
    //lowerBound 是运动的下限，upperBound 是运动的上限 ，duration 是运动时长。
    //下面的 _controller 会在两秒之内将数值从 10 连续变化到 40。
    _animationController = AnimationController(duration: const Duration(seconds: 1), vsync: this);

    //使用 double 范围 [10,40] 的 Tween 创建动画器
    _angleCtrl = _animationController.drive(Tween(begin: 10, end: 40));

    // 使用 color 范围 [Colors.blue,Colors.red] 的 ColorTween 创建动画器
    _colorCtrl = ColorTween(begin: Colors.blueAccent, end: Colors.red).animate(_animationController);

    //重复执行动画
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
    ScreenUtils.setScreenVertical();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(100, 100),
      painter: PicManPainter(color: _colorCtrl, angle: _angleCtrl, repaint: _animationController),
    );
  }
}

///[1]. 练习绘制静态效果。
/// [2]. 了解如何在画布中 [使用动画]。
/// [3]. 了解 [Animation] 和 [Animatable] 对象的作用。
/// [4]. 学会使用动画器完成多种属性的过渡效果及 [自定义过渡器]。
class PicManPainter extends CustomPainter {
  //final Color color; // 颜色
  //final double angle; // 角度(与x轴交角 角度制)
  Paint _paint = Paint();

  final Animation<double> repaint;
  final Animation<double> angle; // 角度控制
  final Animation<Color> color;  //颜色控制

  PicManPainter({this.repaint, this.color, this.angle}) : super(repaint: angle); // <--- 传入 Listenable 可监听对象

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size); //剪切画布
    final double radius = size.width / 2;
    canvas.translate(radius, size.height / 2);

    _drawHead(canvas, size);
    _drawEye(canvas, radius);
  }

  ///绘制头
  void _drawHead(Canvas canvas, Size size) {
    var rect = Rect.fromCenter(center: Offset(0, 0), width: size.width, height: size.height);
    var a = angle.value / 180 * pi; // <---使用动画器的值
    canvas.drawArc(rect, a, 2 * pi - a.abs() * 2, true, _paint..color = color.value);
  }

  ///绘制眼睛
  void _drawEye(Canvas canvas, double radius) {
    canvas.drawCircle(Offset(radius * 0.15, -radius * 0.6), radius * 0.12, _paint..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant PicManPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.angle != angle;
}
