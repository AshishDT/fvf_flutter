import 'package:flutter/material.dart';

/// Row Moon Clipper
class RowMoonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final double w = size.width;
    final double h = size.height;

    final Path path = Path()
      // Start from top-left
      ..moveTo(0.05 * w, 0.05 * h)

      // Top-left curve (moon bite)
      ..cubicTo(
        0.18 * w,
        0.25 * h,
        0.36 * w,
        0.4 * h,
        0.55 * w,
        0.4 * h,
      )

      // Symmetrical bottom-right curve
      ..cubicTo(
        0.50 * w,
        0.5 * h,
        0.70 * w,
        0.85 * h,
        1.2 * w,
        0.98 * h,
      )

      // Close path
      ..lineTo(w, 0)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..lineTo(0, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
