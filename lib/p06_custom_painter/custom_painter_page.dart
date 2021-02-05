import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_custom_view/utils/screen_utils.dart';
import 'package:flutter_custom_view/widgets/coordinate.dart';

/// create by LXL
/// description: CustomPaint
/// date: 2021/2/2 17:52
class CustomPainterPage extends StatefulWidget {
  @override
  _CustomPainterPageState createState() => _CustomPainterPageState();
}

class _CustomPainterPageState extends State<CustomPainterPage> {
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
    return Scaffold(
      body: _buildChild(type: PainterType.Layout_Builder),
    );
  }

  ///前景&背景
  ///Size
  Widget _buildChild({PainterType type = PainterType.PAINTER}) {
    Widget just;
    if (type == PainterType.PAINTER) {
      just = Container(
        width: double.infinity,   //充满全屏
        height: double.infinity,
        color: Colors.white,
        child: CustomPaint(
          painter: PaperPainter(), //背景
          //foregroundPainter: PaperPainter(),  //前景
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Text(
              'Dawn Flutter',
              style: TextStyle(color: Colors.red, fontSize: 40),
            ),
          ),
        ),
      );
    }
    ///为CustomPaint指定尺寸
    if (type == PainterType.SIZE) {
      just = CustomPaint(
        painter: PaperPainter(),
        size: Size(100, 100),
      );
    }
    ///为CustomPaint设置一个固定尺寸的组件
    if (type == PainterType.FIXED_SIZE) {
      just = CustomPaint(
        painter: PaperPainter(),
        child: Container(
          width: 200,
          height: 200,
        ),
      );
    }
    ///使用LayoutBuilder获取布局区域
    if (type == PainterType.Layout_Builder) {
      just = LayoutBuilder(builder: _builderByLayout);
    }
    return just;
  }

  Widget _builderByLayout(BuildContext context, BoxConstraints constraints) {
    return CustomPaint(
      size: Size(constraints.maxWidth, constraints.maxHeight),
      painter: PaperPainter(), // 背景
    );
  }
}

class PaperPainter extends CustomPainter {
  Paint _paint;

  PaperPainter() {
    _paint = Paint()
      ..color = Colors.deepOrange
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    Coordinate.paint(canvas, size);

    canvas.drawRect(Rect.fromPoints(Offset.zero, Offset(50, 50)), _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

enum PainterType {
  PAINTER, //前景&背景
  SIZE, //size相关
  FIXED_SIZE, //固定尺寸的组件
  Layout_Builder,  //使用LayoutBuilder获取布局区域
}
