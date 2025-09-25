import 'dart:async';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/config/app_colors.dart';
import '../../utils/app_text_style.dart';

/// Custom Typewriter Text Widget
class CustomTypewriterText extends StatefulWidget {
  /// Constructor
  const CustomTypewriterText({
    required this.text,
    Key? key,
    this.style,
    this.speed = const Duration(milliseconds: 150),
    this.maxLines = 20,
    this.minFontSize = 12,
    this.repeat = false,
    this.textAlign,
  }) : super(key: key);

  /// Text
  final String text;

  /// Style
  final TextStyle? style;

  /// Speed
  final Duration speed;

  /// Max lines
  final int maxLines;

  /// Min font size
  final double minFontSize;

  /// Repeat
  final bool repeat;

  /// Text align
  final TextAlign? textAlign;

  @override
  State<CustomTypewriterText> createState() => _CustomTypewriterTextState();
}

class _CustomTypewriterTextState extends State<CustomTypewriterText> {
  String _visibleText = '';
  Timer? _timer;
  int _index = 0;
  late List<String> _words;

  @override
  void initState() {
    super.initState();
    _words = widget.text.split(' ');
    _startTyping();
  }

  void _startTyping() {
    _index = 0;
    _visibleText = '';
    _timer?.cancel();

    _timer = Timer.periodic(
      widget.speed,
      (Timer timer) {
        if (_index < _words.length) {
          setState(() {
            if (_visibleText.isEmpty) {
              _visibleText = _words[_index];
            } else {
              _visibleText += ' ${_words[_index]}';
            }
            _index++;
          });
        } else {
          if (widget.repeat) {
            Future<void>.delayed(
              const Duration(seconds: 1),
              _startTyping,
            );
          }
          timer.cancel();
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AutoSizeText(
        _visibleText,
        textAlign: widget.textAlign ?? TextAlign.center,
        style: widget.style ??
            AppTextStyle.openRunde(
              fontSize: 40.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.kffffff,
              shadows: <Shadow>[
                const Shadow(
                  offset: Offset(0, 2),
                  blurRadius: 2,
                  color: Color(0x55000000),
                ),
              ],
            ),
        overflow: TextOverflow.ellipsis,
        maxLines: widget.maxLines,
        minFontSize: widget.minFontSize,
      );
}
