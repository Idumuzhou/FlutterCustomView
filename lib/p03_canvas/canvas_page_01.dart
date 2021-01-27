import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_custom_view/utils/screen_utils.dart';
import 'package:flutter_custom_view/widgets/coordinate.dart';

/// create by LXL
/// description: Canvas 上篇 画布绘制基础
/// date: 2021/1/26 15:54

class CanvasPage01 extends StatefulWidget {
  @override
  _CanvasPage01State createState() => _CanvasPage01State();
}

class _CanvasPage01State extends State<CanvasPage01> {
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
        //使用CustomPainter
        painter: PaperPainter(),
      ),
    );
  }
}

class PaperPainter extends CustomPainter {
  Paint _paint = Paint();
  
  @override
  void paint(Canvas canvas, Size size) {
    // 画布起点移到屏幕中心
    canvas.translate(size.width / 2, size.height / 2);
    Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    Coordinate.paint(canvas, size);
    _drawPart(canvas, paint,size);
    _drawDot(canvas, paint);

    //绘制点
    _drawPointsWithPoints(canvas);
    _drawPointsWithRawPoints(canvas);

    //绘制矩形
    _drawRect(canvas);

    //绘制圆角矩形
    _drawRRect(canvas);

    //绘制两个圆角矩形差域
    _drawDRRect(canvas);

    //绘制圆
    _drawFill(canvas);

    //绘制阴影
    _drawShadow(canvas);

  }

  ///1.平移变换:
  void _drawPart(Canvas canvas, Paint paint,Size size) {
    final Paint paint = Paint();
    paint
      ..color = Colors.blue
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    canvas.drawCircle(Offset(0, 0), 50, paint);

    //绘制颜色 drawColor
    //canvas.drawColor(Colors.blue, BlendMode.lighten);

    //绘制画笔drawPaint
    /*var colors = [
      Color(0xFFF60C0C),
      Color(0xFFF3B913),
      Color(0xFFE7F716),
      Color(0xFF3DF30B),
      Color(0xFF0DF6EF),
      Color(0xFF0829FB),
      Color(0xFFB709F4),
    ];
    var pos = [1.0 / 7, 2.0 / 7, 3.0 / 7, 4.0 / 7, 5.0 / 7, 6.0 / 7, 1.0];
    paint.shader =ui.Gradient.linear(
        Offset(0, 0), Offset(size.width, 0),
        colors, pos, TileMode.clamp);
    paint.blendMode=BlendMode.lighten;
    canvas.drawPaint(paint);*/

    canvas.drawLine(
        Offset(10, 10),
        Offset(50, 50),
        paint
          ..color = Colors.red
          ..strokeWidth = 5
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke);
  }


  ///3 旋转变换
  void _drawDot(Canvas canvas, Paint paint) {
    final int count = 12;
    paint
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    canvas.save();
    for (int i = 0; i < count; i++) {
      var step = 2 * pi / count;
      canvas.drawLine(Offset(80, 0), Offset(100, 0), paint);
      canvas.rotate(step);
    }
    canvas.restore();
  }

  ///4.点绘制 drawPoints、drawRawPoints
  ///4.1 绘制点: drawPoints
  void _drawPointsWithPoints(Canvas canvas) {
    final List<Offset> points = [
      Offset(-140, 0),
      Offset(-280, 0),
      Offset(-260, -20),
      Offset(-200, -60),
      Offset(-160, 120),
      Offset(-100, 160),
    ];
    //PointMode.points : 点模式
    //点模式下就是将 Offset 列表的每个点依次绘出。
    canvas.drawPoints(
        PointMode.points,
        points,
        _paint
          ..color = Colors.red
          ..strokeWidth = 10
          ..strokeCap = StrokeCap.round);

    //PointMode.lines : 线段模式
    //线段模式下：每两个点一对形成线段。如果点是奇数个，那么最后一个点将没有用。
    canvas.drawPoints(
        PointMode.lines,
        points,
        _paint
          ..color = Colors.deepOrangeAccent.withOpacity(.5)
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round);

    //PointMode.polygon : 多边形连线模式
    //多边形连线模式下：所有的点依次连接成图形。
    canvas.drawPoints(
        PointMode.polygon,
        points,
        _paint
          ..color = Colors.green
          ..strokeWidth = 1
          ..strokeCap = StrokeCap.round);
  }

  ///4.2 绘点集: drawRawPoints
  void _drawPointsWithRawPoints(Canvas canvas) {
    final Float32List float32list = Float32List.fromList([-340, 120, -300, 80, -280, 160]);
    canvas.drawRawPoints(
        PointMode.points,
        float32list,
        _paint
          ..color = Colors.black
          ..strokeWidth = 10
          ..strokeCap = StrokeCap.round);
  }

  ///3.类矩形绘制:drawRect、drawRRect、drawDRRect
  ///3.1
  void _drawRect(Canvas canvas) {
    //【1】.矩形中心构造
    Rect rectFromCenter = Rect.fromCenter(center: Offset(-300, -100), width: 40, height: 40);
    canvas.drawRect(
        rectFromCenter,
        _paint
          ..color = Colors.cyan
          ..style = PaintingStyle.fill);

    //【2】.矩形左上右下构造
    Rect rectFromLTRB = Rect.fromLTRB(-280, -80, -260, -60);
    canvas.drawRect(
        rectFromLTRB,
        _paint
          ..color = Colors.yellow
          ..style = PaintingStyle.fill);

    //【3】. 矩形左上宽高构造
    Rect rectFromLTWH = Rect.fromLTWH(-320, -120, -30, -30);
    canvas.drawRect(
        rectFromLTWH,
        _paint
          ..color = Colors.deepOrange
          ..style = PaintingStyle.fill);

    //【4】. 矩形内切圆构造
    Rect rectFromCircle = Rect.fromCircle(center: Offset(-260, -140), radius: 20);
    canvas.drawRect(
        rectFromCircle,
        _paint
          ..color = Colors.brown
          ..style = PaintingStyle.fill);

    //【5】. 矩形两点构造
    Rect rectFromPoints = Rect.fromPoints(Offset(-320, -80), Offset(-340, -60));
    canvas.drawRect(
        rectFromPoints,
        _paint
          ..color = Colors.blueAccent
          ..style = PaintingStyle.fill);
  }

  ///【2】 绘制圆角矩形 drawRRect
  // 圆角矩形可以通过一个矩形域 Rect 和一个圆角对象 Radius 构成
  // 6 个构造方法因地制宜，圆角是一个四分之一椭圆，其中 x,y 表示两个半轴，控制椭圆的宽扁。四个边角的圆角样式可以独立设置。
  void _drawRRect(Canvas canvas) {
    //【1】.圆角矩形fromRectXY构造
    Rect rectFromCenter = Rect.fromCenter(center: Offset(240, -80), width: 80, height: 80);
    canvas.drawRRect(
        RRect.fromRectXY(rectFromCenter, 20, 10),
        _paint
          ..color = Colors.cyan
          ..style = PaintingStyle.fill);

    //【2】.圆角矩形fromLTRBXY构造
    canvas.save();
    canvas.drawRRect(
        RRect.fromLTRBXY(160, -160, 200, -120, 10, 10),
        _paint
          ..color = Colors.yellow
          ..style = PaintingStyle.fill);
    canvas.restore();

    //【3】. 圆角矩形fromLTRBR构造
    canvas.drawRRect(
        RRect.fromLTRBR(280, -160, 320, -120, Radius.circular(20)),
        _paint
          ..color = Colors.deepOrange
          ..style = PaintingStyle.fill);

    //【4】. 圆角矩形fromLTRBAndCorners构造 可单独控制圆角弧度
    canvas.drawRRect(
        RRect.fromLTRBAndCorners(160, -60, 200, -20, bottomRight: Radius.circular(10)),
        _paint
          ..color = Colors.brown
          ..style = PaintingStyle.fill);

    //【5】. 矩形两点构造
    Rect rectFromPoints = Rect.fromPoints(Offset(280, -40), Offset(320, 0));
    canvas.drawRRect(
        RRect.fromRectAndCorners(rectFromPoints, topRight: Radius.elliptical(10, 10)),
        _paint
          ..color = Colors.blueAccent
          ..style = PaintingStyle.fill);
  }

  ///【3】 绘制两个圆角矩形差域 drawDRRect
  void _drawDRRect(Canvas canvas) {
    canvas.drawDRRect(
        RRect.fromRectXY(Rect.fromCenter(center: Offset(160, 100), width: 100, height: 100), 20, 20),
        RRect.fromRectXY(Rect.fromCenter(center: Offset(160, 100), width: 80, height: 80), 20, 20),
        _paint
          ..color = Colors.blueAccent
          ..style = PaintingStyle.fill);

    canvas.drawDRRect(
        RRect.fromRectXY(Rect.fromCenter(center: Offset(160, 100), width: 60, height: 60), 20, 20),
        RRect.fromRectXY(Rect.fromCenter(center: Offset(160, 100), width: 40, height: 40), 20, 20),
        _paint
          ..color = Colors.green
          ..style = PaintingStyle.fill);
  }

  ///4. 绘制类圆 drawCircle,drawOval,drawArc
  void _drawFill(Canvas canvas) {
    //圆
    canvas.drawCircle(
        Offset(260, 40),
        20,
        _paint
          ..color = Colors.purple
          ..style = PaintingStyle.fill);
    //椭圆
    canvas.drawOval(
        Rect.fromCenter(center: Offset(300, 80), width: 80, height: 40),
        _paint
          ..color = Colors.redAccent
          ..style = PaintingStyle.fill);

    //圆弧
    //drawArc(矩形区域,起始弧度,扫描弧度,是否连中心,画笔)
    canvas.drawArc(
        Rect.fromCenter(center: Offset(340, 40), width: 80, height: 40),
        0,
        pi / 2 * 3,
        true,
        _paint
          ..color = Colors.tealAccent
          ..style = PaintingStyle.fill);

    ///吃豆豆
    canvas.save();
    _paint
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;
    var a = pi / 8;
    canvas.drawArc(
        Rect.fromCenter(center: Offset(-140, -100), width: 80, height: 80),
        a,
        2 * pi - a.abs() * 2,
        true,
        _paint);
    canvas.drawCircle(Offset(-110, -100), 5, _paint);
    canvas.drawCircle(Offset(-90, -100), 5, _paint);
    canvas.restore();
  }

  ///绘制阴影drawShadow
  void _drawShadow(Canvas canvas){
    canvas.save();
    canvas.translate(240, 120);
    Path path = Path();
    path.lineTo(-40, 40);
    path.lineTo(40, 40);
    path.lineTo(-40, -40);
    path.lineTo(40, -40);
    path.close();
    //路径 path 、颜色 color、影深 elevation 和 内部是否显示 transparentOccluder
    canvas.drawShadow(path, Colors.deepPurple, 3, true);
    canvas.drawPath(path, _paint..color = Colors.deepOrangeAccent.withOpacity(.5));
    canvas.restore();

    canvas.save();
    canvas.translate(340, 120);
    //路径 path 、颜色 color、影深 elevation 和 内部是否显示 transparentOccluder
    canvas.drawShadow(path, Colors.deepPurple, 3, false);
    canvas.drawPath(path, _paint..color = Colors.transparent);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
