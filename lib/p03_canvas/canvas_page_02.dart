import 'package:flutter/material.dart';
import 'package:flutter_custom_view/utils/screen_utils.dart';
import 'package:flutter_custom_view/widgets/coordinate.dart';

/// create by LXL
/// description: Canvas 下篇 画布绘制图片字
/// date: 2021/1/26 15:54

class CanvasPage02 extends StatefulWidget {
  @override
  _CanvasPage02State createState() => _CanvasPage02State();
}

class _CanvasPage02State extends State<CanvasPage02> {
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

class PaperPainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width/2, size.height/2);
    Coordinate.paint(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

}
