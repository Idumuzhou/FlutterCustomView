import 'package:flutter/material.dart';

/// create by LXL
/// description:
/// date: 2021/2/4 15:14

class CurveBox extends StatefulWidget {
  final Color color;
  final Curve curve;

  CurveBox({Key key, this.color = Colors.lightBlue, this.curve = Curves.linear}) : super(key: key);

  @override
  _CurveBoxState createState() => _CurveBoxState();
}

class _CurveBoxState extends State<CurveBox> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}
