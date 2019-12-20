import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {

  EdgeInsets _padding = EdgeInsets.symmetric(vertical: 20.0, horizontal: 5);

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 70,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: <Widget>[
            Padding(
              padding: _padding,
              child: Icon(Icons.arrow_back, color: Colors.white, size: 30,),
            ),
            Expanded(child: Container(),),
            Padding(
              padding: _padding,
              child: Icon(Icons.add_shopping_cart, color: Colors.white, size: 25,),
            ),
            Padding(
              padding: _padding,
              child: Icon(Icons.filter_none, color: Colors.white, size: 25,),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(70);
}
