import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_challenge_ecommerce/data/card_data.dart';
import 'package:flutter_challenge_ecommerce/data/data.dart';
import 'package:flutter_challenge_ecommerce/ui/custom_app_bar.dart';
import 'package:flutter_challenge_ecommerce/utils/utility_classes.dart';

import '../ui/card_view.dart';
import '../utils/utils.dart';

class GalleryPage extends StatefulWidget {
  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {

  PageController _pageController;
  double _prevPageValue = 0.0;
  Color _pageColor;
  int _initialPage = 0;
  double _curPageValue = 0.0;
  double _nextPage = 0.0;
  double _prevPage = 0.0;


  @override
  void initState() {
    _pageColor = Data().slideDatas[_initialPage].pageColor;
    _pageController = PageController(
      viewportFraction: .85,
      initialPage: _initialPage
    )
    ..addListener(() {
      if (_pageController.page > _prevPageValue) {
        _nextPage = _pageController.page.ceilToDouble();
        _prevPage = _nextPage -1;
      } else {
        _nextPage = _pageController.page.floorToDouble();
        _prevPage = _nextPage + 1;
      }
      var lerpValue = (_nextPage - _pageController.page).abs();
      var currentColor = Data().slideDatas[_prevPage.toInt()].pageColor;
      var nextColor = Data().slideDatas[_nextPage.toInt()].pageColor;
      setState(() {
        _pageColor = Color.lerp(nextColor, currentColor, lerpValue);
      });
      _onPageMove(_pageController.page);
      _prevPageValue = _pageController.page;
    });

    _onPageMove(_initialPage.toDouble());
    super.initState();
  }

  double _getDirection() {
    return (_prevPage - _nextPage).sign;
  }

  List<Widget> _getCards() {
    var cards = <Widget>[];
    var page = _pageController.hasClients ? _pageController.page : 0.0;
    Data().slideDatas.forEach((slideData) {
      cards.add(CardView(slideData, pageMoveValue: page)
      );
    });
    return cards;
  }
  void _onPageMove(double pageValue) {
    setState(() {
      _curPageValue = pageValue;
    });
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  double _calculatePageAspectRatio() {
    return (1 / _pageController.viewportFraction) *
        (CardData.CARD_WIDTH / CardData.CARD_HEIGHT);
  }

  List<Widget> _getThumbs(double parentWidth) {

    var numThumbs = Data().slideDatas.length;

    var thumbWidth = 50.0;
    const thumbPadding = 10.0;
    var paddedWidth = (thumbWidth + (thumbPadding * 2));
    var halfParent = parentWidth / 2;
    var maxDistBetween = (thumbWidth / (numThumbs - 1)).clamp(0.0, thumbPadding);

    var thumbs = <Widget>[];
    for (var i = 0; i < numThumbs; i++) {

      // elastic movement
      var step = 1.0 / numThumbs;
      Interval interval;
      if (_getDirection() < 0) {
        interval = Interval(step * i, 1.0, curve: Curves.easeInQuart);
      } else {
        interval = Interval(0.0, step * (i + 1), curve: Curves.easeOutQuart);
      }
      var spring = interval.transform(_curPageValue % 1.0);
      var curLeft = (i * paddedWidth + halfParent - paddedWidth / 2);
      var newLeft = curLeft - (paddedWidth * (_curPageValue.floorToDouble() + spring));

      var imageOpacity = .5;
      var shadowOpacity = .0;
      if (_nextPage == i) {
        imageOpacity = 1.0;
        shadowOpacity = 1.0;
      }

      thumbs.add(Positioned(
        left: newLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: thumbPadding),
          child: Stack(
            children: <Widget>[
              AnimatedOpacity(
                opacity: shadowOpacity,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  width: thumbWidth,
                  height: 85,
                  child: CustomPaint(
                    size: Size(20, 85),
                    painter: ShadowPainter(.3),
                  ),
                ),
              ),
              AnimatedOpacity(
                opacity: imageOpacity,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  width: thumbWidth,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: AssetImage(
                        Data().slideDatas[i].imagePath
                      ),
                      fit: BoxFit.cover
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ));
    }
    return thumbs;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: _pageColor,
        body: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: <Widget>[
                  SizedBox( // a gap between top and page views
                    height: 120,
                  ),
                  Stack(
                    overflow: Overflow.visible,
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: _calculatePageAspectRatio(),
                        child: ScrollConfiguration(
                          behavior: NoGlowScrollBehavior(),
                          child: PageView(
                            controller: _pageController,
                            children: _getCards(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: LayoutBuilder( // нижний ряд эскизов
                      builder: (BuildContext context, BoxConstraints constraints) {
                        return Container(
                            width: double.infinity,
//                            color: Colors.red,
                            child: Stack(
                              children: _getThumbs(constraints.biggest.width),
                            ),
                          );
                      },
                    ),
                  ),
                ],
              )
            ),
            SafeArea(
              child: CustomAppBar()
            ),
          ],
        ),
      ),
    );
  }
}

