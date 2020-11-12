import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;


class Paper extends StatefulWidget {
  @override
  _PaperState createState() => _PaperState();
}

class _PaperState extends State<Paper> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )
      ..repeat()
    // ..repeat(reverse: true)
    // ..forward()
        ;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomPaint(
        // 使用CustomPaint
        painter: PaperPainter(_controller),
      ),
    );
  }
}

class PaperPainter extends CustomPainter {
  // final Coordinate coordinate = Coordinate();

  final Animation<double> repaint;

  PaperPainter(this.repaint) : super(repaint: repaint) {
    initPointsWithPolar();
  }

  final List<Offset> points = [];

  final double step = 6;
  final double min = -240;
  final double max = 240;

  void initPoints() {
    for (double x = min; x < max; x += step) {
      points.add(Offset(x, f(x)));
    }
    points.add(Offset(max, f(max)));
    points.add(Offset(max, f(max)));
  }

  void initPointsWithPolar() {
    for (double x = min; x < max; x += step) {
      double thta = (pi / 180 * x); // 角度转化为弧度
      var p = f(thta);
      points.add(Offset(p * cos(thta), p * sin(thta)));
    }
  }

  // double f(double x) {
  //   double y = -x * x / 200 + 100;
  //   return y;
  // }

  // double f(double thta) {
  //   double p = 10 * thta;
  //   return p;
  // }

  // double f(double thta) {
  //   double p = 100 * (1-cos(thta));
  //   return p;
  // }

  // double f(double thta) {
  //   double p = 150*sin(5*thta).abs();
  //   return p;
  // }

  double f(double thta) {
    double p =
        50 * (pow(e, cos(thta)) - 2 * cos(4 * thta) + pow(sin(thta / 12), 5));
    return p;
  }

  Path path = Path();

  @override
  void paint(Canvas canvas, Size size) {
    // coordinate.paint(canvas, size);
    canvas.translate(size.width / 2, size.height / 2);
    // initPoints();

    Paint paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    var colors = [
      Color(0xFFF60C0C),
      Color(0xFFF3B913),
      Color(0xFFE7F716),
      Color(0xFF3DF30B),
      Color(0xFF0DF6EF),
      Color(0xFF0829FB),
      Color(0xFFB709F4),
    ];
    var pos = [1.0 / 7, 2.0 / 7, 3.0 / 7, 4.0 / 7, 5.0 / 7, 6.0 / 7, 1.0];

    paint.shader = ui.Gradient.linear(
        Offset(0, 0), Offset(100, 0), colors, pos, TileMode.mirror);

    Offset p1 = points[0];


    path.reset();
    path..moveTo(p1.dx, p1.dy);

    for (var i = 1; i < points.length - 1; i++) {
      double xc = (points[i].dx + points[i + 1].dx) / 2;
      double yc = (points[i].dy + points[i + 1].dy) / 2;
      Offset p2 = points[i];
      path.quadraticBezierTo(p2.dx, p2.dy, xc, yc);
    }

    canvas.drawPath(path, paint);

    PathMetrics pms = path.computeMetrics();


    pms.forEach((pm) {
      print('----${pm.length}-----------');
      Tangent tangent = pm.getTangentForOffset(pm.length * repaint.value);
      canvas.drawCircle(
          tangent.position, 5, Paint()..color = Colors.blue);
    });

    // canvas.drawPath(path, paint);

    // canvas.drawPoints(PointMode.points, points, paint..shader=null..strokeWidth=3);
    // canvas.drawPoints(PointMode.polygon, points, paint..shader=null..strokeWidth=1..color=Colors.blue);
  }

  @override
  bool shouldRepaint(PaperPainter oldDelegate) =>
      oldDelegate.repaint != repaint;
}
