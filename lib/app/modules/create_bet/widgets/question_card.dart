import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';

/// Question card widget
class QuestionCard extends StatelessWidget {
  /// Constructor
  const QuestionCard({
    super.key,
    this.child,
  });

  /// Child widget
  final Widget? child;

  @override
  Widget build(BuildContext context) => Stack(
        children: <Widget>[
          const Image(
            image: AssetImage(
              AppImages.qBgWithBorder,
            ),
          ),
          Positioned(
            left: 24.w,
            right: 24.w,
            top: 35.h,
            bottom: 35.h,
            child: Container(
              child: child!,
            ),
          ),
        ],
      );
}
