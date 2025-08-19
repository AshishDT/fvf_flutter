import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../data/config/app_colors.dart';

/// Extension for widget
const ColorFilter _grey = ColorFilter.matrix(<double>[
  ...<double>[0.2126, 0.7152, 0.0722, 0, 0],
  ...<double>[0.2126, 0.7152, 0.0722, 0, 0],
  ...<double>[0.2126, 0.7152, 0.0722, 0, 0],
  ...<double>[0, 0, 0, 1, 0],
]);

/// Identity color filter
const ColorFilter _identity = ColorFilter.matrix(
  <double>[
    ...<double>[1, 0, 0, 0, 0, 0, 1, 0, 0, 0],
    ...<double>[0, 0, 1, 0, 0, 0, 0, 0, 1, 0],
  ],
);

/// Extension for widget
extension WidgetExt on Widget {
  /// Adds padding to the widget
  Widget greyScale({bool greyScale = true}) => ColorFiltered(
        colorFilter: greyScale ? _grey : _identity,
        child: Opacity(
          opacity: greyScale ? 0.7 : 1,
          child: this,
        ),
      );

  /// Adds padding to the widget
  Widget opacity({double opacity = 0.7}) => AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: opacity,
        child: this,
      );

  /// Creates any widget into a zoomable widget
  Widget zoomable({
    TransformationController? zoomCtrl,
    bool enabled = true,
  }) =>
      enabled
          ? InteractiveViewer(
              transformationController: zoomCtrl,
              onInteractionStart: (ScaleStartDetails details) {},
              onInteractionEnd: (ScaleEndDetails details) {
                // vibrate();
                zoomCtrl?.value = Matrix4.identity();
              },
              child: this,
            )
          : this;

  /// Animate
  Widget animate({
    int? position,
    double verticalOffset = 20,
    double horizontalOffset = 0,
    bool limiter = false,
    Duration? delay,
  }) {
    if (this is ListView || limiter) {
      return AnimationLimiter(child: this);
    }
    if (position == null) {
      return this;
    }
    return AnimationConfiguration.staggeredList(
      position: position,
      delay: delay,
      duration: const Duration(milliseconds: 300),
      child: SlideAnimation(
        delay: delay,
        verticalOffset: verticalOffset,
        horizontalOffset: horizontalOffset,
        child: FadeInAnimation(
          delay: delay,
          child: this,
        ),
      ),
    );
  }

  /// Wraps the widget with an AnimatedSwitcher for smooth transitions
  Widget withAnimatedSwitcher(
    String keyValue, {
    Duration duration = const Duration(milliseconds: 300),
  }) =>
      AnimatedSwitcher(
        duration: duration,
        transitionBuilder: (Widget child, Animation<double> animation) {
          final CurvedAnimation curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          );

          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(curvedAnimation),
            child: FadeTransition(
              opacity: curvedAnimation,
              child: child,
            ),
          );
        },
        child: KeyedSubtree(
          key: ValueKey<String>(keyValue),
          child: this,
        ),
      );

  /// Wraps the widget with padding to avoid system gesture insets
  Widget withGPad(
    BuildContext context, {
    Color color = AppColors.kffffff,
    BoxDecoration? decoration,
  }) {
    final double bottom = MediaQuery.of(context).systemGestureInsets.bottom;

    return Container(
      padding: EdgeInsets.only(bottom: bottom + 5),
      color: decoration != null ? null : color,
      child: this,
      decoration: decoration,
    );
  }
}
