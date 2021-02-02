import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_custom_view/utils/screen_utils.dart';
import 'package:flutter_custom_view/widgets/coordinate.dart';

/// create by LXL
/// description: Color 上篇
/// date: 2021/02/01 09:55

class ColorPage01 extends StatefulWidget {
  @override
  _ColorPage01State createState() => _ColorPage01State();
}

class _ColorPage01State extends State<ColorPage01> {
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

///[1]. 认识 Dart 中的颜色表示方式。
/// [2]. 了解颜色 [混合模式] 的效果。
/// [3]. 了解如何读取图片中的像素颜色。
class PaperPainter extends CustomPainter {
  Paint _paint;
  static const double step = 20; // 方格边长
  // 颜色列表 256 个元素
  final List<Color> colors = List<Color>.generate(256, (i) => Color.fromARGB(255 - i, 255, 0, 0));

  PaperPainter() {
    _paint = Paint()
      ..color = Colors.deepOrange
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    Coordinate.paint(canvas, size);

    //绘制颜色矩阵
    _drawColorArray(canvas);
  }

  ///绘制颜色阵列
  void _drawColorArray(Canvas canvas) {
    // 遍历列表 绘制矩形色块
    canvas.save();
    canvas.translate(-step * 8.0, -step * 8.0);
    colors.asMap().forEach((i,color){
      int line = (i % 16); // 行
      int row = i ~/ 16; // 列
      var topLeft = Offset(step * line, step * row);
      var rect = Rect.fromPoints(topLeft, topLeft.translate(step, step));
      canvas.drawRect(rect, _paint..color = color);
    });
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
