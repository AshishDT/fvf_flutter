import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// A widget that plays a Lottie animation and then shows a child widget.
class LottieThenChild extends StatelessWidget {
  /// Constructor
  const LottieThenChild({
    required this.lottiePath,
    required this.child,
    super.key,
  });

  /// Lottie animation path
  final String lottiePath;

  /// Child widget to display after the animation
  final Widget child;

  /// Play the Lottie animation and wait for its duration
  Future<void> _playLottie() async {
    final LottieComposition composition = await AssetLottie(lottiePath).load();
    await Future<void>.delayed(composition.duration);
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<void>(
        future: _playLottie(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          final bool isDone = snapshot.connectionState == ConnectionState.done;

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 600),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            transitionBuilder: (Widget child, Animation<double> animation) =>
                ScaleTransition(
              scale: Tween<double>(begin: 0.95, end: 1).animate(animation),
              child: FadeTransition(opacity: animation, child: child),
            ),
            child: isDone
                ? child
                : Lottie.asset(
                    lottiePath,
                    repeat: false,
                    key: const ValueKey<String>('lottie'),
                  ),
          );
        },
      );
}
