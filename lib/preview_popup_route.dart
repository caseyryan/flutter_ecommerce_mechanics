

import 'package:flutter/material.dart';
import 'package:flutter_challenge_ecommerce/pages/card_preview_page.dart';

import 'data/card_data.dart';
import 'utility_classes.dart';

class PreviewPopupRoute extends PageRoute<void> {

  final CardData slideData;
  final Size cardSize;
  final Size imageSize;
  final Offset position;

  PreviewPopupRoute({
    @required this.slideData,
    @required this.cardSize,
    @required this.imageSize,
    @required this.position,
  });

  @override
  Color get barrierColor => null;

  @override
  String get barrierLabel => null;

  @override
  bool get opaque => false;

  @override
  Widget buildPage(BuildContext context, Animation<double>
  animation, Animation<double> secondaryAnimation) {
    return CardPreviewPage(
      cardSize: cardSize,
      position: position,
      cardData: slideData,
      imageSize: imageSize,
      animation: animation,
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration(milliseconds: 620);

}
