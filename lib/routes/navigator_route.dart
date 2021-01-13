import 'package:flutter/material.dart';

class NavigatorRoute {

  ///跳转到指定Page
  static void pushPage(
    BuildContext context,
    Widget page, {
    String pageName,
    bool needLogin = false,
  }) {
    if (context == null || page == null) return;
    Navigator.push(context, new MaterialPageRoute<void>(builder: (ctx) => page));
  }

  ///关闭当前
  static void closePage(BuildContext context) {
    Navigator.pop(context);
  }
}
