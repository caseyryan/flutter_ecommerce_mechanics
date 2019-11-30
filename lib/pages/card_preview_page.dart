
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_challenge_ecommerce/data/card_data.dart';
import 'package:flutter_challenge_ecommerce/pages/page.dart';
import 'package:flutter_challenge_ecommerce/ui/card_view.dart';
import 'package:flutter_challenge_ecommerce/ui/custom_app_bar.dart';

import '../utility_classes.dart';

class CardPreviewPage extends StatefulWidget {

  final CardData cardData;
  final Size cardSize;
  final Size imageSize;
  final Offset position;
  final Animation<double> animation;

  CardPreviewPage({
    @required this.cardData,
    @required this.cardSize,
    @required this.imageSize,
    @required this.position,
    @required this.animation,
  }) :
      assert(cardData != null),
      assert(cardSize != null),
      assert(imageSize != null),
      assert(position != null),
      assert(animation != null);

  @override
  _CardPreviewPageState createState() => _CardPreviewPageState();
}

class _CardPreviewPageState extends State<CardPreviewPage> with SingleTickerProviderStateMixin {


  Animation<double> _imagePosAnimation;
  Animation<double> _sizeAnimation;
  Animation<double> _aspectRatioAnimation;
  Curve _curve = Curves.easeOutBack;

  @override
  void initState() {
    _imagePosAnimation = Tween<double>(
        begin: 1.0,
        end: 0.0
    ).animate(CurvedAnimation(
      curve: _curve,
      parent: widget.animation,
    ));
    _sizeAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0
    ).animate(CurvedAnimation(
      curve: _curve,
      parent: widget.animation,
    ));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          AnimatedBuilder(
            animation: widget.animation,
            builder: (c, w) {
              return LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  // the size of the entire window
                  var pageSize = constraints.biggest;
                  // changing pad width and height depending on the animation progress
                  var whitePadAnimWidth = widget.cardSize.width + (pageSize.width - widget.cardSize.width) * _sizeAnimation.value;
                  var whitePadAnimHeight = widget.cardSize.height + (pageSize.height - widget.cardSize.height) * _sizeAnimation.value;

                  var imageAnimWidth = widget.imageSize.width + (pageSize.width - widget.imageSize.width) * _sizeAnimation.value;
                  var imageAnimHeight = widget.imageSize.height + (pageSize.height * .7 - widget.imageSize.height) * _sizeAnimation.value;



                  return Stack(
                    children: <Widget>[
                      /*Positioned(
                        top: widget.position.dy * _imagePosAnimation.value,
                        left: widget.position.dx * _imagePosAnimation.value,
                        child: Container(
                          width: whitePadAnimWidth,
                          height: whitePadAnimHeight,
                          color: Colors.white,

                        ),
                      ),*/
                      Positioned(
                        top: widget.position.dy * _imagePosAnimation.value,
                        left: widget.position.dx * _imagePosAnimation.value,
                        child: Container(
                          width: whitePadAnimWidth,
                          height: whitePadAnimHeight,
                          color: Colors.red.withOpacity(.6),
                          child: Stack(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                   top: widget.cardData.topPadding * widget.animation.value,
                                   left: widget.cardData.sidePadding * widget.animation.value,
                                   right: widget.cardData.sidePadding * widget.animation.value,
                                ),
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      width: imageAnimWidth,
                                      height: imageAnimHeight,
                                      color: Colors.orange.withOpacity(.7),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      /*Positioned(
                        top: widget.position.dy * _imagePosAnimation.value,
                        left: widget.position.dx * _imagePosAnimation.value,
                        child: Container(
                          width: paddingWidth,
                          height: paddingHeight,
                          color: Colors.white,
                        ),
                      ),
                      Positioned(
                        top: widget.position.dy * _imagePosAnimation.value,
                        left: widget.position.dx * _imagePosAnimation.value,
                        child: Padding(
                          padding: EdgeInsets.all(CardView.IMAGE_PADDING * _imagePosAnimation.value.clamp(0, 1)),
                          child: Container( // image
                            width: imageWidth,
                            height: imageHeight,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(widget.slideData.imagePath)
                              )
                            ),
                          ),
                        ),
                      )*/
                    ],
                  );
                },
              );
            },
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: CustomAppBar()
            )
          ),
        ],
      ),
    );
  }
}



