import 'dart:typed_data';

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
    _image = await ImageUtils.loadUiImageFromAssets('assets/images/shoot.png');
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
  final List<Sprite> allSprites = [];

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

    //绘制原始图集
    _drawRawAtlas(canvas,size);
  }

  ///绘制图集:drawAtlas
  void _drawAtlas(Canvas canvas) {
    if (image == null) return;
    // 添加一个 Sprite
    allSprites.add(Sprite(
      position: Rect.fromLTWH(0, 325, 257, 166),
      offset: Offset(0, 0),
      alpha: 255,
      rotation: 0,
    ));

    // 通过 allSprites 创建 RSTransform 集合
    final List<RSTransform> transforms = allSprites
        .map((sprite) => RSTransform.fromComponents(
              rotation: sprite.rotation,
              scale: 1.0,
              anchorX: 0,
              anchorY: 0,
              translateX: sprite.offset.dx,
              translateY: sprite.offset.dy,
            ))
        .toList();
    // 通过 allSprites 创建 Rect 集合
    final List<Rect> rects = allSprites.map((sprite) => sprite.position).toList();

    canvas.drawAtlas(image, transforms, rects, null, null, null, _paint);
  }

  ///绘制原始图集:drawRawAtlas
  void _drawRawAtlas(Canvas canvas,Size size){
    canvas.translate(-size.width/2, -size.height/2);
    allSprites.add(Sprite(
        position: Rect.fromLTWH(0, 325, 257, 166),
        offset: Offset(0, 0),
        alpha: 255,
        rotation: 0));

    allSprites.add(Sprite(
        position: Rect.fromLTWH(0, 325, 257, 166),
        offset: Offset(257, 130),
        alpha: 255,
        rotation: 0));

    Float32List rectList = Float32List(allSprites.length * 4);
    Float32List transformList = Float32List(allSprites.length * 4);

    for (int i = 0; i < allSprites.length; i++) {
      final Sprite sprite = allSprites[i];
      rectList[i * 4 + 0] = sprite.position.left;
      rectList[i * 4 + 1] = sprite.position.top;
      rectList[i * 4 + 2] = sprite.position.right;
      rectList[i * 4 + 3] = sprite.position.bottom;
      final RSTransform transform = RSTransform.fromComponents(
        rotation: sprite.rotation,
        scale: 1.0,
        anchorX: sprite.anchor.dx,
        anchorY: sprite.anchor.dy,
        translateX: sprite.offset.dx,
        translateY: sprite.offset.dy,
      );
      transformList[i * 4 + 0] = transform.scos;
      transformList[i * 4 + 1] = transform.ssin;
      transformList[i * 4 + 2] = transform.tx;
      transformList[i * 4 + 3] = transform.ty;
    }
    canvas.drawRawAtlas(image, transformList, rectList, null, null, null, _paint);
  }

  @override
  bool shouldRepaint(PaperPainter oldDelegate) => image != oldDelegate.image;
}

class Sprite {
  Rect position; // 雪碧图 中 图片矩形区域
  Offset offset; // 移动偏倚
  Offset anchor; // 移动偏倚
  int alpha; // 透明度
  double rotation; // 旋转角度

  Sprite({this.offset=Offset.zero,this.anchor=Offset.zero, this.alpha=255, this.rotation=0, this.position});
}
