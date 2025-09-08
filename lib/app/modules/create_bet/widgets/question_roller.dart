import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:gif/gif.dart';

import '../../../utils/app_utils.dart';

/// Question Roller Widget
class QuestionRoller extends StatefulWidget {
  /// Constructor
  const QuestionRoller({
    required this.rollTrigger,
    required this.onTap,
    super.key,
  });

  /// Roll trigger to start the animation
  final int rollTrigger;

  /// On tap callback
  final VoidCallback onTap;

  @override
  State<QuestionRoller> createState() => _QuestionRollerState();
}

class _QuestionRollerState extends State<QuestionRoller>
    with TickerProviderStateMixin {
  late GifController _gifController;

  @override
  void initState() {
    super.initState();
    _gifController = GifController(vsync: this);
  }

  @override
  void didUpdateWidget(covariant QuestionRoller oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.rollTrigger != oldWidget.rollTrigger) {
      _gifController.value = 0;
      _gifController.animateTo(
        1,
        duration: const Duration(milliseconds: 800),
      );
    }
  }

  @override
  void dispose() {
    _gifController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          lightHapticFeedback();
          widget.onTap.call();
        },
        child: Container(
          height: 48.h,
          width: 48.w,
          decoration: BoxDecoration(
            color: AppColors.kF1F2F2.withValues(alpha: 0.36),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Gif(
              controller: _gifController,
              image: const AssetImage(AppImages.questionGif),
              height: 44.h,
              width: 44.w,
            ),
          ),
        ),
      );
}
