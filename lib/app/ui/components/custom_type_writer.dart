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
    this.speed = const Duration(milliseconds: 50),
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

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  void _startTyping() {
    _index = 0;
    _visibleText = '';
    _timer?.cancel();

    _timer = Timer.periodic(widget.speed, (Timer timer) {
      if (_index < widget.text.length) {
        setState(() {
          _visibleText += widget.text[_index];
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
    });
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
            ),
        overflow: TextOverflow.ellipsis,
        maxLines: widget.maxLines,
        minFontSize: widget.minFontSize,
      );
}
