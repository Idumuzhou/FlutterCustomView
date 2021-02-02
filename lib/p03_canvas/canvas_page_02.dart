import 'package:flutter/material.dart';
import 'package:flutter_custom_view/utils/image_utils.dart';
import 'package:flutter_custom_view/utils/screen_utils.dart';
import 'package:flutter_custom_view/widgets/coordinate.dart';
import 'dart:ui' as ui;

/// create by LXL
/// description: Canvas 下篇 画布绘制图片字
/// date: 2021/1/26 15:54

class CanvasPage02 extends StatefulWidget {
  @override
  _CanvasPage02State createState() => _CanvasPage02State();
}

class _CanvasPage02State extends State<CanvasPage02> {
  ui.Image _image;

  @override
  void initState() {
    super.initState();
    ScreenUtils.setScreenHorizontal();
    _loadImage();
  }

  void _loadImage() async {
    _image = await ImageUtils.loadUiImageFromAssets('assets/images/wy_300x200.jpg');
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

    //图片绘制
    _drawImage(canvas);

    //图片域绘制
    _drawImageRect(canvas);

    //.9 域绘制
    _drawImageNine(canvas);
  }

  ///图片的绘制:drawImage
  void _drawImage(Canvas canvas) {
    if (image != null) {
      canvas.drawImage(image, Offset(-image.width / 2, -image.height / 2), _paint);
    }
  }

  ///图片域绘制:drawImageRect
  void _drawImageRect(Canvas canvas) {
    // src 表示从资源图片 image 上抠出一块矩形域，所以原点是图片的左上角。
    // dst 表示将抠出的图片填充到画布的哪个矩形域中，所以原点是画布原点。
    if (image != null) {
      canvas.drawImageRect(
          image,
          Rect.fromCenter(center: Offset(image.width / 2, image.height / 2), width: 60, height: 60),
          Rect.fromLTRB(0, 0, 100, 100).translate(200, 0),
          _paint);

      canvas.drawImageRect(
          image,
          Rect.fromCenter(
              center: Offset(image.width/2, image.height/2-60), width: 60, height: 60),
          Rect.fromLTRB(0, 0, 100, 100).translate(-280, -100),
          _paint);

      canvas.drawImageRect(
          image,
          Rect.fromCenter(
              center: Offset(image.width/2+60, image.height/2), width: 60, height: 60),
          Rect.fromLTRB(0, 0, 100, 100).translate(-280, 50),
          _paint);
    }
  }

  ///图片 .9 域绘制:drawImageNine
  void _drawImageNine(Canvas canvas){

  }



  @override
  bool shouldRepaint(PaperPainter oldDelegate) => image != oldDelegate.image;
}
