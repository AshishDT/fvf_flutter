import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';

/// Gradient Card widget
class GradientCard extends StatelessWidget {
  /// Creates a [GradientCard] widget.
  const GradientCard({
    required this.child,
    super.key,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.alignment,
    this.constraints,
  });

  /// Optional height of the card.
  final double? height;

  /// Optional width of the card.
  final double? width;

  /// The child widget to display inside the card.
  final Widget child;

  /// Margin around the card.
  final EdgeInsetsGeometry? margin;

  /// Padding inside the card.
  final EdgeInsetsGeometry? padding;

  /// Optional alignment for the card.
  final AlignmentGeometry? alignment;

  /// Optional constraints for the card.
  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) => Container(
        width: width ?? 1.sw,
        height: height ?? 1.sh,
        margin: margin ?? EdgeInsets.zero,
        padding: padding ?? EdgeInsets.zero,
        alignment: alignment ?? Alignment.center,
        constraints: constraints,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.gradientCardBg),
            fit: BoxFit.cover,
          ),
        ),
        child: child,
      );
}
