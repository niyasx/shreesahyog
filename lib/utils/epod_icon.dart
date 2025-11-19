import 'package:flutter/cupertino.dart';

class EpodIcon extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    final Paint paint = Paint();

    // Path 1 Fill
    paint.color = const Color(0xff09121F);
    path.moveTo(size.width * 0.08, size.height * 0.17);
    path.cubicTo(size.width * 0.08, size.height * 0.14, size.width * 0.1,
        size.height * 0.13, size.width * 0.13, size.height * 0.13);
    path.lineTo(size.width * 0.88, size.height * 0.13);
    path.cubicTo(size.width * 0.9, size.height * 0.13, size.width * 0.92,
        size.height * 0.14, size.width * 0.92, size.height * 0.17);
    path.lineTo(size.width * 0.92, size.height * 0.4);
    path.cubicTo(size.width * 0.84, size.height * 0.4, size.width * 0.79,
        size.height * 0.48, size.width * 0.83, size.height * 0.55);
    path.cubicTo(size.width * 0.85, size.height * 0.58, size.width * 0.88,
        size.height * 0.6, size.width * 0.92, size.height * 0.6);
    path.lineTo(size.width * 0.92, size.height * 0.83);
    path.cubicTo(size.width * 0.92, size.height * 0.86, size.width * 0.9,
        size.height * 0.87, size.width * 0.88, size.height * 0.88);
    path.lineTo(size.width * 0.13, size.height * 0.88);
    path.cubicTo(size.width * 0.1, size.height * 0.88, size.width * 0.08,
        size.height * 0.86, size.width * 0.08, size.height * 0.83);
    path.lineTo(size.width * 0.08, size.height * 0.17);
    path.lineTo(size.width * 0.08, size.height * 0.17);
    path.moveTo(size.width * 0.34, size.height * 0.79);
    path.cubicTo(size.width * 0.35, size.height * 0.75, size.width * 0.41,
        size.height * 0.74, size.width * 0.44, size.height * 0.77);
    path.cubicTo(size.width * 0.45, size.height * 0.78, size.width * 0.45,
        size.height * 0.78, size.width * 0.45, size.height * 0.79);
    path.lineTo(size.width * 0.83, size.height * 0.79);
    path.lineTo(size.width * 0.83, size.height * 0.67);
    path.cubicTo(size.width * 0.7, size.height * 0.6, size.width * 0.69,
        size.height * 0.42, size.width * 0.81, size.height * 0.34);
    path.cubicTo(size.width * 0.82, size.height * 0.34, size.width * 0.83,
        size.height * 0.34, size.width * 0.83, size.height * 0.33);
    path.lineTo(size.width * 0.83, size.height * 0.21);
    path.lineTo(size.width * 0.45, size.height * 0.21);
    path.cubicTo(size.width * 0.44, size.height * 0.25, size.width * 0.38,
        size.height * 0.26, size.width * 0.35, size.height * 0.23);
    path.cubicTo(size.width * 0.34, size.height * 0.22, size.width * 0.34,
        size.height * 0.22, size.width * 0.34, size.height * 0.21);
    path.lineTo(size.width * 0.17, size.height * 0.21);
    path.lineTo(size.width * 0.17, size.height * 0.79);
    path.lineTo(size.width * 0.34, size.height * 0.79);
    path.lineTo(size.width * 0.34, size.height * 0.79);
    path.moveTo(size.width * 0.4, size.height * 0.46);
    path.cubicTo(size.width * 0.35, size.height * 0.46, size.width * 0.32,
        size.height * 0.41, size.width * 0.34, size.height * 0.36);
    path.cubicTo(size.width * 0.35, size.height * 0.35, size.width * 0.37,
        size.height * 0.33, size.width * 0.4, size.height * 0.33);
    path.cubicTo(size.width * 0.44, size.height * 0.33, size.width * 0.47,
        size.height * 0.39, size.width * 0.45, size.height * 0.43);
    path.cubicTo(size.width * 0.44, size.height * 0.45, size.width * 0.42,
        size.height * 0.46, size.width * 0.4, size.height * 0.46);
    path.lineTo(size.width * 0.4, size.height * 0.46);
    path.moveTo(size.width * 0.4, size.height * 0.67);
    path.cubicTo(size.width * 0.35, size.height * 0.67, size.width * 0.32,
        size.height * 0.61, size.width * 0.34, size.height * 0.57);
    path.cubicTo(size.width * 0.35, size.height * 0.55, size.width * 0.37,
        size.height * 0.54, size.width * 0.4, size.height * 0.54);
    path.cubicTo(size.width * 0.44, size.height * 0.54, size.width * 0.47,
        size.height * 0.59, size.width * 0.45, size.height * 0.64);
    path.cubicTo(size.width * 0.44, size.height * 0.65, size.width * 0.42,
        size.height * 0.67, size.width * 0.4, size.height * 0.67);
    path.lineTo(size.width * 0.4, size.height * 0.67);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
