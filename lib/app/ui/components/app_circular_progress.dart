import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

/// App Circular Progress Indicator
class AppCircularProgress extends StatelessWidget {
  /// Constructor
  const AppCircularProgress({
    super.key,
    this.size = 50,
    this.useCustomWidth = true,
  });

  /// Size of the progress indicator
  final double size;

  /// Use custom width for the progress indicator
  final bool useCustomWidth;

  @override
  Widget build(BuildContext context) => SleekCircularSlider(
        appearance: CircularSliderAppearance(
          spinnerMode: true,
          size: size,
          customWidths: useCustomWidth
              ? CustomSliderWidths(
                  trackWidth: 2.w,
                  progressBarWidth: 2.w,
                  shadowWidth: 1.w,
                  handlerSize: 2.w,
                )
              : null,
          customColors: CustomSliderColors(
            dotColor: Colors.transparent,
            trackColor: Colors.transparent,
            progressBarColor: Colors.transparent,
            shadowColor: Colors.black38,
            progressBarColors: <Color>[
              const Color(0xFFFFDBF6),
              const Color(0xFFFF70DB),
              const Color(0xFF6C75FF),
              const Color(0xFF4DD0FF),
            ],
          ),
        ),
      );
}
