import 'package:flutter/material.dart';
import 'package:flutter_challenge_ecommerce/data/card_data.dart';
import 'package:flutter_challenge_ecommerce/data/data.dart';
import 'package:flutter_challenge_ecommerce/ui/custom_app_bar.dart';
import 'package:flutter_challenge_ecommerce/utils/utility_classes.dart';

import '../ui/card_view.dart';
import '../utils/utils.dart';

class Page extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> {

  PageController _pageController;
  double _prevPageValue = 0.0;
  Color _pageColor;
  int _initialPage = 0;


  @override
  void initState() {
    _pageColor = Data().slideDatas[_initialPage].pageColor;
    _pageController = PageController(
      viewportFraction: .85,
      initialPage: _initialPage
    )
    ..addListener(() {
      var nextValue = 0.0;
      var prevValue = 0.0;
      if (_pageController.page > _prevPageValue) {
        nextValue = _pageController.page.ceilToDouble();
        prevValue = nextValue -1;
      } else {
        nextValue = _pageController.page.floorToDouble();
        prevValue = nextValue + 1;
      }
      var lerpValue = (nextValue - _pageController.page).abs();
      var currentColor = Data().slideDatas[prevValue.toInt()].pageColor;
      var nextColor = Data().slideDatas[nextValue.toInt()].pageColor;
      setState(() {
        _pageColor = Color.lerp(nextColor, currentColor, lerpValue);
      });
      _movePages(_pageController.page);
      _prevPageValue = _pageController.page;
    });
    _movePages(_initialPage.toDouble());
    super.initState();
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
  void _movePages(double pageValue) {

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

  List<Widget> _getThumbs() {

    var thumbWidth = 45.0;
    var thumbPadding = 10.0;
    var thumbs = <Widget>[];
    for (var i = 0; i < 10; i++) {
      var left = i * (thumbWidth + (thumbPadding * 2));
      thumbs.add(Positioned(

        left: left,
        child: Padding(
          padding: EdgeInsets.all(thumbPadding),
          child: Container(
            width: thumbWidth,
            height: 70,
            color: Colors.white,
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
                  // нижний ряд эскизов

                  Expanded(
                    child: Container(
                      width: double.infinity,
                      color: Colors.red,
                      child: Stack(
                        children: _getThumbs(),
                      ),
                    ),
                  )
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

