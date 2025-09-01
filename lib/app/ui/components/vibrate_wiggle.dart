import 'package:flutter/material.dart';

/// A widget that applies a short "vibration-like" wiggle animation
/// to its child when [trigger] is set to true.
///
/// The wiggle runs **once per trigger** and simulates a jittery
/// horizontal shake, useful for drawing attention (e.g. validation errors).
class VibrateWiggle extends StatefulWidget {
  /// Creates a [VibrateWiggle] widget.
  const VibrateWiggle({
    required this.trigger,
    required this.child,
    this.wiggleDuration,
    super.key,
  });

  /// When set to true, triggers the wiggle animation once.
  final bool trigger;

  /// The widget to apply the wiggle effect on.
  final Widget child;

  /// Duration of the wiggle animation in milliseconds.
  final int? wiggleDuration;

  @override
  State<VibrateWiggle> createState() => _VibrateWiggleState();
}

class _VibrateWiggleState extends State<VibrateWiggle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  /// Tracks the last time the wiggle was played.
  DateTime? _lastWiggleTime;

  /// Minimum gap between wiggles.
  static const Duration _cooldown = Duration(seconds: 10);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.wiggleDuration ?? 1000),
    );

    _animation = TweenSequence<double>([
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0, end: -10),
        weight: 1,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: -10, end: 10),
        weight: 2,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 10, end: -8),
        weight: 2,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: -8, end: 8),
        weight: 2,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 8, end: -6),
        weight: 2,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: -6, end: 6),
        weight: 2,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 6, end: -3),
        weight: 1,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: -3, end: 3),
        weight: 1,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 3, end: 0),
        weight: 1,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubic,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant VibrateWiggle oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.trigger && !_controller.isAnimating) {
      final now = DateTime.now();
      final canWiggle = _lastWiggleTime == null ||
          now.difference(_lastWiggleTime!) >= _cooldown;

      if (canWiggle) {
        _controller.forward(from: 0);
        _lastWiggleTime = now;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _animation,
        builder: (BuildContext context, Widget? child) => Transform.translate(
          offset: Offset(_animation.value, 0),
          child: child,
        ),
        child: widget.child,
      );
}
