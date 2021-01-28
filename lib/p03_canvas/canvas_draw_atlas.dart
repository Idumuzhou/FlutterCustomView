import 'package:flutter/material.dart';
import 'package:flutter_custom_view/utils/image_utils.dart';
import 'package:flutter_custom_view/utils/screen_utils.dart';
import 'package:flutter_custom_view/widgets/coordinate.dart';
import 'dart:ui' as ui;

/// create by LXL
/// description: 绘制图集
/// date: 2021/1/26 15:54

class CanvasDrawAtlasPage extends StatefulWidget {
  @override
  _CanvasDrawAtlasPageState createState() => _CanvasDrawAtlasPageState();
}

class _CanvasDrawAtlasPageState extends State<CanvasDrawAtlasPage> {
  ui.Image _image;

  @override
  void initState() {
    super.initState();
    ScreenUtils.setScreenHorizontal();
    _loadImage();
  }

  void _loadImage() async {
    _image = await ImageUtils.loadImageFromAssets('assets/images/shoot.png');
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

    //绘制图集:drawAtlas
    _drawAtlas(canvas);


  }

  ///绘制图集:drawAtlas
  void _drawAtlas(Canvas canvas) {

  }

  @override
  bool shouldRepaint(PaperPainter oldDelegate) => image != oldDelegate.image;
}
