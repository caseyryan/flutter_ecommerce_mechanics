import 'package:flutter/material.dart';

class CardData {

  /// the outer bounds of the card.
  /// also used in AspectRatio calculation
  static const double CARD_WIDTH = 400;
  static const double CARD_HEIGHT = 560;

  final double sidePadding = 10;
  final double topPadding = 10;
  final double bottomPadding = 60.0;
  final double imageWidth = 400.0;
  final double imageHeight = 462.0;

  final Color pageColor;
  final String imagePath;
  final double price;
  final String title;

  double getAspectRatio() {
    return imageWidth / imageHeight;
  }

  CardData({this.imagePath, this.title, this.pageColor, this.price});

}