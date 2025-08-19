import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

/// Animated column widget that animates its children with a staggered animation effect.
class AnimatedColumn extends StatelessWidget {
  /// Creates an [AnimatedColumn] widget.
  const AnimatedColumn({
    required this.children,
    super.key,
    this.duration = const Duration(milliseconds: 300),
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.spacing = 0.0,
    this.textBaseline,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.showSlideTransition,
  });

  /// Children of the animated column.
  final List<Widget> children;

  /// Duration of the animation.
  final Duration duration;

  /// Main axis alignment of the column.
  final MainAxisAlignment mainAxisAlignment;

  /// Cross axis alignment of the column.
  final CrossAxisAlignment crossAxisAlignment;

  /// Main axis size of the column.
  final MainAxisSize mainAxisSize;

  /// Spacing between the children of the column.
  final double spacing;

  /// Text baseline for the column.
  final TextBaseline? textBaseline;

  /// Text direction for the column.
  final TextDirection? textDirection;

  /// Vertical direction of the column.
  final VerticalDirection verticalDirection;

  /// Slide transition effect.
  final bool? showSlideTransition;

  @override
  Widget build(BuildContext context) => AnimationLimiter(
        child: Column(
          mainAxisSize: mainAxisSize,
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          spacing: spacing,
          textBaseline: textBaseline,
          textDirection: textDirection,
          verticalDirection: verticalDirection,
          children: AnimationConfiguration.toStaggeredList(
            duration: duration,
            childAnimationBuilder: (Widget widget) {
              if (widget is Spacer ||
                  widget is Flexible ||
                  widget is Expanded ||
                  widget is Positioned) {
                return widget;
              }

              if (showSlideTransition ?? false) {
                return SlideAnimation(
                  horizontalOffset: 50,
                  child: FadeInAnimation(
                    child: widget,
                  ),
                );
              }

              return ScaleAnimation(
                scale: 0.9,
                curve: Curves.easeOutCubic,
                child: FadeInAnimation(
                  child: widget,
                ),
              );
            },
            children: children,
          ),
        ),
      );
}
