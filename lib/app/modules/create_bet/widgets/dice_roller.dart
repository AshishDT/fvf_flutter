import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';

/// Dice Roller Widget
class DiceRoller extends StatelessWidget {
  /// Constructor
  const DiceRoller({
    required this.turns,
    required this.onTap,
    super.key,
  });

  /// Number of turns (0,1,2,3...)
  final int turns;

  /// Callback when the dice is tapped
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedRotation(
          turns: turns.toDouble(),
          duration: const Duration(seconds: 1),
          child: Image.asset(
            AppImages.dice,
            height: 60.h,
            width: 60.w,
          ),
        ),
      );
}
