import 'package:flutter/material.dart';
import 'package:flutter_challenge_ecommerce/custom_app_bar.dart';

import 'card_view.dart';

class Page extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}


class _PageState extends State<Page> {

  PageController _pageController;
  double _prevPageValue = 0.0;
  Color _pageColor;
  int _initialPage = 0;

  List<SlideData> _slideDatas = [
    SlideData(title: 'Michael Kors Hmilton', price: 2188.00, imagePath: 'assets/img/purse1.jpg', pageColor: Color.fromRGBO(255, 187, 137, 1.0)),
    SlideData(title: 'Saint Laurent', price: 1455.00, imagePath: 'assets/img/purse2.jpg', pageColor: Color.fromRGBO(255, 179, 186, 1.0)),
    SlideData(title: 'ZATCHELS', price: 2398.00, imagePath: 'assets/img/purse3.jpg', pageColor: Color.fromRGBO(163, 164, 221, 1.0)),
  ];

  List<CardView> _getCards() {
    var cards = <CardView>[];
    _slideDatas.forEach((slideData) {
      cards.add(CardView(slideData, onTap: _onCardTap,));
    });
    return cards;
  }

  @override
  void initState() {
    _pageColor = _slideDatas[_initialPage].pageColor;
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
      var currentColor = _slideDatas[prevValue.toInt()].pageColor;
      var nextColor = _slideDatas[nextValue.toInt()].pageColor;
      setState(() {
        _pageColor = Color.lerp(nextColor, currentColor, lerpValue);
      });


      _prevPageValue = _pageController.page;
    });
    super.initState();
  }
  void _onCardTap(SlideData slideData) {
    print(slideData.imagePath);
  }
  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
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
                      aspectRatio: 284 / 340,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: ScrollConfiguration(
                          behavior: NoGlowScrollBehavior(),
                          child: PageView(
                            controller: _pageController,
                            children: _getCards(),
                          ),
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

class SlideData {
  final Color pageColor;
  final String imagePath;
  final double price;
  final String title;

  SlideData({this.imagePath, this.title, this.pageColor, this.price});

}

class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}