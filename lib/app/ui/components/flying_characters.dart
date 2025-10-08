import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// FlyingCharacters
/// - Animates each grapheme (emoji-safe) from a random offset into place with fade-in.
/// - Staggers entries across the string for a flowing “flying” effect.
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

  // Word-mode: tokens (words + whitespace/punct) in order
  late List<_Token> _tokens;

  // Animations only for tokens with animate == true (i.e., words)
  late List<_GlyphAnim> _items;

  @override
  void initState() {
    super.initState();

    _tokens = _tokenizeWords(widget.text);
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration + _totalStagger(_animatedCount()),
    );
    _items = _buildAnimations(_controller, _tokens);

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

  Duration _totalStagger(int count) {
    if (count == 0) {
      return Duration.zero;
    }
    return widget.perItemDelay * (count - 1);
  }

  int _animatedCount() => _tokens.where((t) => t.animate).length;

  void _start() {
    if (mounted) {
      _controller.forward(from: 0);
    }
  }

  // Split into tokens preserving spaces/punctuation; mark only words to animate.
  // A "word" here is a maximal run of non-whitespace characters separated by whitespace.
  // Whitespace is preserved as non-animated tokens for natural wrapping.
  List<_Token> _tokenizeWords(String input) {
    final List<_Token> out = <_Token>[];
    final RegExp ws = RegExp(r'\s+'); // one or more whitespace
    int index = 0;

    for (final RegExpMatch m in ws.allMatches(input)) {
      final int start = m.start;
      final int end = m.end;

      if (start > index) {
        // preceding non-whitespace chunk => could contain punctuation stuck to word
        // Split further on word boundaries to keep punctuation adjacent to words non-animated
        final String chunk = input.substring(index, start);
        out.addAll(_splitChunkPreservingPunct(chunk));
      }

      // whitespace token (non-animated)
      out.add(_Token(text: input.substring(start, end), animate: false));
      index = end;
    }

    if (index < input.length) {
      final String tail = input.substring(index);
      out.addAll(_splitChunkPreservingPunct(tail));
    }

    return out;
  }

  // Split a non-whitespace chunk into alternating word/non-word tokens
  // Words (letters/numbers/marks) animate; punctuation stays non-animated.
  List<_Token> _splitChunkPreservingPunct(String chunk) {
    final List<_Token> parts = <_Token>[];
    // Word characters approximated; this is ASCII-centric but keeps behavior simple.
    // Adjust pattern to needs; for broader Unicode word detection, integrate a more advanced tokenizer.
    final RegExp word = RegExp(r'[A-Za-z0-9_]+');
    int i = 0;
    for (final RegExpMatch m in word.allMatches(chunk)) {
      final int s = m.start;
      final int e = m.end;
      if (s > i) {
        parts.add(_Token(text: chunk.substring(i, s), animate: false));
      }
      parts.add(_Token(text: chunk.substring(s, e), animate: true));
      i = e;
    }
    if (i < chunk.length) {
      parts.add(_Token(text: chunk.substring(i), animate: false));
    }
    return parts;
  }

  List<_GlyphAnim> _buildAnimations(
    AnimationController controller,
    List<_Token> tokens,
  ) {
    final Random rng = Random(widget.randomSeed);

    // Build animations only for animated tokens; map back by animated index.
    final List<int> animatedIndices =
        List<int>.generate(tokens.length, (i) => i)
            .where((i) => tokens[i].animate)
            .toList();

    final int total = animatedIndices.length;
    final int perDelayMs = widget.perItemDelay.inMilliseconds;
    final int baseMs = widget.duration.inMilliseconds;
    final int fullMs = total > 0 ? (baseMs + perDelayMs * (total - 1)) : baseMs;

    return List<_GlyphAnim>.generate(total, (int animPos) {
      final int startMs = animPos * perDelayMs;
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

      final int tokenIndex = animatedIndices[animPos];
      return _GlyphAnim(
        text: tokens[tokenIndex].text,
        animation: curved,
        initialOffset: initial,
        tokenIndex: tokenIndex,
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
      _tokens = _tokenizeWords(widget.text);
      _controller.duration = widget.duration + _totalStagger(_animatedCount());
      _items = _buildAnimations(_controller, _tokens);
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

        // Build a map from animated token index -> _GlyphAnim for quick lookup
        final Map<int, _GlyphAnim> animByTokenIndex = <int, _GlyphAnim>{
          for (final _GlyphAnim ga in _items) ga.tokenIndex!: ga
        };

        final List<InlineSpan> spans = <InlineSpan>[];

        for (int i = 0; i < _tokens.length; i++) {
          final _Token tok = _tokens[i];
          final _GlyphAnim? anim = animByTokenIndex[i];

          if (!tok.animate || anim == null) {
            // Static token (spaces, punctuation, etc.)
            spans.add(
              TextSpan(
                text: tok.text,
                style: baseStyle.copyWith(fontSize: fontSize),
              ),
            );
            continue;
          }

          // Animated word token
          spans.add(
            WidgetSpan(
              baseline: TextBaseline.alphabetic,
              alignment: PlaceholderAlignment.baseline,
              child: AnimatedBuilder(
                animation: anim.animation,
                builder: (BuildContext context, _) {
                  final double t = anim.animation.value;
                  final double opacity = t;
                  final Offset offset =
                      Offset.lerp(anim.initialOffset, Offset.zero, t)!;
                  return Opacity(
                    opacity: opacity,
                    child: Transform.translate(
                      offset: offset,
                      child: Text(
                        anim.text,
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
          );
        }

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
    this.tokenIndex,
  });

  /// Text
  final String text;

  /// Animation
  final Animation<double> animation;

  /// Initial offset
  final Offset initialOffset;

  /// Index into _tokens list
  final int? tokenIndex;
}

class _Token {
  _Token({
    required this.text,
    required this.animate,
  });

  /// Text
  final String text;

  /// Whether this token should be animated
  final bool animate;
}
