import 'package:flutter/material.dart';
import 'package:flutter_custom_view/utils/screen_utils.dart';

///Paint 画笔相关
class Paper01 extends StatefulWidget {
  @override
  _Paper01State createState() => _Paper01State();
}

class _Paper01State extends State<Paper01> {
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
    //创建画笔
    final Paint paint = Paint();
    //绘制圆
    canvas.drawCircle(Offset(100, 100), 20, paint);
    canvas.drawCircle(Offset(200, 100), 20, paint);
    //设置画笔颜色
    paint.color = Colors.red;
    canvas.drawCircle(Offset(150, 200), 20, paint);

    //绘制线
    final Paint paint2 = Paint();
    paint2
      ..color = Colors.orange //颜色
      ..strokeWidth = 4 //线宽
      ..style = PaintingStyle.stroke; //模式 线型
    canvas.drawLine(Offset(0, 0), Offset(100, 100), paint2);

    Path path = Path();
    path.moveTo(100, 100);
    path.lineTo(200, 0);
    canvas.drawPath(path, paint2..color = Colors.blue);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
