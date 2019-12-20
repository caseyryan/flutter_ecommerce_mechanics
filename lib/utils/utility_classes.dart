import 'package:flutter/material.dart';



class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class ShadowPainter extends CustomPainter {

  final double opacity;

  ShadowPainter([this.opacity = 1.0]);

  @override
  void paint(Canvas canvas, Size size) {
    var sideOffset = size.width * .12;
    canvas.drawPath(
        Path()
          ..addRect(
              Rect.fromPoints(
                  Offset(sideOffset, sideOffset),
                  Offset(size.width - sideOffset, size.height - sideOffset * .55)
              ))
          ..fillType = PathFillType.nonZero,
        Paint()
          ..color=  Colors.black.withOpacity(opacity)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, convertRadiusToSigma(18))
    );
  }
  static double convertRadiusToSigma(double radius) {
    return radius * 0.57735 + 0.5;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}


class HeroRectTween extends RectTween {
  HeroRectTween({this.begin, this.end}) : super(begin: begin, end: end);
  final Rect begin;
  final Rect end;

  @override
  Rect lerp(double t) {
    t = Curves.easeInQuart.transform(t);

    return Rect.fromLTRB(
      lerpDouble(begin.left, end.left, t),
      lerpDouble(begin.top, end.top, t),
      lerpDouble(begin.right, end.right, t),
      lerpDouble(begin.bottom, end.bottom, t),
    );
  }

  double lerpDouble(num a, num b, double t) {
    if (a == null && b == null) return null;
    a ??= 0.0;
    b ??= 0.0;
    return a + (b - a) * t;
  }
}
