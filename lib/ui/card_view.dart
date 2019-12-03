import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_challenge_ecommerce/data/card_data.dart';
import 'package:flutter_challenge_ecommerce/data/data.dart';
import 'package:flutter_challenge_ecommerce/preview_popup_route.dart';
import 'package:flutter_challenge_ecommerce/utility_classes.dart';


class CardView extends StatefulWidget {

  final CardData cardData;
  final ValueChanged<CardData> onTap;

  CardView(this.cardData, {this.onTap});

  @override
  _CardViewState createState() => _CardViewState();
}

class _CardViewState extends State<CardView> {

  double _tiltValueX = 0;
  double _tiltValueY = 0;
  GlobalKey _imageKey = GlobalKey();
  GlobalKey _cardKey = GlobalKey();

  double deg2rad(double degrees) {
    return degrees / 180 * pi;
  }

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
          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Transform(
                origin: Offset(size.width * .5, size.height * .5),
                transform: Matrix4.identity()
                  ..rotateX(deg2rad(-15 * _tiltValueY))
                  ..rotateY(deg2rad(15 * _tiltValueX))
                  ..setEntry(3, 2, 0.001),

                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: GestureDetector(
                    onTap: () {
                      if (widget.onTap != null) {
                        widget.onTap(widget.cardData);
                      }
                      RenderBox cardRenderBox = _cardKey.currentContext.findRenderObject();
                      RenderBox imageRenderBox = _imageKey.currentContext.findRenderObject();
//                      print("IMAGE RENDER BOX ${imageRenderBox.size}");
//                      print("CARD RENDER BOX ${cardRenderBox.size}");

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
                                AspectRatio( // image
                                  aspectRatio: widget.cardData.getAspectRatio(),
                                  child: Container( // image
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
                                )
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
            ],
          );
        },
      ),
    );
  }
}
