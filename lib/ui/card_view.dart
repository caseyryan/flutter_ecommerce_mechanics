import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_challenge_ecommerce/data/card_data.dart';
import 'package:flutter_challenge_ecommerce/data/data.dart';
import 'package:flutter_challenge_ecommerce/preview_popup_route.dart';
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
                    color: Colors.black
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
                child: Container(
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
                  height: size.height - 20, //-20 чтобы оставить пространство для тени
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



