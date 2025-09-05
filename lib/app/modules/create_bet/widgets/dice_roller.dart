import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';

/// Question Roller Widget
class QuestionRoller extends StatefulWidget {
  /// Question Roller Widget Constructor
  const QuestionRoller({
    required this.rollTrigger,
    required this.onTap,
    this.isLoading = false,
    super.key,
  });

  /// Whenever this int changes, dice will roll
  final int rollTrigger;

  /// Callback when the dice is tapped
  final VoidCallback onTap;

  /// Is loading
  final bool isLoading;

  @override
  State<QuestionRoller> createState() => _QuestionRollerState();
}

class _QuestionRollerState extends State<QuestionRoller>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      reverseDuration: const Duration(milliseconds: 200),
    );
  }

  @override
  void didUpdateWidget(covariant QuestionRoller oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.rollTrigger != oldWidget.rollTrigger) {
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
        height: 48.h,
        width: 48.w,
        decoration: BoxDecoration(
          color: AppColors.kF1F2F2.withValues(alpha: 0.36),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Image(
            height: 38.h,
            width: 38.w,
            image: const AssetImage(
              AppImages.questionIcon,
            ),
          ),
        ),
      );
}
