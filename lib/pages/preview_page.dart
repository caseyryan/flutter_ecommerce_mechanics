
import 'package:flutter/material.dart';
import 'package:flutter_challenge_ecommerce/data/card_data.dart';
import 'package:flutter_challenge_ecommerce/pages/page.dart';
import 'package:flutter_challenge_ecommerce/ui/card_view.dart';
import 'package:flutter_challenge_ecommerce/ui/custom_app_bar.dart';

import '../utility_classes.dart';

class PreviewPage extends StatefulWidget {

  final CardData slideData;
  final Size size;
  final Offset position;
  final Animation<double> animation;

  PreviewPage({
    this.slideData,
    this.size,
    this.position,
    this.animation,
  }) :
      assert(slideData != null),
      assert(size != null),
      assert(position != null),
      assert(animation != null);

  @override
  _PreviewPageState createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> with SingleTickerProviderStateMixin {


  Animation<double> _imagePosAnimation;
  Animation<double> _sizeAnimation;
  Animation<double> _aspectRatioAnimation;
//  double _imageInitWidth;
//  double _imageInitHeight;
  Curve _curve = Curves.easeInBack;

  @override
  void initState() {
//    _imageInitWidth = widget.size.width - (CardView.IMAGE_PADDING * 2);
//    _imageInitHeight = widget.size.height - (CardView.IMAGE_PADDING * 2);
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
                  var size = constraints.biggest;
                  var widthDiff = ((size.width - widget.size.width) * _sizeAnimation.value);
                  var paddingWidth = widget.size.width + widthDiff;
                  var paddingHeight = widget.size.height + ((size.height - widget.size.height) * _sizeAnimation.value);

//                  var imageWidth = (size.width - (CardView.IMAGE_PADDING * 2) * _imagePosAnimation.value.clamp(0, 1)) + widthDiff;
//                  var imageHeight = (CardView.IMAGE_HEIGHT - (CardView.IMAGE_PADDING * 2)) + (size.height - CardView.IMAGE_HEIGHT);

                  return Stack(
                    children: <Widget>[
                      Positioned(
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
                        /*child: Padding(
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
                        ),*/
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



