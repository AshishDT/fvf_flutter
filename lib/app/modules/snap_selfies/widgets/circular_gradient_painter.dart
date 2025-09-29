import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Circular Gradient Border Painter
class CircularGradientBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double borderWidth = 3;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = (size.width / 2) - borderWidth / 2;

    final Paint shadowPaint = Paint()
      ..color = const Color(0xBF000000)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    canvas.drawCircle(center.translate(0, 1), radius, shadowPaint);

    final Paint borderPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment(-0.7, -1),
        end: Alignment(1, 0.7),
        colors: <Color>[
          Color(0xFFFB46CD),
          Color(0xFF6C75FF),
          Color(0xFF0DBFFF),
        ],
        stops: <double>[0.1407, 0.5635, 1], // CSS stops
      ).createShader(Offset.zero & size)
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    canvas.drawCircle(center, radius, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Circular Gradient Border Painter with Blur Effect
class CircularGradientBorderPainterBlur extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double borderWidth = 3;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = (size.width / 2) - borderWidth / 2;

    // Shadow behind the circle
    final Paint shadowPaint = Paint()
      ..color = const Color(0xBF000000)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    canvas.drawCircle(center.translate(0, 1), radius, shadowPaint);

    // Blurred gradient glow (optional)
    final Paint glowPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment(-0.7, -1),
        end: Alignment(1, 0.7),
        colors: <Color>[
          Color(0xFFFB46CD),
          Color(0xFF6C75FF),
          Color(0xFF0DBFFF),
        ],
        stops: <double>[0.1407, 0.5635, 1],
      ).createShader(Offset.zero & size)
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth * 2.h
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

    canvas.drawCircle(center, radius, glowPaint);

    // Sharp gradient border on top
    final Paint borderPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment(-0.7, -1),
        end: Alignment(1, 0.7),
        colors: <Color>[
          Color(0xFFFB46CD),
          Color(0xFF6C75FF),
          Color(0xFF0DBFFF),
        ],
        stops: <double>[0.1407, 0.5635, 1],
      ).createShader(Offset.zero & size)
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    canvas.drawCircle(center, radius, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
