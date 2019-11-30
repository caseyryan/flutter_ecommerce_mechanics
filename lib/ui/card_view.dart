import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_challenge_ecommerce/data/card_data.dart';
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


  double deg2rad(double degrees) {
    return degrees / 180 * pi;
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
                      RenderBox renderBox = context.findRenderObject();
                      Navigator.of(context).push(
                        PreviewPopupRoute(
                          slideData: widget.cardData,
                          size: renderBox.size,
                          position: renderBox.localToGlobal(Offset.zero),
                        )
                      );
                    },
                    child: Card(
                      child: Padding( // inner padding
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                AspectRatio(
                                  aspectRatio: widget.cardData.getAspectRatio(),
                                  child: Container( // image
                                    width: widget.cardData.imageWidth,
                                    height: widget.cardData.imageHeight,
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