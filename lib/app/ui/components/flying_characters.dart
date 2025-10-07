import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// FlyingCharacters
/// - Animates each grapheme (emoji-safe) from a random offset into place with fade-in.
/// - Staggers entries across the string for a flowing “flying” effect. [web:1]
class FlyingCharacters extends StatefulWidget {
  /// Constructor
  const FlyingCharacters({
    required this.text,
    super.key,
    this.style,
    this.duration = const Duration(milliseconds: 700),
    this.perItemDelay = const Duration(milliseconds: 40),
    this.curve = Curves.easeOutCubic,
    this.randomDirections = true,
    this.maxStartOffset = 32,
    this.loop = false,
    this.startDelay,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.textScaleFactor,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
    this.randomSeed = 7,
  });

  /// Texts to animate
  final String text;

  /// Text style
  final TextStyle? style;

  /// Duration of the animation for each character
  final Duration duration;

  /// Delay between each character's animation start
  final Duration perItemDelay;

  /// Animation curve
  final Curve curve;

  /// Whether to use random directions for the initial offset
  final bool randomDirections;

  /// Maximum starting offset distance
  final double maxStartOffset;

  /// Whether to loop the animation
  final bool loop;

  /// Optional delay before starting the animation
  final Duration? startDelay;

  /// Text alignment
  final TextAlign textAlign;

  /// Text direction
  final TextDirection? textDirection;

  /// Text scale factor
  final double? textScaleFactor;

  /// Maximum number of lines
  final int? maxLines;

  /// Text overflow behavior
  final TextOverflow overflow;

  /// Random seed for reproducibility
  final int randomSeed;

  @override
  State<FlyingCharacters> createState() => _FlyingCharactersState();
}

class _FlyingCharactersState extends State<FlyingCharacters>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_GlyphAnim> _items;
  late Characters _clusters;

  @override
  void initState() {
    super.initState();
    _clusters = widget.text.characters;
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration + _totalStagger(),
    );
    _items = _buildAnimations(_controller);

    if (widget.startDelay != null && widget.startDelay!.inMilliseconds > 0) {
      Future<void>.delayed(widget.startDelay!, _start);
    } else {
      _start();
    }

    if (widget.loop) {
      _controller.addStatusListener(
        (AnimationStatus s) {
          if (s == AnimationStatus.completed) {
            _controller.reverse();
          } else if (s == AnimationStatus.dismissed) {
            _controller.forward();
          }
        },
      );
    }
  }

  Duration _totalStagger() {
    final int count = _clusters.length;
    if (count == 0) {
      return Duration.zero;
    }
    return widget.perItemDelay * (count - 1);
  }

  void _start() {
    if (mounted) {
      _controller.forward(from: 0);
    }
  }

  List<_GlyphAnim> _buildAnimations(AnimationController controller) {
    final Random rng = Random(widget.randomSeed);
    final List<String> graphemes = _clusters.toList();
    final int total = graphemes.length;
    final int perDelayMs = widget.perItemDelay.inMilliseconds;
    final int baseMs = widget.duration.inMilliseconds;
    final int fullMs = baseMs + perDelayMs * (total - 1);

    return List<_GlyphAnim>.generate(total, (int i) {
      final int startMs = i * perDelayMs;
      final int endMs = startMs + baseMs;
      final double begin = (startMs / fullMs).clamp(0.0, 1.0);
      final double end = (endMs / fullMs).clamp(0.0, 1.0);

      final CurvedAnimation curved = CurvedAnimation(
        parent: controller,
        curve: Interval(begin, end, curve: widget.curve),
      );

      Offset initial;
      if (widget.randomDirections) {
        final double angle = rng.nextDouble() * 2 * pi;
        final double radius = rng.nextDouble() * widget.maxStartOffset;
        initial = Offset(cos(angle) * radius, sin(angle) * radius);
      } else {
        initial = Offset(widget.maxStartOffset * 0.5, widget.maxStartOffset);
      }

      return _GlyphAnim(
        text: graphemes[i],
        animation: curved,
        initialOffset: initial,
      );
    });
  }

  @override
  void didUpdateWidget(covariant FlyingCharacters oldWidget) {
    super.didUpdateWidget(oldWidget);

    final bool timingChanged = oldWidget.duration != widget.duration ||
        oldWidget.perItemDelay != widget.perItemDelay ||
        oldWidget.curve != widget.curve;

    final bool textOrRandChanged = oldWidget.text != widget.text ||
        oldWidget.randomDirections != widget.randomDirections ||
        oldWidget.maxStartOffset != widget.maxStartOffset ||
        oldWidget.randomSeed != widget.randomSeed;

    if (timingChanged || textOrRandChanged) {
      _clusters = widget.text.characters;
      _controller.duration = widget.duration + _totalStagger();
      _items = _buildAnimations(_controller);
      _start();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle baseStyle =
        DefaultTextStyle.of(context).style.merge(widget.style);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double fontSize = baseStyle.fontSize ?? 14.sp;
         final double minFontSize = 14.sp;

        final TextPainter tp = TextPainter(
          text: TextSpan(
            text: widget.text,
            style: baseStyle,
          ),
          maxLines: widget.maxLines ?? 2,
          textDirection: widget.textDirection ?? TextDirection.ltr,
        );

        while (fontSize > minFontSize) {
          tp
            ..text = TextSpan(
              text: widget.text,
              style: baseStyle.copyWith(fontSize: fontSize),
            )
            ..layout(maxWidth: constraints.maxWidth);
          if (tp.didExceedMaxLines) {
            fontSize -= 1;
          } else {
            break;
          }
        }

        final List<WidgetSpan> spans = _items
            .map(
              (_GlyphAnim item) => WidgetSpan(
                baseline: TextBaseline.alphabetic,
                alignment: PlaceholderAlignment.baseline,
                child: AnimatedBuilder(
                  animation: item.animation,
                  builder: (BuildContext context, _) {
                    final double t = item.animation.value;
                    final double opacity = t;
                    final Offset offset =
                        Offset.lerp(item.initialOffset, Offset.zero, t)!;
                    return Opacity(
                      opacity: opacity,
                      child: Transform.translate(
                        offset: offset,
                        child: Text(
                          item.text,
                          style: baseStyle.copyWith(fontSize: fontSize),
                          textScaler: TextScaler.linear(
                            widget.textScaleFactor ?? 1.0,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
            .toList();

        return RichText(
          textAlign: widget.textAlign,
          textDirection: widget.textDirection,
          maxLines: widget.maxLines ?? 2,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            style: baseStyle.copyWith(fontSize: fontSize),
            children: spans,
          ),
        );
      },
    );
  }
}

/// Internal class to hold animation info for each grapheme
class _GlyphAnim {
  /// Constructor
  _GlyphAnim({
    required this.text,
    required this.animation,
    required this.initialOffset,
  });

  /// Text
  final String text;

  /// Animation
  final Animation<double> animation;

  /// Initial offset
  final Offset initialOffset;
}
