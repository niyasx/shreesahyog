import 'package:flutter/material.dart';

class FreightBillIcon extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    final Paint paint = Paint();

    // Path 1 Fill
    paint.color = const Color(0xff09121F);
    path.moveTo(size.width * 0.83, size.height * 0.92);
    path.lineTo(size.width * 0.17, size.height * 0.92);
    path.cubicTo(size.width * 0.14, size.height * 0.92, size.width * 0.13,
        size.height * 0.9, size.width * 0.13, size.height * 0.88);
    path.lineTo(size.width * 0.13, size.height * 0.13);
    path.cubicTo(size.width * 0.13, size.height * 0.1, size.width * 0.14,
        size.height * 0.08, size.width * 0.17, size.height * 0.08);
    path.lineTo(size.width * 0.83, size.height * 0.08);
    path.cubicTo(size.width * 0.86, size.height * 0.08, size.width * 0.88,
        size.height * 0.1, size.width * 0.88, size.height * 0.13);
    path.lineTo(size.width * 0.88, size.height * 0.88);
    path.cubicTo(size.width * 0.88, size.height * 0.9, size.width * 0.86,
        size.height * 0.92, size.width * 0.83, size.height * 0.92);
    path.lineTo(size.width * 0.83, size.height * 0.92);
    path.moveTo(size.width * 0.79, size.height * 0.83);
    path.lineTo(size.width * 0.79, size.height * 0.17);
    path.lineTo(size.width * 0.21, size.height * 0.17);
    path.lineTo(size.width * 0.21, size.height * 0.83);
    path.lineTo(size.width * 0.79, size.height * 0.83);
    path.lineTo(size.width * 0.79, size.height * 0.83);
    path.moveTo(size.width * 0.33, size.height * 0.38);
    path.lineTo(size.width * 0.67, size.height * 0.38);
    path.lineTo(size.width * 0.67, size.height * 0.46);
    path.lineTo(size.width * 0.33, size.height * 0.46);
    path.lineTo(size.width * 0.33, size.height * 0.38);
    path.lineTo(size.width * 0.33, size.height * 0.38);
    path.moveTo(size.width * 0.33, size.height * 0.54);
    path.lineTo(size.width * 0.67, size.height * 0.54);
    path.lineTo(size.width * 0.67, size.height * 0.63);
    path.lineTo(size.width * 0.33, size.height * 0.63);
    path.lineTo(size.width * 0.33, size.height * 0.54);
    path.lineTo(size.width * 0.33, size.height * 0.54);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class FreightBillIconWhite extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    final Paint paint = Paint();

    // Path 1 Fill
    paint.color = Colors.white;
    path.moveTo(size.width * 0.83, size.height * 0.92);
    path.lineTo(size.width * 0.17, size.height * 0.92);
    path.cubicTo(size.width * 0.14, size.height * 0.92, size.width * 0.13,
        size.height * 0.9, size.width * 0.13, size.height * 0.88);
    path.lineTo(size.width * 0.13, size.height * 0.13);
    path.cubicTo(size.width * 0.13, size.height * 0.1, size.width * 0.14,
        size.height * 0.08, size.width * 0.17, size.height * 0.08);
    path.lineTo(size.width * 0.83, size.height * 0.08);
    path.cubicTo(size.width * 0.86, size.height * 0.08, size.width * 0.88,
        size.height * 0.1, size.width * 0.88, size.height * 0.13);
    path.lineTo(size.width * 0.88, size.height * 0.88);
    path.cubicTo(size.width * 0.88, size.height * 0.9, size.width * 0.86,
        size.height * 0.92, size.width * 0.83, size.height * 0.92);
    path.lineTo(size.width * 0.83, size.height * 0.92);
    path.moveTo(size.width * 0.79, size.height * 0.83);
    path.lineTo(size.width * 0.79, size.height * 0.17);
    path.lineTo(size.width * 0.21, size.height * 0.17);
    path.lineTo(size.width * 0.21, size.height * 0.83);
    path.lineTo(size.width * 0.79, size.height * 0.83);
    path.lineTo(size.width * 0.79, size.height * 0.83);
    path.moveTo(size.width * 0.33, size.height * 0.38);
    path.lineTo(size.width * 0.67, size.height * 0.38);
    path.lineTo(size.width * 0.67, size.height * 0.46);
    path.lineTo(size.width * 0.33, size.height * 0.46);
    path.lineTo(size.width * 0.33, size.height * 0.38);
    path.lineTo(size.width * 0.33, size.height * 0.38);
    path.moveTo(size.width * 0.33, size.height * 0.54);
    path.lineTo(size.width * 0.67, size.height * 0.54);
    path.lineTo(size.width * 0.67, size.height * 0.63);
    path.lineTo(size.width * 0.33, size.height * 0.63);
    path.lineTo(size.width * 0.33, size.height * 0.54);
    path.lineTo(size.width * 0.33, size.height * 0.54);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}



class LinkIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.1 // Adjusts the thickness relative to the size
      ..strokeCap = StrokeCap.round;

    // Drawing the top-right arc
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width * 0.7, size.height * 0.3), radius: size.width * 0.2),
      3.9, // Start angle (radians)
      2.8, // Sweep angle (radians)
      false,
      paint,
    );

    // Drawing the bottom-left arc
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width * 0.3, size.height * 0.7), radius: size.width * 0.2),
      0.7, // Start angle (radians)
      2.8, // Sweep angle (radians)
      false,
      paint,
    );

    // Drawing the connecting lines
    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.4),
      Offset(size.width * 0.6, size.height * 0.5),
      paint,
    );

    canvas.drawLine(
      Offset(size.width * 0.4, size.height * 0.6),
      Offset(size.width * 0.5, size.height * 0.5),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
