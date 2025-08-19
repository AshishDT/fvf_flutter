import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

/// AnimatedListView widget that animates its children with a staggered animation effect.
class AnimatedListView extends StatelessWidget {
  /// Creates an [AnimatedListView] widget.
  const AnimatedListView({
    required this.children,
    super.key,
    this.duration = const Duration(milliseconds: 375),
    this.controller,
    this.shrinkWrap = false,
    this.padding,
    this.cacheExtent,
    this.physics = const BouncingScrollPhysics(),
    this.showScaleAnimation,
  });

  /// Children of the animated column.
  final List<Widget> children;

  /// Duration of the animation.
  final Duration duration;

  /// Scroll controller for the list view.
  final ScrollController? controller;

  /// Whether the list view should shrink to fit its children.
  final bool shrinkWrap;

  /// Padding for the list view.
  final EdgeInsetsGeometry? padding;

  /// Cache extent for the list view.
  final double? cacheExtent;

  /// Physics for the list view.
  final ScrollPhysics physics;

  /// Slide transition effect.
  final bool? showScaleAnimation;

  @override
  Widget build(BuildContext context) => AnimationLimiter(
        child: ListView(
          controller: controller,
          shrinkWrap: shrinkWrap,
          padding: padding,
          cacheExtent: cacheExtent,
          physics: physics,
          children: AnimationConfiguration.toStaggeredList(
            duration: duration,
            childAnimationBuilder: (Widget widget) {
              if (widget is Spacer ||
                  widget is Flexible ||
                  widget is Expanded ||
                  widget is Positioned) {
                return widget;
              }
              if (showScaleAnimation ?? false) {
                return ScaleAnimation(
                  scale: 0.9,
                  curve: Curves.easeOutCubic,
                  child: FadeInAnimation(
                    child: widget,
                  ),
                );
              }
              return SlideAnimation(
                horizontalOffset: 30,
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
