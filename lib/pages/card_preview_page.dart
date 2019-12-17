
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_challenge_ecommerce/data/card_data.dart';
import 'package:flutter_challenge_ecommerce/data/data.dart';
import 'package:flutter_challenge_ecommerce/pages/page.dart';
import 'package:flutter_challenge_ecommerce/ui/card_view.dart';
import 'package:flutter_challenge_ecommerce/ui/custom_app_bar.dart';


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
  Animation<double> _imageLiftAnimation;
  Animation<double> _imageSizeAnimation;
  Animation<double> _padPosAnimation;
  Animation<double> _padSizeAnimation;


  @override
  void initState() {

    Curve curve = Curves.easeInCubic;

    _imagePosAnimation = Tween<double>(begin: 1.0, end: 0.0
    ).animate(CurvedAnimation(
      curve: Interval(0.3, 0.7, curve: curve),
      parent: widget.animation,
    ));
    _imageLiftAnimation = Tween<double>(begin: 0.0, end: -50.0
    ).animate(CurvedAnimation(
      curve: Interval(0.0, 0.45, curve: Curves.easeInBack),
      parent: widget.animation,
    ));

    _imageSizeAnimation = Tween<double>(begin: 0.0, end: 1.0
    ).animate(CurvedAnimation(
      curve: Interval(0.3, 0.7, curve: curve),
      parent: widget.animation,
    ));

    _padPosAnimation = Tween<double>(begin: 1.0, end: 0.0
    ).animate(CurvedAnimation(
      curve: Interval(0.2, 0.7, curve: curve),
      parent: widget.animation,
    ));

    _padSizeAnimation = Tween<double>(begin: 0.0, end: 1.0
    ).animate(CurvedAnimation(
      curve: Interval(0.2, 0.7, curve: curve),
      parent: widget.animation,
    ));



    super.initState();
  }
  Widget _createCartIcon() {
    return Hero(
      flightShuttleBuilder: (BuildContext context, Animation animation,
          HeroFlightDirection direction, BuildContext context1, BuildContext context2) {
        return Container();
      },
      tag: widget.cardData.title,
      child: Container(
        width: 45,
        height: 45,
        child: Icon(
          Icons.add_shopping_cart,
          color: Colors.white,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          color: Data().pink,
        ),
      ),
    );
  }
  Widget _getDescription() {
    return Expanded(
      child: Hero(
        tag: 'description${widget.cardData.title}',
        child: Material(
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                '¥ ${widget.cardData.price.toStringAsFixed(2)}',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Data().pink
                ),
              ),
              SizedBox(
                height: 7,
              ),
              Text(
                widget.cardData.title,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black
                ),
              )
            ],
          ),
        ),
      ),
    );
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
                  var maxImageHeight = pageSize.height * .7;
                  // changing pad width and height depending on the animation progress
                  var whitePadAnimWidth = widget.cardSize.width + (pageSize.width - widget.cardSize.width) * _padSizeAnimation.value;
                  var whitePadAnimHeight = widget.cardSize.height + (pageSize.height - widget.cardSize.height) * _padSizeAnimation.value;

                  var imageAnimWidth = widget.imageSize.width + (pageSize.width - widget.imageSize.width) * _imageSizeAnimation.value;
                  var imageAnimHeight = widget.imageSize.height + (maxImageHeight - widget.imageSize.height) * _imageSizeAnimation.value;

                  var paddingPercent = _imagePosAnimation.value.clamp(0, 1);

                  var imageTop = (widget.position.dy * _imagePosAnimation.value) + _imageLiftAnimation.value;
                  var imageLeft = widget.position.dx * _imagePosAnimation.value;

                  var padTop = widget.position.dy * _padPosAnimation.value;
                  var padLeft = widget.position.dx * _padPosAnimation.value;


                  return Stack(
                    children: <Widget>[
                      Positioned(
                        top: padTop,
                        left: padLeft,
                        child: Container(
                          width: whitePadAnimWidth,
                          height: whitePadAnimHeight,
                          color: Colors.white,
                        ),
                      ),
                      Stack(
                        children: <Widget>[
                          Positioned(
                            top: imageTop,
                            left: imageLeft,
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: widget.cardData.topPadding * paddingPercent,
                                left: widget.cardData.sidePadding * paddingPercent,
                                right: widget.cardData.sidePadding * paddingPercent,
                              ),
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    width: imageAnimWidth,
                                    height: imageAnimHeight,
//                                    color: Colors.orange.withOpacity(.7),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7 * paddingPercent),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(widget.cardData.imagePath)
                                        )
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: maxImageHeight,
                        child: Container(
                          width: pageSize.width,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              children: <Widget>[
                                _getDescription(),
                                _createCartIcon()
                              ],
                            ),
                          ),
                        ),
                      ),


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



