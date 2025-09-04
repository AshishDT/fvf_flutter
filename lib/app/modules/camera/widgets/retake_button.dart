import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:get/get.dart';
import 'package:zo_animated_border/zo_animated_border.dart';

/// Retake Button Widget
class RetakeButton extends StatelessWidget {
  /// Constructor for RetakeButton
  const RetakeButton({
    super.key,
    this.onRetake,
  });

  /// VoidCallback onRetake
  final VoidCallback? onRetake;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          onRetake?.call();
        },
        child: Stack(
          children: <Widget>[
            Container(
              height: 57.h,
              decoration: BoxDecoration(
                color: AppColors.k2A2E2F.withValues(alpha: .42),
                borderRadius: BorderRadius.circular(28.r),
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
            ZoGlowingEdgeBorder(
              animationDuration: 1200.milliseconds,
              borderRadius: 28.r,
              gradientColors: const <Color>[
                AppColors.kFB46CD,
                AppColors.k6C75FF,
                AppColors.k0DBFFF,
              ],
              borderWidth: 3.w,
              edgeLength: 500.w,
              child: SizedBox(
                height: 57.h,
                width: double.infinity,
              ),
            ).paddingSymmetric(horizontal: 24.w),
          ],
        ),
      );
}
