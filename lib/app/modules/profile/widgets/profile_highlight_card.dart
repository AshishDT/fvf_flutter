import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';
import 'package:google_fonts/google_fonts.dart';

/// ProfileHighlightCard
class ProfileHighlightCard extends StatelessWidget {
  /// ProfileHighlightCard Constructor
  const ProfileHighlightCard({
    required this.avatarUrl,
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    required this.borderColor,
    Key? key,
  }) : super(key: key);

  /// avatarUrl
  final String avatarUrl;

  /// title
  final String title;

  /// subtitle
  final String subtitle;

  /// backgroundColor
  final Color backgroundColor;

  /// borderColor
  final Color borderColor;

  @override
  Widget build(BuildContext context) => Container(
        margin: REdgeInsets.only(bottom: 16),
        padding: REdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: borderColor,
            width: 2.w,
          ),
          borderRadius: BorderRadius.circular(28.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 42.w,
              width: 42.w,
              margin: REdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.kF6FCFE, width: 2.w),
                shape: BoxShape.circle,
                color: AppColors.kF6FCFE,
              ),
            ),
            8.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: AppTextStyle.openRunde(
                      fontSize: 18.sp,
                      color: AppColors.k2A2E2F,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  2.verticalSpace,
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: AppColors.k2A2E2F,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
