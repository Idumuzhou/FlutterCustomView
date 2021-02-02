import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_custom_view/utils/image_utils.dart';
import 'package:flutter_custom_view/utils/screen_utils.dart';
import 'dart:ui' as ui;

/// create by LXL
/// description: Color BlendMode(混合模式)
/// date: 2021/02/01 10:48

class ColorBlendModePage extends StatefulWidget {
  @override
  _ColorBlendModePageState createState() => _ColorBlendModePageState();
}

class _ColorBlendModePageState extends State<ColorBlendModePage> {
  ui.Image _image;
  @override
  void initState() {
    super.initState();
    ScreenUtils.setScreenHorizontal();
    _loadImage();
  }

  void _loadImage() async {
    _image = await ImageUtils.loadUiImageFromAssets('assets/images/image_head.png');
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
        painter: PaperPainter(_image),
      ),
    );
  }
}

class PaperPainter extends CustomPainter {
  final ui.Image image;
  static const double step = 20; // 方格边长
  Paint _paint;

  PaperPainter(this.image) {
    _paint = Paint()
      ..color = Color(0xffff0000)
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if(image ==null) return;
    canvas.translate(size.width / 2, size.height / 2);
    canvas.translate(-step * 17, -step * 6);
    Paint dstPaint = Paint();
    BlendMode.values.asMap().forEach((i, value) {
      int line = i ~/ 10;
      int row = i % 10;
      canvas.save();
      canvas.translate(3.7 * step * row, 5.5 * step * line);
      canvas.drawImageRect(image, Rect.fromPoints(Offset.zero, Offset(image.width*1.0,image.height*1.0)),
          Rect.fromCenter(center:Offset.zero, width: 25*2.0,height: 25*2.0), dstPaint);
      _paint
        ..blendMode = value;
      canvas.drawRect(
          Rect.fromPoints(Offset.zero, Offset(20 * 2.0, 20 * 2.0)), _paint);
      _simpleDrawText(
          canvas,value.toString().split(".")[1],
          offset: Offset(-10, 50));
      canvas.restore();
    });
  }

  void _simpleDrawText(Canvas canvas, String str,
      {Offset offset = Offset.zero, Color color = Colors.black}) {
    var builder = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: TextAlign.left,
      fontSize: 11,
      textDirection: TextDirection.ltr,
      maxLines: 1,
    ))
      ..pushStyle(
        ui.TextStyle(color: color, textBaseline: ui.TextBaseline.alphabetic),
      )
      ..addText(str);

    canvas.drawParagraph(
        builder.build()
          ..layout(ui.ParagraphConstraints(width: 11.0 * str.length)),
        offset);
  }

  @override
  bool shouldRepaint(PaperPainter oldDelegate) => image != oldDelegate.image;
}
