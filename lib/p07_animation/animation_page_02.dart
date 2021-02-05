import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_custom_view/utils/screen_utils.dart';
import 'package:flutter_custom_view/widgets/coordinate.dart';

/// create by LXL
/// description: 动画器曲线和方法
/// date: 2021/2/3 14:32

class AnimationPage02 extends StatefulWidget {
  @override
  _AnimationPage02State createState() => _AnimationPage02State();
}

class _AnimationPage02State extends State<AnimationPage02> {
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

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}