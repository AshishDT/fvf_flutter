import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';

/// Animated Switcher widget
class AnimatedTextSwitcher extends StatelessWidget {
  /// Creates a new instance of AnimatedSwitcher.
  const AnimatedTextSwitcher({
    required this.currentIndex,
    required this.texts,
    super.key,
  });

  /// Current index of the text to display.
  final int currentIndex;

  /// List of texts to switch between.
  final List<String> texts;

  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        transitionBuilder: (Widget child, Animation<double> animation) =>
            FadeTransition(
          opacity: animation,
          child: child,
        ),
        child: AutoSizeText(
          texts[currentIndex],
          key: ValueKey<int>(currentIndex),
          textAlign: TextAlign.center,
          style: AppTextStyle.openRunde(
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.kffffff,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
}
