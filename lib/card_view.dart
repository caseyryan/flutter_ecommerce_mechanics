import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_challenge_ecommerce/page.dart';

class CardView extends StatefulWidget {

  final SlideData slideData;
  final double index;
  final ValueChanged<SlideData> onTap;

  CardView(this.slideData, this.index, {this.onTap});

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

    Size _cardSize;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
      child: GestureDetector(
        onTap: () {
         if (widget.onTap != null) {
           widget.onTap(widget.slideData);
         }
        },
        onLongPress: () {
          print('LOGN PRESS');
        },
        onLongPressEnd: (LongPressEndDetails e) {
          setState(() {
            _tiltValueX = 0.0;
            _tiltValueY = 0.0;
          });
        },
        onLongPressMoveUpdate: (LongPressMoveUpdateDetails d) {
//          print(d.globalPosition);
          var renderObject = context.findRenderObject() as RenderBox;
//          var screenSize = MediaQuery.of(context).size;
          // определение с какой стороны относительно центра находится палец
          // справа от 0 до -1, слева 0 до 1
          var moveRatioX = (d.localPosition.dx / renderObject.size.width) * 2;
          var moveRatioY = (d.localPosition.dy / renderObject.size.height) * 2;

          setState(() {
            _tiltValueX = (1 - moveRatioX).clamp(-1, 1).toDouble();
            _tiltValueY = (1 - moveRatioY).clamp(-1, 1).toDouble();
            print('TILT X $_tiltValueX TILT Y $_tiltValueY');
          });
        },
        child: LayoutBuilder(
          // сделал через билдер, чтобы можно было получить размер в процессе
          builder: (context, constraints) {
            // получаем размер, чтобы задать офсет вокруг центра
            var renderObject = context.findRenderObject() as RenderBox;
            Size size;
            if (renderObject.hasSize) {
              size = renderObject.size;
            } else {
              size = Size.zero;
            }

            return Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.pink,
                ),
                Transform(
                  origin: Offset(size.width * .5, size.height * .5),
                  transform: Matrix4.identity()
//            ..rotateX(deg2rad(10 * _tiltValue))
                    ..rotateX(deg2rad(-15 * _tiltValueY))
                    ..rotateY(deg2rad(15 * _tiltValueX))
                    ..setEntry(3, 2, 0.001),

                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 3.0,
                        right: 3.0,
                        top: 5.0,
                        bottom: 25.0
                    ),
                    child: Card(
                      child: Container(
                        width: 320,
                        height: 435,
                        child: Padding( // паддинг внутри карточки
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: <Widget>[
                              AspectRatio(
                                aspectRatio: 400 / 485,
                                child: Stack(
                                  overflow: Overflow.visible,
                                  children: <Widget>[
                                    AnimatedContainer( // image
                                      duration: Duration(milliseconds: 800),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(7),
                                          image: DecorationImage(
                                              fit: BoxFit.contain,
                                              image: AssetImage(widget.slideData.imagePath)
                                          )
                                      ),
                                    )
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
      ),
    );
  }
}
