import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// create by LXL
/// description: 坐标系
/// date: 2021/1/27 14:57
class Coordinate {
  ///2.缩放变换
  static Paint _gridPaint; //画笔
  static final double step = 20; //小格边长
  static final double strokeWidth = .5; //线宽
  static final Color color = Colors.grey; //线颜色

  ///通过path绘制网格
  static Path _gridPath = Path();

  // 定义成员变量
  static final TextPainter _textPainter = TextPainter(textDirection: TextDirection.ltr);

  static void paint(Canvas canvas, Size size, {bool isPath = false, bool isShowText = true}) {
    _gridPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    //绘制网格方式 1.通过平移画布,2.通过path绘制
    if (!isPath) {
      drawGrid(canvas, size);
    } else {
      drawPathGridLine(canvas, size);
    }

    //绘制X轴 Y轴
    drawAxis(canvas, size);
    //绘制刻度值
    if (isShowText) {
      drawAxisScale(canvas, size);
    }
  }

  ///2.1 绘制右下角网格
  static void drawBottomRight(Canvas canvas, Size size) {
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
  static void drawGrid(Canvas canvas, Size size) {
    //如果是相同或者对称的对象，可以通过缩放进行对称变化。
    // 沿x轴镜像，就相当于canvas.scale(1, -1)；
    // 沿y轴镜像，就相当于canvas.scale(-1, 1)；
    // 沿原点镜像，就相当于canvas.scale(-1, -1)；
    drawBottomRight(canvas, size);

    canvas.save();
    canvas.scale(1, -1); //沿x轴镜像
    drawBottomRight(canvas, size);
    canvas.restore();

    canvas.save();
    canvas.scale(-1, 1); //沿y轴镜像
    drawBottomRight(canvas, size);
    canvas.restore();

    canvas.save();
    canvas.scale(-1, -1); //沿原点镜像
    drawBottomRight(canvas, size);
    canvas.restore();
  }

  ///绘制线 : drawLine  X轴 Y轴
  ///指定两点绘制一条线，如下的两个蓝色坐标轴由六条线构成(包括两个尖角的线)。
  static void drawAxis(Canvas canvas, Size size) {
    _gridPaint
      ..color = Colors.blue
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(-size.width / 2, 0), Offset(size.width / 2, 0), _gridPaint);
    canvas.drawLine(Offset(0, -size.height / 2), Offset(0, size.height / 2), _gridPaint);
    canvas.drawLine(Offset(0, size.height / 2), Offset(0 - 7.0, size.height / 2 - 10), _gridPaint);
    canvas.drawLine(Offset(0, size.height / 2), Offset(0 + 7.0, size.height / 2 - 10), _gridPaint);
    canvas.drawLine(Offset(size.width / 2, 0), Offset(size.width / 2 - 10, 7), _gridPaint);
    canvas.drawLine(Offset(size.width / 2, 0), Offset(size.width / 2 - 10, -7), _gridPaint);
  }

  ///绘制轴刻度
  static void drawAxisScale(Canvas canvas, Size size) {
    // y > 0 轴 文字
    canvas.save();
    for (int i = 0; i < size.height / 2 / step; i++) {
      if (step < 30 && i.isOdd || i == 0) {
        canvas.translate(0, step);
        continue;
      } else {
        var str = (i * step).toInt().toString();
        drawAxisText(canvas, str, color: Colors.green);
      }
      canvas.translate(0, step);
    }
    canvas.restore();
    // x > 0 轴 文字
    canvas.save();
    for (int i = 0; i < size.width / 2 / step; i++) {
      if (i == 0) {
        drawAxisText(canvas, "O", color: Colors.black, x: null);
        canvas.translate(step, 0);
        continue;
      }
      if (step < 30 && i.isOdd) {
        canvas.translate(step, 0);
        continue;
      } else {
        var str = (i * step).toInt().toString();
        drawAxisText(canvas, str, color: Colors.green, x: true);
      }
      canvas.translate(step, 0);
    }
    canvas.restore();
    // y < 0 轴 文字
    canvas.save();
    for (int i = 0; i < size.height / 2 / step; i++) {
      if (step < 30 && i.isOdd || i == 0) {
        canvas.translate(0, -step);
        continue;
      } else {
        var str = (-i * step).toInt().toString();
        drawAxisText(canvas, str, color: Colors.green);
      }
      canvas.translate(0, -step);
    }
    canvas.restore();
    // x < 0 轴 文字
    canvas.save();
    for (int i = 0; i < size.width / 2 / step; i++) {
      if (step < 30 && i.isOdd || i == 0) {
        canvas.translate(-step, 0);
        continue;
      } else {
        var str = (-i * step).toInt().toString();
        drawAxisText(canvas, str, color: Colors.green, x: true);
      }
      canvas.translate(-step, 0);
    }
    canvas.restore();
  }

  static void drawAxisText(Canvas canvas, String str, {Color color = Colors.black, bool x = false}) {
    TextSpan text = TextSpan(text: str, style: TextStyle(fontSize: 11, color: color));
    _textPainter.text = text;
    _textPainter.layout(); // 进行布局

    Size size = _textPainter.size;
    Offset offset = Offset.zero;
    if (x == null) {
      offset = Offset(8, 8);
    } else if (x) {
      offset = Offset(-size.width / 2, size.height / 2);
    } else {
      offset = Offset(size.height / 2, -size.height / 2 + 2);
    }
    _textPainter.paint(canvas, offset);
  }

  ///通过Path绘制网格
  static void drawPathGridLine(Canvas canvas, Size size) {
    for (int i = 0; i < size.width / 2 / step; i++) {
      _gridPath.moveTo(step * i, -size.height / 2);
      _gridPath.relativeLineTo(0, size.height);
      _gridPath.moveTo(-step * i, -size.height / 2);
      _gridPath.relativeLineTo(0, size.height);
    }

    for (int i = 0; i < size.height / 2 / step; i++) {
      _gridPath.moveTo(-size.width / 2, step * i);
      _gridPath.relativeLineTo(size.width, 0);
      _gridPath.moveTo(
        -size.width / 2,
        -step * i,
      );
      _gridPath.relativeLineTo(size.width, 0);
    }
    canvas.drawPath(_gridPath, _gridPaint);
  }
}
