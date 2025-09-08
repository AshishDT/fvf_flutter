import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

/// A widget that plays a sequence of two Lottie animations:
class LottieSequence extends StatelessWidget {
  /// LottieSequence constructor
  const LottieSequence({
    required this.firstLottie,
    required this.loopLottie,
    super.key,
    this.height,
    this.width,
    this.transitionDuration = const Duration(milliseconds: 600),
  });

  /// First Lottie animation asset path
  final String firstLottie;

  /// Looping Lottie animation asset path
  final String loopLottie;

  /// Duration of the transition between animations
  final Duration transitionDuration;

  /// Height of the Lottie animation
  final double? height;

  /// Width of the Lottie animation
  final double? width;

  /// Plays the first Lottie animation and waits for its duration
  Future<void> _playFirstLottie() async {
    final LottieComposition composition = await AssetLottie(firstLottie).load();
    await Future<void>.delayed(composition.duration);
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<void>(
        future: _playFirstLottie(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          final bool isFirstDone =
              snapshot.connectionState == ConnectionState.done;

          return AnimatedSwitcher(
            duration: transitionDuration,
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            transitionBuilder: (Widget child, Animation<double> animation) =>
                ScaleTransition(
              scale: Tween<double>(begin: 0.95, end: 1).animate(animation),
              child: FadeTransition(opacity: animation, child: child),
            ),
            child: isFirstDone
                ? Lottie.asset(
                    height: height ?? 200.h,
                    width: width ?? 200.w,
                    loopLottie,
                    repeat: true,
                    key: const ValueKey<String>('loop'),
                  )
                : Lottie.asset(
                    height: height ?? 200.h,
                    width: width ?? 200.w,
                    firstLottie,
                    repeat: false,
                    key: const ValueKey<String>('first'),
                  ),
          );
        },
      );
}
