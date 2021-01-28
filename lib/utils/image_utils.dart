import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


/// create by LXL
/// description: 
/// date: 2021/1/27 16:25

class ImageUtils{


  ///读取 assets 中的图片
  static Future<ui.Image> loadImageFromAssets(String path) async {
    //通过 decodeImageFromList 方法可以将一个字节流转换为ui.Image 对象。将 assets 的文件读取为字节流可以使用 rootBundle.load 方法。
    ByteData data = await rootBundle.load(path);
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    return decodeImageFromList(bytes);
  }


}