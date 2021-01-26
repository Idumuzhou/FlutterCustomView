import 'package:flutter/material.dart';
import 'package:flutter_custom_view/utils/screen_utils.dart';

/// create by DuMuZhou on
/// description: 画笔基础属性,线性属性,着色器效果,过滤器效果
/// date: 2020/11/11 11:40

class Paper02 extends StatefulWidget {
  @override
  _Paper02State createState() => _Paper02State();
}

class _Paper02State extends State<Paper02> {
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
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();

    ///Paint 基础属性
    paint
          ..isAntiAlias = true //是否抗锯齿 默认true
          ..color = Colors.blue //画笔颜色 默认值 Color(0xff000000)
          ..style = PaintingStyle.fill //画笔类型 默认值 PaintingStyle.fill 填充
          ..strokeWidth = 10 //边框宽度 默认值0.0
        ;
    canvas.drawCircle(Offset(100, 100), 50, paint);

    canvas.drawCircle(
        Offset(220, 100),
        50,
        paint
          ..isAntiAlias = false
          ..color = Colors.red
          ..style = PaintingStyle.stroke //线条
          ..strokeWidth = 10);

    ///线帽属性 StrokeCap
    ///StrokeCap.butt - 不出头
    /// StrokeCap.round - 圆头
    /// StrokeCap.square - 方头
    Paint paintCap = Paint();
    paintCap
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20.0;
    canvas.drawLine(Offset(350, 50), Offset(350, 200), paintCap..strokeCap = StrokeCap.butt); //不出头
    canvas.drawLine(Offset(400, 50), Offset(400, 200), paintCap..strokeCap = StrokeCap.round); //圆头
    canvas.drawLine(Offset(450, 50), Offset(450, 200), paintCap..strokeCap = StrokeCap.square); //方头
    canvas.drawLine(
        Offset(300, 50),
        Offset(500, 50),
        paintCap
          ..color = Colors.cyan
          ..strokeWidth = 1);
    canvas.drawLine(
        Offset(300, 200),
        Offset(500, 200),
        paintCap
          ..color = Colors.cyan
          ..strokeWidth = 1);

    ///线接类型StrokeJoin
    ///线接类型只适用于Path的线段绘制。它不适用于用【Canvas.drawPoints】绘制的线。
    ///StrokeJoin.bevel - 斜角、
    /// StrokeJoin.miter - 锐角、
    /// StrokeJoin.round - 圆角
    Paint paintJoin = Paint();
    paintJoin
      ..color = Colors.purple
      ..isAntiAlias = true
      ..strokeWidth = 20
      ..style = PaintingStyle.stroke;
    Path pathJoin = Path();

    pathJoin.moveTo(50, 200);
    pathJoin.lineTo(50, 300);
    pathJoin.relativeLineTo(100, -50);
    pathJoin.relativeLineTo(0, 100);
    canvas.drawPath(pathJoin, paintJoin..strokeJoin = StrokeJoin.bevel);

    pathJoin.reset(); //清除所有子路径的Path对象，使其恢复到创建时的状态。 当前点将重置为原点
    pathJoin.moveTo(200, 200);
    pathJoin.lineTo(200, 300);
    pathJoin.relativeLineTo(100, -50);
    pathJoin.relativeLineTo(0, 100);
    canvas.drawPath(pathJoin, paintJoin..strokeJoin = StrokeJoin.miter);

    pathJoin.reset();
    pathJoin.moveTo(350, 210);
    pathJoin.lineTo(350, 300);
    pathJoin.relativeLineTo(100, -50);
    pathJoin.relativeLineTo(0, 100);
    canvas.drawPath(pathJoin, paintJoin..strokeJoin = StrokeJoin.round);

    ///斜接限制strokeMiterLimit  strokeMiterLimit只适用于【StrokeJoin.miter】。
    ///它是一个对斜接的限定，如果超过阈值，会变成【StrokeJoin.bevel】。
    pathJoin.reset();
    pathJoin.moveTo(480, 210);
    pathJoin.lineTo(480, 300);
    pathJoin.relativeLineTo(100, -50);
    pathJoin.relativeLineTo(0, 100);
    canvas.drawPath(
        pathJoin,
        paintJoin
          ..strokeJoin = StrokeJoin.miter
          ..strokeMiterLimit = 2
          ..color = Colors.lightBlueAccent
          ..invertColors = true);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
