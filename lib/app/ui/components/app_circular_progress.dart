import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

/// App Circular Progress Indicator
class AppCircularProgress extends StatelessWidget {
  /// Constructor
  const AppCircularProgress({super.key, this.size = 50});

  /// Size of the progress indicator
  final double size;

  @override
  Widget build(BuildContext context) => SleekCircularSlider(
        appearance: CircularSliderAppearance(
          spinnerMode: true,
          size: size,
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
