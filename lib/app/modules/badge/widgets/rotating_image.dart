import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';

/// Rotating Image Widget
class RotatingImage extends StatefulWidget {
  /// Constructor
  const RotatingImage({super.key});

  @override
  State<RotatingImage> createState() => _RotatingImageState();
}

class _RotatingImageState extends State<RotatingImage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _controller,
        builder: (_, Widget? child) => Transform.rotate(
          angle: _controller.value * 2 * 3.1415926,
          child: child,
        ),
        child: Image.asset(
          AppImages.badgeBg,
          height: 300.w,
          width: 300.w,
        ),
      );
}
