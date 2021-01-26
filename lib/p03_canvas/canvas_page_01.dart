import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_custom_view/utils/screen_utils.dart';

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
  ///2.缩放变换
  Paint _gridPaint; //画笔
  final double step = 20; //小格边长
  final double strokeWidth = .5; //线宽
  final Color color = Colors.grey; //线颜色

  PaperPainter() {
    _gridPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // 画布起点移到屏幕中心
    canvas.translate(size.width / 2, size.height / 2);

    Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    //绘制右下角网格
    _drawGrid(canvas, size);
    _drawPart(canvas, paint);
    _drawDot(canvas, paint);
  }

  ///1.平移变换:
  void _drawPart(Canvas canvas, Paint paint) {
    final Paint paint = Paint();
    paint
      ..color = Colors.blue
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    canvas.drawCircle(Offset(0, 0), 50, paint);

    canvas.drawLine(
        Offset(10, 10),
        Offset(50, 50),
        paint
          ..color = Colors.red
          ..strokeWidth = 5
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke);
  }

  ///2.1 绘制右下角网格
  void _drawBottomRight(Canvas canvas, Size size) {
    //如下代码中，绘制横线时使用的点位是都是 Offset(0, 0), Offset(size.width / 2, 0)
    // 只是在每次画完后，将画布向下移 step 距离，就相当于在纸上画线，你的手位置不变，而是纸在动

    //当使用 canvas.save() 时，当前画布的状态就会被保存
    canvas.save();
    for (int i = 0; i < size.height / 2 / step; i++) {
      canvas.drawLine(Offset(0, 0), Offset(size.width / 2, 0), _gridPaint);
      canvas.translate(0, step);
    }
    //当执行 canvas.restore() 时，画布就会回到上次保存的状态。
    canvas.restore();

    canvas.save();
    for (int i = 0; i < size.width / 2 / step; i++) {
      canvas.drawLine(Offset(0, 0), Offset(0, size.height / 2), _gridPaint);
      canvas.translate(step, 0);
    }
    canvas.restore();
  }

  ///2.1 镜像绘制其它三个位置网格
  void _drawGrid(Canvas canvas, Size size) {
    //如果是相同或者对称的对象，可以通过缩放进行对称变化。
    // 沿x轴镜像，就相当于canvas.scale(1, -1)；
    // 沿y轴镜像，就相当于canvas.scale(-1, 1)；
    // 沿原点镜像，就相当于canvas.scale(-1, -1)；
    _drawBottomRight(canvas, size);

    canvas.save();
    canvas.scale(1, -1); //沿x轴镜像
    _drawBottomRight(canvas, size);
    canvas.restore();

    canvas.save();
    canvas.scale(-1, 1); //沿y轴镜像
    _drawBottomRight(canvas, size);
    canvas.restore();

    canvas.save();
    canvas.scale(-1, -1); //沿原点镜像
    _drawBottomRight(canvas, size);
    canvas.restore();
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


  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
