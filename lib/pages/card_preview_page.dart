
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_challenge_ecommerce/data/card_data.dart';
import 'package:flutter_challenge_ecommerce/data/data.dart';
import 'package:flutter_challenge_ecommerce/pages/gallery_page.dart';
import 'package:flutter_challenge_ecommerce/ui/card_view.dart';
import 'package:flutter_challenge_ecommerce/ui/custom_app_bar.dart';
import 'package:flutter_challenge_ecommerce/utils/utility_classes.dart';


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
  Animation<double> _disountAnimation;


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
    // анимация для текста со скидкой. Должна быть с небольщой задержкой
    _disountAnimation = Tween<double>(begin: 0.0, end: 1.0
    ).animate(CurvedAnimation(
      curve: Interval(0.3, 0.9, curve: curve),
      parent: widget.animation,
    ));


    super.initState();
  }
  Widget _createCartIcon() {
    return Hero(
      tag: widget.cardData.title,
      createRectTween: (Rect begin, Rect end) {
        return HeroRectTween(begin: begin, end: end);
      },
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
        createRectTween: (Rect begin, Rect end) {
          return HeroRectTween(begin: begin, end: end);
        },
        tag: 'description${widget.cardData.title}',
        child: Material(
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 25,
                child: Text(
                  '¥ ${widget.cardData.price.toStringAsFixed(2)}',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                      color: Data().pink
                  ),
                ),
              ),
              SizedBox(
                height: 7,
              ),
              Container(
                height: 20,
                child: Text(
                  widget.cardData.title,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Colors.black
                  ),
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

                  var completeRatio = _imagePosAnimation.value.clamp(0, 1);

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
                                top: widget.cardData.topPadding * completeRatio,
                                left: widget.cardData.sidePadding * completeRatio,
                                right: widget.cardData.sidePadding * completeRatio,
                              ),
                              child: Stack(
                                children: <Widget>[
                                  Transform( // тень под картинкой
                                    transform: Matrix4.translationValues(0, 18, 0),
                                    child: Opacity(
                                      opacity: completeRatio,
                                      child: Container(
                                        width: imageAnimWidth,
                                        height: imageAnimHeight,
//                                    color: Colors.orange.withOpacity(.7),
                                        child: CustomPaint(
                                          size: Size(widget.imageSize.width, widget.imageSize.height - 50),
                                          painter: ShadowPainter(.3),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container( // картинка
                                    width: imageAnimWidth,
                                    height: imageAnimHeight,
//                                    color: Colors.orange.withOpacity(.7),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7 * completeRatio),
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
                      Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Positioned(
                                bottom: -80 *  completeRatio,
                                left: (pageSize.width - 90) / 2,
                                child: Opacity(
                                  opacity: 1 - completeRatio,
                                  child: Container(
                                    width: 90,
                                    height: 120,
                                    child: Align(
                                      child: Image.asset('assets/img/bottom_label.png'),
                                      alignment: Alignment.topCenter,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Positioned( // текст скидки
                          bottom: 95 + 20 * _disountAnimation.value,
                            child: Opacity(
                              opacity: _disountAnimation.value,
                              child: Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: Text(
                                  widget.cardData.discountText,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black54
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            child: Material(
                              elevation: 20,
                              child: Container(
                                width: pageSize.width,
                                height: 52,
                                color: Colors.white,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Flexible(
                                      flex: 15,
                                      child: Container(
                                        child: Center(
                                          child: Icon(Icons.headset_mic, color: Colors.black26, size: 24,)
                                        ),
                                        height: 52,
                                      ),
                                    ),
                                    Flexible(
                                      flex: 15,
                                      child: Container(
                                        child: Center(
                                            child: Icon(Icons.favorite_border, color: Colors.black26, size: 24,)
                                        ),
                                        height: 52,
                                      ),
                                    ),
                                    Flexible(
                                      flex: 40,
                                      child: Container(
                                        child: Center(
                                          child: Text(
                                            '加入胞物年',
                                            style: TextStyle(
                                              fontSize: 18
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 30,
                                      child: Container(
                                        height: 52,
                                        child: Center(
                                          child: Text(
                                            '立即駒戻',
                                            style: TextStyle(
                                                fontSize: 18,
                                              color: Colors.white
                                            ),
                                          ),
                                        ),
                                        color: Data().pink
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            bottom: -52 *  completeRatio,
                          ),


                        ],
                      )

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



