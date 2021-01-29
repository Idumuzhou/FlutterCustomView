import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_custom_view/utils/screen_utils.dart';
import 'package:flutter_custom_view/widgets/coordinate.dart';

/// create by LXL
/// description: Path 上篇
/// date: 2021/1/28 15:20

class PathPage01 extends StatefulWidget {
  @override
  _PathPage01State createState() => _PathPage01State();
}

class _PathPage01State extends State<PathPage01> {
  @override
  void initState() {
    super.initState();
    ScreenUtils.setScreenHorizontal();
  }

  @override
  void dispose() {
    super.dispose();
    ScreenUtils.setScreenVertical();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomPaint(
        painter: PaperPainter(),
      ),
    );
  }
}

class PaperPainter extends CustomPainter {
  Paint _paint;

  PaperPainter() {
    _paint = Paint()
      ..color = Colors.deepOrange
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    Coordinate.paint(canvas, size);

    //moveTo和lineTo: 画线
    _drawPathMoveTo(canvas);

    //relativeMoveTo和relativeLineTo: 相对画线
    _drawPathRelativeMoveTo(canvas);

    //arcTo: 圆弧
    _drawPathArcTo(canvas);

    //点定弧
    _drawPathArcToPoint(canvas);

    //圆锥曲线
    canvas.save();
    _drawPathConicTo(canvas);
    canvas.restore();

    //二阶贝塞尔曲线
    _drawPathQuadraticBezierTo(canvas);

    //三阶贝塞尔曲线
    _drawPathCubicTo(canvas);

    //添加类矩形
    _drawPathAddRect(canvas);
  }

  ///moveTo和lineTo: 画线
  //moveTo相当于提起笔落到纸上的位置坐标，且坐标以画布原点为参考系。
  //lineTo相当于从落笔点画直线到期望的坐标点，且坐标以画布原点为参考系。
  void _drawPathMoveTo(Canvas canvas) {
    canvas.save();
    canvas.translate(-160, 120);
    Path path = Path();
    path
      ..moveTo(0, 0)
      ..lineTo(-60, 60)
      ..lineTo(-60, 0)
      ..lineTo(0, -60)
      ..close();
    canvas.drawPath(
        path,
        _paint
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1);

    Path path2 = Path();
    path2
      ..moveTo(0, 0)
      ..lineTo(60, 60)
      ..lineTo(60, 0)
      ..lineTo(0, -60)
      ..close();
    canvas.drawPath(path2, _paint..style = PaintingStyle.fill);
    canvas.restore();
  }

  ///relativeMoveTo和relativeLineTo: 相对画线
  //如果点位已经知道,使用 moveTo 和 lineTo 会比较方便，但很多情况下是不能直接知道的。
  // 比如在某点的基础上,画一条线，要求左移 10，上移 60，这样点位很难直接确定。
  // 使用 relative 系列方法就会非常简单。如下图形的路径绘制，不用相对坐标会很复杂。
  // 使用相对的坐标会更方便调整(左侧只需移动起始点即可全部移动)
  void _drawPathRelativeMoveTo(Canvas canvas) {
    canvas.save();
    canvas.translate(-340, 100);
    Path path = Path();
    path
      ..relativeMoveTo(0, 0)
      ..relativeLineTo(80, 80)
      ..relativeLineTo(-10, -40)
      ..relativeLineTo(40, -10)
      ..close();
    canvas.drawPath(
        path,
        _paint
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1);
    canvas.restore();

    canvas.save();
    canvas.translate(-340, 0);
    Path path2 = Path();
    path2
      ..relativeMoveTo(0, 0)
      ..relativeLineTo(80, 80)
      ..relativeLineTo(-10, -40)
      ..relativeLineTo(40, -10)
      ..close();
    canvas.drawPath(path2, _paint..style = PaintingStyle.fill);
    canvas.restore();
  }

  ///arcTo: 圆弧
  //arcTo 用于圆弧路径，指定一个矩形域，形成椭圆。
  // 指定起始弧度，和扫描弧度，就可以从椭圆上截取出圆弧。
  // 最后一参代表是否强行移动，如果为true，如图左，绘制圆弧时会先移动到起点。
  void _drawPathArcTo(Canvas canvas) {
    canvas.save();
    canvas.translate(-320, -120);
    Path path = Path();
    path.lineTo(20, 20);
    path.arcTo(Rect.fromCenter(center: Offset(0, 0), width: 100, height: 60), 0, pi * 1.5, true);
    canvas.drawPath(
        path,
        _paint
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke);
    canvas.restore();

    canvas.save();
    canvas.translate(-320, -40);
    Path path2 = Path();
    path2.lineTo(20, 20);
    path2.arcTo(Rect.fromCenter(center: Offset(0, 0), width: 100, height: 60), 0, pi * 1.5, false);
    canvas.drawPath(
        path2,
        _paint
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke);
    canvas.restore();
  }

  ///arcToPoint和relativeArcToPoint: 点定弧
  //当想要画圆弧到某个点，用 arcToPoint 会非常方便
  // 接受一个点位入参 Offset，是圆弧的终点，可指定圆弧半径radius、是否使用优弧、是否顺时针
  void _drawPathArcToPoint(Canvas canvas) {
    //两点确定一个弧度
    ///使用劣弧: largeArc: false ,顺时针:clockwise: true
    canvas.save();
    canvas.translate(-240, -140);
    canvas.drawCircle(Offset(0, 0), 2, _paint..color = Colors.blue);
    Path path = Path();
    path
      ..lineTo(80, -40) //起始点
      ..arcToPoint(Offset(40, 20), //终止点
          radius: Radius.circular(60),
          largeArc: false,
          clockwise: true)
      ..close();
    canvas.drawPath(path, _paint..color = Colors.brown);
    canvas.restore();

    /// 使用优弧: largeArc: true ,逆时针:clockwise: false
    path.reset();
    canvas.save();
    canvas.translate(-220, -20);
    canvas.drawCircle(Offset(0, 0), 2, _paint..color = Colors.blue);
    path
      ..lineTo(80, -40) //起始点
      ..arcToPoint(Offset(40, 20), //终止点
          radius: Radius.circular(50),
          largeArc: true,
          clockwise: false)
      ..close();
    canvas.drawPath(path, _paint..color = Colors.purpleAccent);
    canvas.restore();

    /// 使用优弧: largeArc: true ,顺时针:clockwise: true
    path.reset();
    canvas.save();
    canvas.translate(-140, -100);
    canvas.drawCircle(Offset(0, 0), 2, _paint..color = Colors.blue);
    path
      ..lineTo(50, -50) //起始点
      ..arcToPoint(Offset(50, 50), //终止点
          radius: Radius.circular(50),
          largeArc: true,
          clockwise: true)
      ..close();
    canvas.drawPath(path, _paint..color = Colors.green);
    canvas.restore();
  }

  ///conicTo和relativeConicTo: 圆锥曲线
  //conicTo 接收五个参数用于绘制圆锥曲线，包括椭圆线、抛物线和双曲线
  // 其中前两参是控制点，三四参是结束点，第五参是权重。(下图已画出辅助点)
  // 当权重< 1 时，圆锥曲线是椭圆线,如下左图
  // 当权重= 1 时，圆锥曲线是抛物线,如下中图
  // 当权重> 1 时，圆锥曲线是双曲线,如下右图
  void _drawPathConicTo(Canvas canvas) {
    final Offset p1 = Offset(60, -80);
    final Offset p2 = Offset(120, 0);

    //椭圆线
    canvas.drawCircle(p1, 2, _paint..color = Colors.blue);
    Path path = Path();
    path.conicTo(p1.dx, p1.dy, p2.dx, p2.dy, 0.5);
    canvas.drawPath(
        path,
        _paint
          ..style = PaintingStyle.stroke
          ..color = Colors.red);

    //抛物线
    path.reset();
    canvas.translate(120, 0);
    path.conicTo(p1.dx, p1.dy, p2.dx, p2.dy, 1);
    canvas.drawPath(
        path,
        _paint
          ..style = PaintingStyle.stroke
          ..color = Colors.indigo);

    //双曲线
    path.reset();
    canvas.translate(120, 0);
    path.conicTo(p1.dx, p1.dy, p2.dx, p2.dy, 2);
    canvas.drawPath(
        path,
        _paint
          ..style = PaintingStyle.stroke
          ..color = Colors.cyanAccent);
  }

  ///quadraticBezierTo和relativeQuadraticBezierTo: 二阶贝塞尔
  //quadraticBezierTo接收四个参数用于绘制二阶贝塞尔曲线。
  // 其中前两参是控制点,三四参是结束点。(下图已画出蓝色辅助点线)
  // relativeQuadraticBezierTo是在使用相对位置来加入二阶贝塞尔曲线路径。
  void _drawPathQuadraticBezierTo(Canvas canvas) {
    canvas.save();
    canvas.translate(0, 60);
    final Offset p1 = Offset(100, -100);
    final Offset p2 = Offset(160, 50);
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(p1.dx, p1.dy);
    path.lineTo(p2.dx, p2.dy);
    path.relativeLineTo(p1.dx, p1.dy);
    path.relativeLineTo(60, 150);
    canvas.drawPath(
        path,
        _paint
          ..style = PaintingStyle.stroke
          ..color = Colors.black);
    canvas.drawCircle(p1, 2, _paint..color = Colors.black);
    canvas.drawCircle(p2, 2, _paint..color = Colors.black);

    path.reset();
    path.quadraticBezierTo(p1.dx, p1.dy, p2.dx, p2.dy);
    path.relativeQuadraticBezierTo(p1.dx, p1.dy, p2.dx, p2.dy);
    canvas.drawPath(
        path,
        _paint
          ..style = PaintingStyle.stroke
          ..color = Colors.black);
    canvas.restore();
  }

  ///cubicTo和relativeCubicTo: 三阶贝塞尔
  void _drawPathCubicTo(Canvas canvas) {
    canvas.save();
    canvas.translate(0, -160);
    Path path = Path();
    Offset p1 = Offset(40, -80);
    Offset p2 = Offset(40, 80);
    Offset p3 = Offset(120, 80);
    path.cubicTo(p1.dx, p1.dy, p2.dx, p2.dy, p3.dx, p3.dy);
    path.relativeCubicTo(p1.dx, p1.dy, p2.dx, p2.dy, p3.dx, p3.dy);
    canvas.drawPath(
        path,
        _paint
          ..style = PaintingStyle.stroke
          ..color = Colors.purple);
    canvas.restore();
  }

  ///addRect和addRRect: 添加类矩形
  //addRect用于在已有路径上添加矩形路径，接受一个Rect对象。
  // addRRect用于在已有路径上添加圆角矩形路径，接受一个RRect对象。
  void _drawPathAddRect(Canvas canvas) {
    canvas.save();
    canvas.translate(0, 100);
    Path path = Path();
    path
      ..lineTo(20, 20)
      ..addRect(Rect.fromCenter(center: Offset(30, 30), width: 20, height: 20))
      ..relativeLineTo(20, -20)
      ..addRRect(RRect.fromRectXY(Rect.fromCircle(center: Offset(50, -10), radius: 10), 10, 10));
    canvas.drawPath(
        path,
        _paint
          ..style = PaintingStyle.stroke
          ..color = Colors.red);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
