import 'package:flutter/material.dart';

/// A widget that first rotates its child 360 degrees and then wiggles it horizontally.
class RotateThenWiggle extends StatefulWidget {
  /// Creates a [RotateThenWiggle] widget.
  const RotateThenWiggle({
    required this.trigger,
    required this.child,
    this.duration = 800,
    super.key,
  });

  /// When set to true, triggers the rotate then wiggle animation once.
  final bool trigger;

  /// The widget to apply the rotate and wiggle effect on.
  final Widget child;

  /// Duration of the rotation animation in milliseconds.
  final int duration;

  @override
  State<RotateThenWiggle> createState() => _RotateThenWiggleState();
}

class _RotateThenWiggleState extends State<RotateThenWiggle>
    with TickerProviderStateMixin {
  late final AnimationController _rotationController;
  late final AnimationController _wiggleController;
  late final Animation<double> _rotationAnimation;
  late final Animation<double> _wiggleAnimation;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.duration),
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 2 * 3.1415926).animate(
        CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut));

    _wiggleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _wiggleAnimation = TweenSequence<double>(<TweenSequenceItem<double>>[
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
          tween: Tween<double>(begin: 3, end: 0), weight: 1),
    ]).animate(CurvedAnimation(
        parent: _wiggleController, curve: Curves.easeInOutCubic));

    _rotationController.addStatusListener(
      (AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          _wiggleController.forward(from: 0);
        }
      },
    );
  }

  @override
  void didUpdateWidget(covariant RotateThenWiggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger &&
        !_rotationController.isAnimating &&
        !_wiggleController.isAnimating) {
      _rotationController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _wiggleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: Listenable.merge(
          <Listenable?>[_rotationAnimation, _wiggleAnimation],
        ),
        builder: (BuildContext context, Widget? child) => Transform.rotate(
          angle: _rotationAnimation.value,
          child: Transform.translate(
            offset: Offset(_wiggleAnimation.value, 0),
            child: child,
          ),
        ),
        child: widget.child,
      );
}
