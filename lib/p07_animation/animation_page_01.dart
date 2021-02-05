import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_custom_view/p07_animation/pac_man.dart';
import 'package:flutter_custom_view/utils/screen_utils.dart';

/// create by LXL
/// description: 绘制中使用动画
/// date: 2021/2/3 14:32

class AnimationPage01 extends StatefulWidget {


  @override
  _AnimationPage01State createState() => _AnimationPage01State();
}

class _AnimationPage01State extends State<AnimationPage01> with SingleTickerProviderStateMixin {
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
      body: Padding(
        padding: const EdgeInsets.only(left: 20,top: 60),
        child: Wrap(
          spacing: 20,
          runSpacing: 20,
          children: buildChildren(),
        ),
      ),
    );
  }

  List<Widget> buildChildren() => List<Widget>.generate(6, (index) => PacMan(
    color: Colors.blueAccent,
    angle: (1+index) *6.0,
  ));
}
