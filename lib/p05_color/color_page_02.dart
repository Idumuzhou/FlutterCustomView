
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_custom_view/utils/image_utils.dart';
import 'package:flutter_custom_view/utils/screen_utils.dart';
import 'package:flutter_custom_view/widgets/coordinate.dart';
import 'dart:ui' as ui;

import 'package:image/image.dart' as image;

/// create by LXL
/// description: Color 上篇
/// date: 2021/02/01 09:56

class ColorPage02 extends StatefulWidget {
  @override
  _ColorPage02State createState() => _ColorPage02State();
}

class _ColorPage02State extends State<ColorPage02> {
  ui.Image _image;
  @override
  void initState() {
    super.initState();
    ScreenUtils.setScreenHorizontal();
    _loadImage();
  }

  void _loadImage() async {
    _image = await ImageUtils.loadUiImageFromAssets('assets/images/wy_200x300.jpg');
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

/// [1]. 了解使用画笔着色器实现渐变效果：线性渐变、径向渐变、扫描渐变
/// [2]. 了解画笔 [图片着色器] 的使用。
/// [3]. 了解画笔 [颜色滤色器]、[遮罩滤镜] 的使用。
class PaperPainter extends CustomPainter {
  Paint _paint;
  final ui.Image image;
  var _colors = [
    Color(0xFFF60C0C),
    Color(0xFFF3B913),
    Color(0xFFE7F716),
    Color(0xFF3DF30B),
    Color(0xFF0DF6EF),
    Color(0xFF0829FB),
    Color(0xFFB709F4),
  ];

  PaperPainter(this.image) {
    _paint = Paint()
      ..color = Colors.deepOrange
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    Coordinate.paint(canvas, size);
    //1. 渐变着色器 - 线性渐变
    _drawShaderLinear(canvas);

    // 渐变着色器 - 径向渐变
    _drawShaderRadial(canvas);

    //3. 渐变着色器 - 扫描渐变
    _drawShaderSweep(canvas);

    //图片着色器 ImageShader
    _drawImageShader(canvas);
  }

  ///1. 渐变着色器 - 线性渐变
  //Gradient.linear(
  //     Offset from, //渐变起点
  //     Offset to, //渐变终点
  //     List<Color> colors, //渐变色
  //   [
  //     List<double> colorStops, //每个颜色所处的分率
  //     TileMode tileMode = TileMode.clamp, //模式
  //     Float64List matrix4, //变换矩阵
  //   ])
  void _drawShaderLinear(Canvas canvas) {
    canvas.save();
    List<double> colorStops = [1.0 / 7, 2.0 / 7, 3.0 / 7, 4.0 / 7, 5.0 / 7, 6.0 / 7, 1.0];
    //使用最后的颜色，继续绘制(上) TileMode.clamp
    _paint.shader = ui.Gradient.linear(Offset.zero, Offset(100, 0), _colors, colorStops, TileMode.clamp);
    canvas.drawLine(Offset(0, -140), Offset(200, -140), _paint..strokeWidth = 30);
    _drawTextPainter(canvas, 'TileMode.clamp', Offset(210, -150));

    //重复模式(中)TileMode.repeated
    _paint.shader = ui.Gradient.linear(Offset.zero, Offset(100, 0), _colors, colorStops, TileMode.repeated);
    canvas.drawLine(Offset(0, -100), Offset(200, -100), _paint..strokeWidth = 30);
    _drawTextPainter(canvas, 'TileMode.repeated', Offset(210, -110));

    //镜像模式(下) TileMode.mirror
    _paint.shader = ui.Gradient.linear(
        Offset.zero, Offset(100, 0), _colors, colorStops, TileMode.mirror, Matrix4.rotationZ(pi / 6).storage);
    canvas.drawLine(Offset(0, -60), Offset(200, -60), _paint..strokeWidth = 30);
    _drawTextPainter(canvas, 'TileMode.mirror Matrix4', Offset(210, -70));
    canvas.restore();
  }

  ///2. 渐变着色器 - 径向渐变
  //Gradient.radial(
  //     Offset center, // 中心
  //     double radius, // 半径
  //     List<Color> colors, //颜色
  //   [
  //     List<double> colorStops, //每个颜色所处的分率
  //     TileMode tileMode = TileMode.clamp, //模式
  //     Float64List matrix4,  //变换矩阵
  //     Offset focal, //焦点坐标
  //     double focalRadius = 0.0 //焦点半径
  //   ])
  void _drawShaderRadial(Canvas canvas) {
    canvas.save();
    List<double> colorStops = [1.0 / 7, 2.0 / 7, 3.0 / 7, 4.0 / 7, 5.0 / 7, 6.0 / 7, 1.0];
    _paint.shader = ui.Gradient.radial(Offset(80, 80), 20, _colors, colorStops, TileMode.clamp);
    canvas.drawCircle(Offset(80, 80), 40, _paint);
    _drawTextPainter(canvas, "TileMode.clamp", Offset(40, 130), fontSize: 12);

    _paint.shader = ui.Gradient.radial(Offset(200, 80), 20, _colors, colorStops, TileMode.repeated);
    canvas.drawCircle(Offset(200, 80), 40, _paint);
    _drawTextPainter(canvas, "TileMode.repeated", Offset(160, 130), fontSize: 12);

    _paint.shader = ui.Gradient.radial(
        Offset(320, 80), 20, _colors, colorStops, TileMode.mirror, null, Offset(310, 70), 0);
    canvas.drawCircle(Offset(320, 80), 40, _paint);
    _drawTextPainter(canvas, "TileMode.mirror", Offset(280, 130), fontSize: 12);
    _drawTextPainter(canvas, "焦点偏移", Offset(280, 150), fontSize: 12);
    canvas.restore();
  }

  ///3. 渐变着色器 - 扫描渐变
  //Gradient.sweep(
  //     Offset center, // 中心
  //     List<Color> colors, //颜色
  // [
  //     List<double> colorStops, //每个颜色所处的分率
  //     TileMode tileMode = TileMode.clamp,  //模式
  //     double startAngle = 0.0,//起始角度
  //     double endAngle = math.pi * 2,//终止角度
  //     Float64List matrix4, //变换矩阵
  //   ])
  void _drawShaderSweep(Canvas canvas) {
    canvas.save();
    List<double> colorStops = [1.0 / 7, 2.0 / 7, 3.0 / 7, 4.0 / 7, 5.0 / 7, 6.0 / 7, 1.0];
    _paint.shader = ui.Gradient.sweep(Offset(-320, 80), _colors, colorStops, TileMode.clamp, pi / 2, pi);
    canvas.drawCircle(Offset(-320, 80), 40, _paint);
    _drawTextPainter(canvas, "TileMode.clamp", Offset(-360, 130), fontSize: 12);

    _paint.shader = ui.Gradient.sweep(Offset(-200, 80), _colors, colorStops, TileMode.repeated, pi / 2, pi);
    canvas.drawCircle(Offset(-200, 80), 40, _paint);
    _drawTextPainter(canvas, "TileMode.repeated", Offset(-240, 130), fontSize: 12);

    _paint.shader = ui.Gradient.sweep(Offset(-80, 80), _colors, colorStops, TileMode.mirror, pi / 2, pi);
    canvas.drawCircle(Offset(-80, 80), 40, _paint);
    _drawTextPainter(canvas, "TileMode.mirror", Offset(-120, 130), fontSize: 12);
    canvas.restore();
  }

  ///图片着色器 ImageShader 其余部分查看 image_filter_page.dart
  //ImageShader(
  //     Image image,  //图片
  //     TileMode tmx, //水平方向模式
  //     TileMode tmy, //竖直方向模式
  //     Float64List matrix4  // 变化矩阵
  // )
  void _drawImageShader(Canvas canvas){
    canvas.save();
    _paint.shader = ImageShader(image, TileMode.repeated, TileMode.repeated, Float64List.fromList([
      1, 0, 0, 0,
      0, 1, 0, 0,
      0, 0, 1, 0,
      0, 0, 0, 1,
    ]));
    canvas.drawCircle(Offset(-320, -100), 40, _paint);

    canvas.drawCircle(
        Offset(-200, -100),
        40,
        _paint
          ..strokeWidth = 10
          ..style = PaintingStyle.stroke);

    canvas.drawLine(
        Offset(-100 , -140),
        Offset(-100 , -40),
        _paint
          ..strokeWidth = 30
          ..style = PaintingStyle.stroke);
    canvas.restore();
  }

  ///绘制文字
  void _drawTextPainter(Canvas canvas, String text, Offset offset, {double fontSize = 16}) {
    canvas.save();
    TextPainter textPainter = TextPainter(
        text: TextSpan(
            text: text,
            style: TextStyle(fontSize: fontSize, color: Colors.black, fontWeight: FontWeight.bold)),
        textAlign: ui.TextAlign.center,
        textDirection: TextDirection.ltr);
    textPainter.layout(); // 进行布局
    textPainter.paint(canvas, offset); // 进行绘制
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
