import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  Widget build(BuildContext context) => GestureDetector(
        onTap: widget.onTap,
        child: Lottie.asset(
          AppImages.diceRoll,
          height: 100.h,
          repeat: widget.isLoading,
          controller: _controller,
          onLoaded: (LottieComposition composition) {
            _controller.duration = const Duration(milliseconds: 200);
            _controller.value = 0.0;
          },
        ),
      );
}
