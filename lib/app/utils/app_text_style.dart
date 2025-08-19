import 'package:flutter/material.dart';

/// Flexible text style utility using OpenRunde font
class AppTextStyle {
  static const String _fontFamily = 'OpenRunde';

  /// Returns a [OpenRunde] with the OpenRunde font family and customizable properties.
  static TextStyle openRunde({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color? color,
    double? letterSpacing,
    double? height,
    FontStyle? fontStyle,
    TextDecoration? decoration,
    TextOverflow? overflow,
  }) =>
      TextStyle(
        fontFamily: _fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
        height: height,
        fontStyle: fontStyle,
        decoration: decoration,
        overflow: overflow,
      );
}
