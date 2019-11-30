import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_challenge_ecommerce/custom_app_bar.dart';
import 'package:flutter_challenge_ecommerce/page.dart';

class PreviewPopupRoute extends PageRoute<void> {

  final SlideData slideData;
  final Size size;
  final Offset position;

  PreviewPopupRoute({
    @required this.slideData,
    @required this.size,
    @required this.position
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
    return PreviewPage(size: size, position: position, slideData: slideData,);
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration(milliseconds: 400);

}

class PreviewPage extends StatefulWidget {

  final SlideData slideData;
  final Size size;
  final Offset position;

  PreviewPage({this.slideData, this.size, this.position});

  @override
  _PreviewPageState createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned(
            top: widget.position.dy,
            left: widget.position.dx,
            child: Container(
              width: widget.size.width,
              height: widget.size.height,
              color: Colors.yellowAccent,
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
                            Container( // image
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
          SafeArea(child: Align(
              alignment: Alignment.topLeft,
              child: CustomAppBar()
          )
          ),
        ],
      ),
    );
  }
}



