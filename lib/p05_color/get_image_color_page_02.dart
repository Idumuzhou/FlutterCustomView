import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_custom_view/utils/image_utils.dart';
import 'package:flutter_custom_view/utils/screen_utils.dart';
import 'package:flutter_custom_view/widgets/coordinate.dart';
import 'package:image/image.dart' as image;

/// create by LXL
/// description: 获取图片中的颜色
/// date: 2021/02/01 14:32

class GetImageColorPage extends StatefulWidget {
  @override
  _GetImageColorPageState createState() => _GetImageColorPageState();
}

class _GetImageColorPageState extends State<GetImageColorPage> {
  image.Image _image;
  List<Ball> balls = [];
  double d = 4; //复刻的像素边长

  @override
  void initState() {
    super.initState();
    ScreenUtils.setScreenHorizontal();
    _initBalls();
  }

  void _initBalls() async {
    _image = await ImageUtils.loadImageImageFromAssets('assets/images/ds_pixel.png');
    for (int i = 0; i < _image.width; i++) {
      for (int j = 0; j < _image.height; j++) {
        Ball ball = Ball();
        ball.x = i * d + d / 2;
        ball.y = j * d + d / 2;
        ball.r = d / 2;
        var color = Color(_image.getPixel(i, j));
        ball.color = Color.fromARGB(color.alpha, color.blue, color.green, color.red);
        balls.add(ball);
      }
    }
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
        painter: PaperPainter(_image, balls),
      ),
    );
  }
}

class PaperPainter extends CustomPainter {
  Paint _paint;
  final image.Image imageSrc;
  final List<Ball> balls;

  PaperPainter(this.imageSrc, this.balls) {
    _paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 0.5
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    //Coordinate.paint(canvas, size);

    //_drawImage(canvas);

    _drawImageConvert(canvas);
  }

  /// 将图片像素颜色取出,并转换成圆
  void _drawImageConvert(Canvas canvas) {
    canvas.save();
    canvas.translate(-180, -120);
    balls.forEach(
        (Ball ball) => canvas.drawCircle(Offset(ball.x, ball.y), ball.r, _paint..color = ball.color));
    canvas.restore();
  }

  /// 绘制方法
  void _drawImage(Canvas canvas) {
    if (imageSrc == null) return;
    int colorInt = imageSrc.getPixel(imageSrc.width, 0);
    var color = Color(colorInt);
    canvas.drawCircle(
        Offset.zero, 10, _paint..color = Color.fromARGB(color.alpha, color.blue, color.green, color.red));
  }

  @override
  bool shouldRepaint(PaperPainter oldDelegate) => balls != oldDelegate.balls;
}

class Ball {
  double x; //点位X
  double y; //点位Y
  Color color; //颜色
  double r; // 半径

  Ball({this.x, this.y, this.color, this.r});
}
