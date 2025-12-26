import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';
import 'package:timeago/timeago.dart' as timeago;

/// Notification Card Widget
class NotificationCard extends StatelessWidget {
  /// Constructor
  const NotificationCard({
    required this.time,
    required this.title,
    this.subtitle,
    this.onTap,
    super.key,
  });

  /// Time
  final DateTime time;

  /// Title
  final String title;

  /// Subtitle
  final String? subtitle;

  /// On tap callback
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          onTap?.call();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: REdgeInsets.all(16),
          margin: REdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: AppColors.k2A2E2F.withValues(alpha: 0.36),
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SvgPicture.asset(
                    AppImages.notificationAppLogo,
                    height: 16.h,
                    width: 16.w,
                  ),
                  6.horizontalSpace,
                  Text(
                    'Slay',
                    style: AppTextStyle.openRunde(
                      fontSize: 12.sp,
                      color: AppColors.k4CD7F0,
                    ),
                  ),
                  5.horizontalSpace,
                  Text(
                    timeago.format(
                      time.toLocal(),
                    ),
                    style: AppTextStyle.openRunde(
                      fontSize: 12.sp,
                      color: AppColors.kD9DEDF.withValues(alpha: 0.48),
                    ),
                  ),
                ],
              ),
              12.verticalSpace,
              Text(
                title,
                style: AppTextStyle.openRunde(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.kF1F2F2,
                ),
              ),
              if (subtitle != null && subtitle!.isNotEmpty) ...[
                4.verticalSpace,
                Text(
                  subtitle!,
                  style: AppTextStyle.openRunde(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.kffffff.withValues(alpha: 0.67),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
}
