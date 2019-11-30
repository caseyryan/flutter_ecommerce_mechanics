
import 'package:flutter/material.dart';
import 'package:flutter_challenge_ecommerce/pages/page.dart';
import 'package:flutter_challenge_ecommerce/ui/custom_app_bar.dart';

import '../utility_classes.dart';

class PreviewPage extends StatefulWidget {

  final SlideData slideData;
  final Size size;
  final Offset position;
  final Animation<double> animation;

  PreviewPage({this.slideData, this.size, this.position, this.animation});

  @override
  _PreviewPageState createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> with SingleTickerProviderStateMixin {


  Animation<double> _imagePosAnimation;
  Animation<double> _sizeAnimation;

  @override
  void initState() {

    _imagePosAnimation = Tween<double>(
        begin: 1.0,
        end: 0.0
    ).animate(CurvedAnimation(
      curve: Curves.easeOutBack,
      parent: widget.animation,
    ));
    _sizeAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0
    ).animate(CurvedAnimation(
      curve: Curves.easeOutBack,
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
                  var paddingWidth = widget.size.width + ((size.width - widget.size.width) * _sizeAnimation.value);
                  var paddingHeight = widget.size.height + ((size.height - widget.size.height) * _sizeAnimation.value);
                  return Stack(
                    children: <Widget>[
                      Positioned(
                        top: widget.position.dy * _imagePosAnimation.value,
                        left: widget.position.dx * _imagePosAnimation.value,
                        child: Container(
                          width: paddingWidth,
                          height: paddingHeight,
                          color: Colors.yellowAccent,
                        ),
                      ),
                    ],
                  );
                },
              );
            },

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



//Container( // image
//width: 320,
//height: 435,
//decoration: BoxDecoration(
//borderRadius: BorderRadius.circular(7),
//image: DecorationImage(
//fit: BoxFit.contain,
//image: AssetImage(widget.slideData.imagePath)
//)
//),
//)