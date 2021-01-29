import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_custom_view/utils/screen_utils.dart';
import 'package:flutter_custom_view/widgets/coordinate.dart';

/// create by LXL
/// description: Path 下篇
/// date: 2021/1/28 16:01

class PathPage02 extends StatefulWidget {
  @override
  _PathPage02State createState() => _PathPage02State();
}

class _PathPage02State extends State<PathPage02> with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    ScreenUtils.setScreenHorizontal();
    _animationController = AnimationController(duration: Duration(seconds: 3), vsync: this)..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
    ScreenUtils.setScreenVertical();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomPaint(
        painter: PaperPainter(
          progress: _animationController,
        ),
      ),
    );
  }
}

class PaperPainter extends CustomPainter {
  final Animation<double> progress;

  Paint _paint;

  PaperPainter({this.progress}) : super(repaint: progress) {
    _paint = Paint()
      ..color = Colors.deepOrange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    Coordinate.paint(canvas, size, isPath: true);

    //close、reset、shift
    _drawPathOperate(canvas);

    //contains和getBounds
    _drawPathContainsBounds(canvas);

    //路径变换
    _drawPathTransform(canvas);

    //4. combine: 路径联合
    _drawPathCombine(canvas);

    //路径测量 增加动画
    _drawPathMetrics(canvas);
  }

  ///1.close、reset、shift
  //path#close ：用于将路径尾点和起点，进行路径封闭。
  // path#reset ：用于将路径进行重置，清除路径内容。
  // path#shift ：指定点Offset将路径进行平移，且返回一条新的路径。
  void _drawPathOperate(Canvas canvas) {
    Path path = Path();
    path
      ..lineTo(40, 60)
      ..relativeLineTo(0, -40)
      ..close();
    canvas.drawPath(path, _paint);
    canvas.drawPath(path.shift(Offset(60, 0)), _paint);
    canvas.drawPath(path.shift(Offset(120, 0)), _paint);
  }

  ///2. contains和getBounds
  //Paint#contains可以判断点Offset在不在路径之内(如下图紫色区域)，
  // 这是个非常好用的方法，可以根据这个方法做一些触点判断或简单的碰撞检测。
  // Paint#getBounds可以获取当前路径所在的矩形区域，(如下橙色区域)
  void _drawPathContainsBounds(Canvas canvas) {
    canvas.save();
    Path path = Path();
    path
      ..relativeMoveTo(80, 80)
      ..relativeLineTo(-30, 80)
      ..relativeLineTo(30, -30)
      ..relativeLineTo(30, 30)
      ..close();
    canvas.drawPath(
        path,
        _paint
          ..color = Colors.purple
          ..style = PaintingStyle.fill);

    print('坐标是否在紫色区域-->${path.contains(Offset(25, 25))}');
    print('坐标是否在紫色区域-->${path.contains(Offset(80, 80))}');

    Rect bounds = path.getBounds();
    canvas.drawRect(
        bounds,
        _paint
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = Colors.deepOrange);

    ///认识Path#computeMetrics
    //通过PathMetrics对象可以获得路径长度 length、路径索引 contourIndex 及 isClosed路径是否闭合isClosed。
    PathMetrics pms = path.computeMetrics();
    Tangent t;
    pms.forEach((pm) {
      print(
          "---length:-${pm.length}----contourIndex:-${pm.contourIndex}----contourIndex:-${pm.isClosed}----");
    });

    canvas.restore();
  }

  ///3.Path#transform: 路径变换
  //对于对称性图案，当已经有一部分单体路径，可以根据一个4*4的矩阵对路径进行变换。
  // 可以使用Matrix4对象进行辅助生成矩阵。能很方便进行旋转、平移、缩放、斜切等变换效果。
  void _drawPathTransform(Canvas canvas) {
    canvas.save();
    canvas.translate(260, 100);
    Path path = Path();
    path
      ..relativeMoveTo(0, 0)
      ..relativeLineTo(-20, 80)
      ..relativeLineTo(20, -20)
      ..relativeLineTo(20, 20)
      ..close();
    for (int i = 0; i < 8; i++) {
      canvas.drawPath(
          path.transform(Matrix4.rotationZ(i * pi / 4).storage),
          _paint
            ..color = Colors.black
            ..style = PaintingStyle.fill);
    }
    canvas.restore();
  }

  ///4. combine: 路径联合
  //Path#combine用于结合两个路径，并生成新路径，可用于生成复杂的路径。
  // 一共有如下五种联合方式，效果如下图:
  void _drawPathCombine(Canvas canvas) {
    canvas.save();
    _paint..color = Colors.deepOrange;
    canvas.translate(-340, 60);
    Path path = Path()
      ..relativeMoveTo(0, 0)
      ..relativeLineTo(-20, 80)
      ..relativeLineTo(20, -20)
      ..relativeLineTo(20, 20)
      ..close();
    var pathOval = Path()..addOval(Rect.fromCenter(center: Offset(0, 0), width: 40, height: 40));
    canvas.drawPath(Path.combine(PathOperation.difference, path, pathOval), _paint);

    canvas.translate(60, 0);
    canvas.drawPath(Path.combine(PathOperation.intersect, path, pathOval), _paint);

    canvas.translate(60, 0);
    canvas.drawPath(Path.combine(PathOperation.union, path, pathOval), _paint);

    canvas.translate(60, 0);
    canvas.drawPath(Path.combine(PathOperation.reverseDifference, path, pathOval), _paint);

    canvas.translate(60, 0);
    canvas.drawPath(Path.combine(PathOperation.xor, path, pathOval), _paint);
    canvas.restore();
  }

  ///路径测量获取路径某位置信息
  void _drawPathMetrics(Canvas canvas) {
    canvas.save();

    canvas.translate(-260, -120);
    Path path = Path()
      ..relativeMoveTo(0, 0)
      ..relativeLineTo(-20, 80)
      ..relativeLineTo(20, -20)
      ..relativeLineTo(20, 20)
      ..close();
    path.addOval(Rect.fromCenter(center: Offset.zero, width: 50, height: 50));
    canvas.drawPath(
        path,
        _paint
          ..color = Colors.blueAccent
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke);

    PathMetrics pathMetrics = path.computeMetrics();
    pathMetrics.forEach((pm) {
      Tangent tangent = pm.getTangentForOffset(pm.length * progress.value); //pm.length * 0.5 表示在路径长度50%的点的信息。
      canvas.drawCircle(
          tangent.position,
          3,
          _paint
            ..color = Colors.red
            ..style = PaintingStyle.fill);
      print('---position:-${tangent.position}----angle:-${tangent.angle}----vector:-${tangent.vector}----');
    });
    canvas.restore();
  }

  @override
  bool shouldRepaint(PaperPainter oldDelegate) => oldDelegate.progress != progress;
}
