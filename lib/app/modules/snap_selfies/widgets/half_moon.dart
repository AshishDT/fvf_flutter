import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Half Moon Clipper
class HalfMoonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path fullPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Create the moon shape (a full circle we will subtract)
    final Path moonPath = Path()
      ..addOval(Rect.fromCircle(
        center: Offset(size.width, size.height), // Bottom right corner
        radius: 22.r,
      ));

    // Subtract the moon from the rectangle
    return Path.combine(PathOperation.difference, fullPath, moonPath);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
