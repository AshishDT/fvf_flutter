import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:lottie/lottie.dart';

/// Dice Roller Widget
class DiceRoller extends StatefulWidget {
  /// Constructor
  const DiceRoller({
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
  State<DiceRoller> createState() => _DiceRollerState();
}

class _DiceRollerState extends State<DiceRoller>
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
  void didUpdateWidget(covariant DiceRoller oldWidget) {
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
  Widget build(BuildContext context) => Stack(
    alignment: Alignment.center,
    children: <Widget>[
      Positioned(
        bottom: 0,
        right: 0,
        left: 0,
        top: 0,
        child: Container(
          decoration:  BoxDecoration(
            color: AppColors.kF1F2F2.withValues(alpha: 0.36),
            shape: BoxShape.circle,
          ),
        ),
      ),
      Padding(
        padding: REdgeInsets.only(bottom: 17),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Lottie.asset(
            AppImages.diceRoll,
            fit: BoxFit.contain,
            repeat: widget.isLoading,
            controller: _controller,
            onLoaded: (LottieComposition composition) {
              _controller.duration = const Duration(milliseconds: 200);
              _controller.value = 0.0;
            },
          ),
        ),
      ),
    ],
  );
}
