import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_custom_view/utils/screen_utils.dart';
import 'package:flutter_custom_view/widgets/coordinate.dart';
import 'dart:ui' as ui;

/// create by LXL
/// description: 图片着色器 ImageShader
/// date: 2021/2/2 16:28

class ImageFilterPage extends StatefulWidget {
  @override
  _ImageFilterPageState createState() => _ImageFilterPageState();
}

class _ImageFilterPageState extends State<ImageFilterPage> {
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

/// [1]. 了解使用画笔着色器实现渐变效果：线性渐变、径向渐变、扫描渐变
/// [2]. 了解画笔 [图片着色器] 的使用。
/// [3]. 了解画笔 [颜色滤色器]、[遮罩滤镜] 的使用。
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