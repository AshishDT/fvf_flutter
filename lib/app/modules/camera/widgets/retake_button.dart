import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:get/get.dart';

/// Retake Button Widget
class RetakeButton extends StatefulWidget {
  /// Retake button
  const RetakeButton({super.key, this.onRetake});

  /// On retake callback
  final VoidCallback? onRetake;

  @override
  State<RetakeButton> createState() => _RetakeButtonState();
}

class _RetakeButtonState extends State<RetakeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: widget.onRetake,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget? child) => CustomPaint(
                painter: _BorderProgressPainter(_controller.value),
                child: SizedBox(
                  width: double.infinity,
                  height: 57.h,
                ),
              ).paddingSymmetric(horizontal: 24.w),
            ),
            Container(
              height: 57.h,
              decoration: BoxDecoration(
                color: AppColors.k2A2E2F.withValues(alpha: 0.42),
                borderRadius: BorderRadius.circular(32.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset(
                    AppImages.retakeIcon,
                    height: 18.w,
                    width: 18.w,
                  ),
                  4.horizontalSpace,
                  Text(
                    'Retake',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.kffffff,
                    ),
                  ),
                ],
              ),
            ).paddingSymmetric(horizontal: 24.w),
          ],
        ),
      );
}

/// Custom Painter for rounded border progress
class _BorderProgressPainter extends CustomPainter {
  _BorderProgressPainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    const double strokeWidth = 3;
    final double r = 32.r;

    final Rect rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );

    final RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(r));

    // Background border (transparent stroke so corners align visually)
    final Paint bgPaint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawRRect(rrect, bgPaint);

    // Gradient stroke
    const LinearGradient gradient = LinearGradient(
      begin: Alignment(-0.7, -1),
      end: Alignment(0.5, 1),
      colors: <Color>[
        AppColors.kFB46CD,
        AppColors.k6C75FF,
        AppColors.k0DBFFF,
      ],
      stops: <double>[0.1407, 0.5635, 1],
    );

    final Paint paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Build path for rounded rect
    final Path path = Path()..addRRect(rrect);
    final PathMetric metric = path.computeMetrics().first;

    final double totalLength = metric.length;
    final double startOffset = totalLength * 0.25; // top-center
    final double sweepLength = totalLength * progress;
    final double endOffset = startOffset + sweepLength;

    if (endOffset <= totalLength) {
      // Normal: no wrap needed
      final Path extractPath = metric.extractPath(startOffset, endOffset);
      canvas.drawPath(extractPath, paint);
    } else {
      // Wrap around: split into two parts
      final Path first = metric.extractPath(startOffset, totalLength);
      final Path second = metric.extractPath(0, endOffset - totalLength);

      canvas.drawPath(first, paint);
      canvas.drawPath(second, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BorderProgressPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
