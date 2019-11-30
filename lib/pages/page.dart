import 'package:flutter/material.dart';
import 'package:flutter_challenge_ecommerce/data/card_data.dart';
import 'package:flutter_challenge_ecommerce/data/data.dart';
import 'package:flutter_challenge_ecommerce/ui/custom_app_bar.dart';

import '../ui/card_view.dart';
import '../utility_classes.dart';

class Page extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> {

  PageController _pageController;
  double _prevPageValue = 0.0;
  Color _pageColor;
  int _initialPage = 0;


  List<CardView> _getCards() {
    var cards = <CardView>[];
    Data().slideDatas.forEach((slideData) {
      cards.add(CardView(slideData, onTap: _onCardTap,));
    });
    return cards;
  }

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
      print('LERP $lerpValue');
      var currentColor = Data().slideDatas[prevValue.toInt()].pageColor;
      var nextColor = Data().slideDatas[nextValue.toInt()].pageColor;
      setState(() {
        _pageColor = Color.lerp(nextColor, currentColor, lerpValue);
      });


      _prevPageValue = _pageController.page;
    });
    super.initState();
  }
  void _onCardTap(CardData slideData) {
    print(slideData.imagePath);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageColor,
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: <Widget>[
                SizedBox(
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
              ],
            )
          ),
          SafeArea(
            child: CustomAppBar()
          ),
        ],
      ),
    );
  }
}

