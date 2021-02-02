import 'package:flutter/material.dart';
import 'package:flutter_custom_view/p01/paper.dart';
import 'package:flutter_custom_view/p02_paint/paper.dart';
import 'package:flutter_custom_view/p03_canvas/canvas_draw_atlas.dart';
import 'package:flutter_custom_view/p03_canvas/canvas_draw_image_nine.dart';
import 'package:flutter_custom_view/p03_canvas/canvas_draw_text.dart';
import 'package:flutter_custom_view/p03_canvas/canvas_page_01.dart';
import 'package:flutter_custom_view/p03_canvas/canvas_page_02.dart';
import 'package:flutter_custom_view/p04_path/path_page_01.dart';
import 'package:flutter_custom_view/p05_color/color_blend_mode_page.dart';
import 'package:flutter_custom_view/p05_color/color_page_01.dart';
import 'package:flutter_custom_view/p05_color/color_page_02.dart';
import 'package:flutter_custom_view/p05_color/image_filter_page.dart';
import 'package:flutter_custom_view/routes/navigator_route.dart';

import 'p04_path/path_page_02.dart';
import 'p05_color/get_image_color_page_02.dart';
import 'paper.dart';

void main() {
  //确定初始化
  WidgetsFlutterBinding.ensureInitialized();
  /*//使设备横屏显示
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  //全屏显示
  SystemChrome.setEnabledSystemUIOverlays([]);*/

  runApp(MyHomePage());
}

class MyHomePage extends StatelessWidget {
  final _pageTitle = [
    'Paper00',
    'Paint 画笔相关',
    '画笔基础属性,线性属性,着色器效果,过滤器效果',
    'Canvas 上篇',
    'Canvas 下篇',
    '.9 图片域绘制',
    '绘制图集',
    '绘制文字',
    'Path 上篇',
    'Path 下篇',
    'Color 上篇',
    'Color 下篇',
    'Color 混合模式',
    '获取图片中的颜色',
    '图片着色器',
  ];
  final _pageList = [
    Paper(),
    Paper01(),
    Paper02(),
    CanvasPage01(),
    CanvasPage02(),
    CanvasDrawImageNinePage(),
    CanvasDrawAtlasPage(),
    CanvasDrawTextPage(),
    PathPage01(),
    PathPage02(),
    ColorPage01(),
    ColorPage02(),
    ColorBlendModePage(),
    GetImageColorPage(),
    ImageFilterPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter CustomView',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Customer View'),
        ),
        body: ListView.builder(
          itemCount: _pageList.length,
          itemBuilder: (context, index) => _ListItem(
              title: _pageTitle[index],
              onTap: () {
                NavigatorRoute.pushPage(context, _pageList[index]);
              }),
        ),
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  final String title;
  final GestureTapCallback onTap;

  const _ListItem({Key key, this.title, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        child: Container(
          height: 45,
          alignment: Alignment.center,
          child: Text(title),
        ),
        onTap: onTap,
      ),
    );
  }
}
