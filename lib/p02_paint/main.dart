import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_view/p02_paint/paper.dart';

/// create by DuMuZhou on
/// description: 画笔基础属性,线性属性,着色器效果,过滤器效果
/// @date: 2020/11/11 11:38

void main() {
  // 确定初始化
  WidgetsFlutterBinding.ensureInitialized();
  //横屏
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  //全屏显示
  SystemChrome.setEnabledSystemUIOverlays([]);

  runApp(Paper02());
}

