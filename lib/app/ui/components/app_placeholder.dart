import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// App Loading placeholder
class AppPlaceHolder extends StatelessWidget {
  /// App Loading placeholder constructor
  const AppPlaceHolder({
    required this.isLoading,
    required this.child,
    required this.placeHolder,
    this.padding,
    this.baseColor,
    this.highlightColor,
    Key? key,
  }) : super(key: key);

  /// Is loading
  final bool isLoading;

  /// Child
  final Widget child;

  /// Loader
  final Widget placeHolder;

  /// Padding
  final EdgeInsets? padding;

  /// Base color
  final Color? baseColor;

  /// Highlight color
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Shimmer.fromColors(
          baseColor: baseColor ?? const Color(0xFF6C75FF).withValues(alpha: 0.3),
          highlightColor: highlightColor ?? const Color(0xFFFB46CD).withValues(alpha: 0.4),
          child: placeHolder,
        ),
      );
    }
    return child;
  }
}
