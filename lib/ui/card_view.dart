import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_challenge_ecommerce/data/card_data.dart';
import 'package:flutter_challenge_ecommerce/data/data.dart';
import 'package:flutter_challenge_ecommerce/routes/preview_popup_route.dart';
import 'package:flutter_challenge_ecommerce/utils/utility_classes.dart';

import '../utils/utils.dart';


class CardView extends StatefulWidget {

  final CardData cardData;
  // used to incline card while moving
  final double pageMoveValue;


  CardView(this.cardData, {this.pageMoveValue = 1.0});

  @override
  _CardViewState createState() => _CardViewState();
}

class _CardViewState extends State<CardView> {

  static const double MAX_INCLINE_DEG = 15.0;

  double _tiltValueX = 0;
  double _tiltValueY = 0;
  GlobalKey _imageKey = GlobalKey();
  GlobalKey _cardKey = GlobalKey();


  Widget _createCartIcon() {
    return Hero(
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

  @override
  void didUpdateWidget(Widget oldWidget) {
    setState(() {
      // we don't need to know the page's ordinal
      // number but need to know the current slide value
      var pageMove = (widget.pageMoveValue % 1.0);
      var incline = sin(deg2rad(pageMove * 180));
      _tiltValueY = deg2rad(MAX_INCLINE_DEG * incline);
    });
    super.didUpdateWidget(oldWidget);
  }

  Widget _getDescriptionShuttle({
    String priceText, String title,
    FontWeight descriptionFontWeight,
    Color priceColor, double priceTextSize, Animation animation}) {
      return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget widget) {
          return _getDescriptionWidget(
            priceText: priceText,
            priceColor: Color.lerp(priceColor, Data().pink, animation.value),
            title: title,
            priceTextSize: priceTextSize + (3 * animation.value),
            descriptionFontWeight: FontWeight.lerp(descriptionFontWeight, FontWeight.w900, animation.value)
          );
        },
      );
  }

  Widget _getDescriptionWidget({
    String priceText, String title,
    FontWeight descriptionFontWeight,
    Color priceColor, double priceTextSize}) {
    return Material(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 25,
            child: Text(
              priceText,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: priceTextSize,
                  fontWeight: FontWeight.w900,
                  color: priceColor
              ),
            ),
          ),
          SizedBox(
            height: 7,
          ),
          Container(
            height: 20,
            child: Text(
              title,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: descriptionFontWeight,
                  color: Colors.black
              ),
            ),
          )
        ],
      ),
    );
  }


  Widget _getDescription() {

    var priceText = '¥ ${widget.cardData.price.toStringAsFixed(2)}';
    var title = widget.cardData.title;
    var priceColor = Colors.black;
    var priceTextSize = 20.0;
    var descFontWeight = FontWeight.w500;

    return Expanded(
      child: Hero(
        flightShuttleBuilder: (BuildContext context, Animation animation,
            HeroFlightDirection direction, BuildContext context1, BuildContext context2) {
          return _getDescriptionShuttle(
            title: title,
            priceText: priceText,
            animation: animation,
            priceTextSize: priceTextSize,
            priceColor: priceColor,
            descriptionFontWeight: descFontWeight
          );
        },
        tag: 'description${widget.cardData.title}',
        child: _getDescriptionWidget(
          title: title,
          priceColor: priceColor,
          priceTextSize: priceTextSize,
          priceText: priceText,
          descriptionFontWeight: descFontWeight
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          Size size = constraints.biggest;
          Offset center = Offset(size.width * .5, size.height * .5);
          return Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Transform(
                transform: (Matrix4.identity()
                  ..setEntry(3, 2, 0.001))
                    * Matrix4.rotationX(_tiltValueX * .5)
                    * Matrix4.rotationY(_tiltValueY * .5),
                child: Container( //
                  width: size.width,
                  height: size.height + 50,
                  child: CustomPaint(
                    size: Size(size.width, size.height + 50),
                    painter: ShadowPainter(.3),
                  ),
                ),
              ),
              Transform( // card
                origin: center,
                transform: (Matrix4.identity()
                  ..setEntry(3, 2, 0.001))
                    * Matrix4.rotationX(_tiltValueX)
                    * Matrix4.rotationY(_tiltValueY),

                child: Container(
                  height: size.height - 20, // простраство для тени
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: GestureDetector(

                      onLongPressMoveUpdate: (LongPressMoveUpdateDetails details) {
                        setState(() {
                          var a2 = atan2(
                            center.dy - details.localPosition.dy,
                            center.dx - details.localPosition.dx
                          );
                          var dist = (center - Offset(
                              details.localPosition.dx,
                              details.localPosition.dy)
                          )
                          .distance
                          .clamp(0.0, size.width) / size.width * MAX_INCLINE_DEG;

                          print(dist);
                          _tiltValueY = deg2rad(cos(a2) * dist);
                          _tiltValueX = -deg2rad(sin(a2) * dist);
                        });
                      },
                      onLongPressEnd: (LongPressEndDetails details) {
                        setState(() {
                          _tiltValueX = _tiltValueY = 0.0;
                        });
                      },
                      onTap: () {
                        RenderBox cardRenderBox = _cardKey.currentContext.findRenderObject();
                        RenderBox imageRenderBox = _imageKey.currentContext.findRenderObject();

                        Navigator.of(context).push(
                          PreviewPopupRoute(
                            slideData: widget.cardData,
                            cardSize: cardRenderBox.size,
                            imageSize: imageRenderBox.size,
                            position: cardRenderBox.localToGlobal(Offset.zero),
                          )
                        );
                      },
                      child: Card(
                        child: Padding( // inner padding
                          key: _cardKey,
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  Transform( // тень под картинкой
                                    transform: Matrix4.translationValues(0, 18, 0),
                                    child: AspectRatio(
                                      aspectRatio: widget.cardData.getAspectRatio(),
                                      child: Container(
                                        width: widget.cardData.imageWidth,
                                        height: widget.cardData.imageHeight,
                                        child: CustomPaint(
                                          size: Size(size.width, size.height + 50),
                                          painter: ShadowPainter(.3),
                                        ),
                                      ),
                                    ),
                                  ),
                                  AspectRatio( // картинка
                                    aspectRatio: widget.cardData.getAspectRatio(),
                                    child: Container(
                                      width: widget.cardData.imageWidth,
                                      height: widget.cardData.imageHeight,
                                      key: _imageKey,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(7),
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: AssetImage(widget.cardData.imagePath)
                                          )
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Row(
                                  children: <Widget>[
                                    _getDescription(),
                                    _createCartIcon(),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}



