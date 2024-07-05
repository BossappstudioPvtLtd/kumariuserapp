
import 'package:flutter/cupertino.dart';

class MyPainter extends CustomPainter {
  final double firstRippleRadius, firstRippleOpacity, firstRippleStrokeWidth;
  final double secondRippleRadius, secondRippleOpacity, secondRippleStrokeWidth;
  final double thirdRippleRadius, thirdRippleOpacity, thirdRippleStrokeWidth;
  final double centerCircleRadius;

  MyPainter(
    this.firstRippleRadius,
    this.firstRippleOpacity,
    this.firstRippleStrokeWidth,
    this.secondRippleRadius,
    this.secondRippleOpacity,
    this.secondRippleStrokeWidth,
    this.thirdRippleRadius,
    this.thirdRippleOpacity,
    this.thirdRippleStrokeWidth,
    this.centerCircleRadius,
  );

  @override
  void paint(Canvas canvas, Size size) {
    Color myColor = const Color(0xff653ff4);

    Paint paint = Paint();
    paint.color = myColor.withOpacity(firstRippleOpacity);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = firstRippleStrokeWidth;
    canvas.drawCircle(Offset.zero, firstRippleRadius, paint);

    paint.color = myColor.withOpacity(secondRippleOpacity);
    paint.strokeWidth = secondRippleStrokeWidth;
    canvas.drawCircle(Offset.zero, secondRippleRadius, paint);

    paint.color = myColor.withOpacity(thirdRippleOpacity);
    paint.strokeWidth = thirdRippleStrokeWidth;
    canvas.drawCircle(Offset.zero, thirdRippleRadius, paint);

    paint.color = myColor;
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(Offset.zero, centerCircleRadius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
