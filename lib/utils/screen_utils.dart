import 'package:flutter/services.dart';

/// create by LXL
/// description: 
/// date: 2021/1/13 11:13

class ScreenUtils{
  ///强制横屏
  static void setScreenHorizontal(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
  }

  ///强制竖屏
  static void setScreenVertical(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
  }

}