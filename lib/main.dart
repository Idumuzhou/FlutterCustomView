import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_view/p01/paper.dart';
import 'package:flutter_custom_view/p02_paint/paper.dart';
import 'package:flutter_custom_view/p03_canvas/canvas_page_01.dart';
import 'package:flutter_custom_view/p03_canvas/canvas_page_02.dart';
import 'package:flutter_custom_view/routes/navigator_route.dart';

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
  final _pageTitle = ['Paper00', 'Paint 画笔相关', '画笔基础属性,线性属性,着色器效果,过滤器效果', 'Canvas 上篇', 'Canvas 下篇'];
  final _pageList = [Paper(), Paper01(), Paper02(), CanvasPage01(), CanvasPage02()];

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
