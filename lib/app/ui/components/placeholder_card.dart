import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/config/app_colors.dart';

/// Place holder card
class PlaceholderCard extends StatelessWidget {
  /// Place holder
  const PlaceholderCard({
    required this.height,
    required this.width,
    this.radius,
    this.child,
    this.bgColor,
    Key? key,
  }) : super(key: key);

  /// Height of the card
  final double height;

  /// Width of the card
  final double width;

  /// Radius of the card
  final double? radius;

  /// Child widget
  final Widget? child;

  /// bgColor
  final Color? bgColor;

  @override
  Widget build(BuildContext context) => Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
      color: bgColor ?? AppColors.kffffff,
      borderRadius: BorderRadius.circular(radius ?? 24).r,
    ),
    child: child,
  );
}
