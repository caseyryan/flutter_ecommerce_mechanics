import 'package:flutter/material.dart';

class SlideData {
  final Color pageColor;
  final String imagePath;
  final double price;
  final String title;

  SlideData({this.imagePath, this.title, this.pageColor, this.price});

}

class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}