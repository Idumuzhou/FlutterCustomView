import 'dart:ui';

import 'package:flutter/material.dart';

/// create by LXL
/// description: 自定义 Tween
/// date: 2021/2/3 17:32

class ColorDoubleTween extends Tween<ColorDouble> {
  ColorDoubleTween({ColorDouble begin, ColorDouble end}) : super(begin: begin, end: end);

  @override
  ColorDouble lerp(double t) {
    return ColorDouble(
        color: Color.lerp(begin.color, end.color, t), value: (begin.value + (end.value - begin.value) * t));
  }
}

class ColorDouble {
  final Color color;
  final double value;

  ColorDouble({this.color = Colors.blue, this.value = 0});
}
