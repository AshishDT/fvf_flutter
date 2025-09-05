import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/config/app_colors.dart';

/// Streak chip widget
class StreakChip extends StatelessWidget {
  /// Streak chip constructor
  const StreakChip({
    required this.title,
    required this.bgColor,
    required this.iconPath,
    this.onTap,
    super.key,
  });

  /// Bg color
  final Color bgColor;

  /// Icon path
  final String iconPath;

  /// Title
  final String title;

  /// On tap
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: REdgeInsets.symmetric(vertical: 3, horizontal: 8),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular(12.r),
              right: Radius.circular(12.r),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SvgPicture.asset(
                iconPath,
                height: 18.w,
              ),
              5.horizontalSpace,
              Text(
                title,
                style: GoogleFonts.fredoka(
                  fontSize: 14.sp,
                  color: AppColors.k3D4445,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
}
