import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_custom_view/utils/screen_utils.dart';
import 'package:flutter_custom_view/widgets/coordinate.dart';
import 'dart:ui' as ui;

/// create by LXL
/// description: 绘制文字
/// date: 2021/1/26 15:54

class CanvasDrawTextPage extends StatefulWidget {
  @override
  _CanvasDrawTextPageState createState() => _CanvasDrawTextPageState();
}

class _CanvasDrawTextPageState extends State<CanvasDrawTextPage> {
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

class PaperPainter extends CustomPainter {
  Paint _paint;
  final double strokeWidth = 0.5;
  final Color color = Colors.blue;

  PaperPainter() {
    _paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    Coordinate.paint(canvas, size);

    //drawParagraph绘制文字
    _drawParagraph(canvas, TextAlign.center);

    canvas.save();
    canvas.translate(0, -80);
    _drawParagraph(canvas, TextAlign.left);
    canvas.restore();

    canvas.save();
    canvas.translate(0, 80);
    _drawParagraph(canvas, TextAlign.right);
    canvas.restore();

    //TextPainter 绘制文字
    _drawTextPainter(canvas);

    //获取文字范围
    _drawTextPaintShowSize(canvas);

    //绘制文字样式
    _drawTextPaintWithPaint(canvas);
  }

  /*
  * 主要的绘制方式是通过 drawParagraph 或 TextPaint。
  */

  ///1.drawParagraph绘制文字
  void _drawParagraph(Canvas canvas, TextAlign textAlign) {
    var builder = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: textAlign,
      fontSize: 40,
      textDirection: TextDirection.ltr,
      maxLines: 1,
    ));

    builder.pushStyle(
      ui.TextStyle(color: Colors.deepOrangeAccent, textBaseline: TextBaseline.alphabetic),
    );

    builder.addText('Dawn Flutter');
    ui.Paragraph paragraph = builder.build();
    paragraph.layout(ui.ParagraphConstraints(width: 300));
    canvas.drawParagraph(paragraph, Offset(0, 0));
    canvas.drawRect(Rect.fromLTRB(0, 0, 300, 40), _paint..color = Colors.orangeAccent.withOpacity(0.2));
  }

  ///2. TextPainter 绘制文字
  //TextPainter的绘制基本上就是对drawParagraph的封装，提供了更多的方法，使用起来简洁一些。
  // 所以一般来说都是使用 TextPainter 进行文字绘制。
  // 绘制先设置 TextPainter，然后执行 layout() 方法进行布局，其中可以传入布局区域的最大和最小宽度。
  // 通过 paint 方法进行绘制。
  void _drawTextPainter(Canvas canvas) {
    canvas.save();
    canvas.translate(-360, -160);
    //canvas.rotate(pi/10);
    TextPainter textPainter = TextPainter(
        text: TextSpan(text: 'Dawn Flutter', style: TextStyle(fontSize: 40, color: Colors.blue)),
        textAlign: ui.TextAlign.center,
        textDirection: TextDirection.ltr);
    textPainter.layout(); // 进行布局
    textPainter.paint(canvas, Offset.zero); // 进行绘制
    canvas.restore();
  }

  ///TextPainter 获取文字范围
  //TextPainter 中可以通过 size 属性获取文字所占区域，注意，获取区域必须在执行 layout 方法之后。
  // 一但确定范围后，就容易实现将文字中心绘制在画布原点，这一个效果是非常重要的。
  void _drawTextPaintShowSize(Canvas canvas) {
    canvas.save();
    canvas.translate(-360, -80);
    TextPainter textPainter = TextPainter(
        text: TextSpan(text: 'Dawn Flutter', style: TextStyle(fontSize: 40, color: Colors.black)),
        textAlign: ui.TextAlign.center,
        textDirection: TextDirection.ltr);
    textPainter.layout(); // 进行布局
    Size size = textPainter.size;
    textPainter.paint(canvas, Offset.zero); // 进行绘制

    canvas.drawRect(Rect.fromLTRB(0, 0, size.width, size.height), _paint..color = Colors.black12);
    canvas.restore();
  }

  ///为文字设置画笔样式
  //比如设置线型的文字，或为文字添加画笔着色器等。
  // 可以使用 TextStyle 中的 foreground 属性提供一个画笔。注意:此属性和 TextStyle#color 属性互斥。
  void _drawTextPaintWithPaint(Canvas canvas) {
    canvas.save();
    canvas.translate(-360, 20);
    TextPainter textPainter = TextPainter(
        text: TextSpan(
            text: 'Dawn Flutter',
            style: TextStyle(
                fontSize: 40,
                foreground: _paint
                  ..color = Colors.deepOrangeAccent
                  ..strokeWidth = 2
                  ..style = PaintingStyle.stroke)),
        textAlign: ui.TextAlign.center,
        textDirection: TextDirection.ltr);
    textPainter.layout(); // 进行布局
    Size size = textPainter.size;
    textPainter.paint(canvas, Offset.zero); // 进行绘制

    canvas.drawRect(Rect.fromLTRB(0, 0, size.width, size.height), _paint..color = Colors.black12..style = PaintingStyle.fill);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
