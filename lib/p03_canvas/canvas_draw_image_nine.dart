import 'package:flutter/material.dart';
import 'package:flutter_custom_view/utils/image_utils.dart';
import 'package:flutter_custom_view/utils/screen_utils.dart';
import 'package:flutter_custom_view/widgets/coordinate.dart';
import 'dart:ui' as ui;

/// create by LXL
/// description: .9 域绘制
/// date: 2021/1/26 15:54

class CanvasDrawImageNinePage extends StatefulWidget {
  @override
  _CanvasDrawImageNinePageState createState() => _CanvasDrawImageNinePageState();
}

class _CanvasDrawImageNinePageState extends State<CanvasDrawImageNinePage> {
  ui.Image _image;

  @override
  void initState() {
    super.initState();
    ScreenUtils.setScreenHorizontal();
    _loadImage();
  }

  void _loadImage() async {
    _image = await ImageUtils.loadUiImageFromAssets('assets/images/right_chat.png');
    setState(() {});
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
        painter: PaperPainter(_image),
      ),
    );
  }
}

class PaperPainter extends CustomPainter {
  final ui.Image image;
  Paint _paint;
  final double strokeWidth = 0.5;
  final Color color = Colors.blue;

  PaperPainter(this.image) {
    _paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    Coordinate.paint(canvas, size);

    //.9 域绘制
    _drawImageNine(canvas);
  }

  ///图片 .9 域绘制:drawImageNine
  void _drawImageNine(Canvas canvas) {
    //center 表示从资源图片image上一块可缩放的矩形域，所以原点是图片的左上角。
    // dst 表示将抠出的图片填充到画布的哪个矩形域中，所以原点是画布原点。
    // 这样很容易画出气泡的效果，即指定区域进行缩放，其余不动。
    if (image != null) {
      canvas.drawImageNine(
          image, Rect.fromCenter(center: Offset(image.width / 2, image.height - 6.0), width:image.width-20.0,height: 2.0),
          Rect.fromCenter(center: Offset(0, 0,), width:300, height: 120), _paint);

      canvas.drawImageNine(
          image,
          Rect.fromCenter(center: Offset(image.width/2, image.height-6.0),
              width: image.width-20.0, height: 2.0),
          Rect.fromCenter(center: Offset(0, 0,), width:100, height: 50).translate(250, 0),
          _paint);

      canvas.drawImageNine(
          image,
          Rect.fromCenter(center: Offset(image.width/2, image.height-6.0),
              width: image.width-20.0, height: 2.0),
          Rect.fromCenter(center: Offset(0, 0,), width:80, height: 250).translate(-250, 0),
          _paint);
    }
  }

  @override
  bool shouldRepaint(PaperPainter oldDelegate) => image != oldDelegate.image;
}
