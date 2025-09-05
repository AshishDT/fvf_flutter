import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/config/app_colors.dart';
import '../../../utils/app_text_style.dart';

/// STATS CARD
class ProfileInfoCard extends StatelessWidget {
  /// Constructor
  const ProfileInfoCard({
    required this.value,
    required this.title,
    super.key,
  });

  /// Value
  final String value;

  /// Title
  final String title;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 90.w,
        child: Column(
          children: <Widget>[
            Text(
              value,
              style: GoogleFonts.fredoka(
                fontSize: 24.sp,
                color: AppColors.kFAFBFB,
                fontWeight: FontWeight.w600,
                shadows: <Shadow>[
                  BoxShadow(
                    offset: const Offset(0, 4),
                    blurRadius: 4,
                    color: AppColors.k000000.withValues(alpha: .25),
                  ),
                ],
              ),
            ),
            Text(
              title,
              style: AppTextStyle.openRunde(
                fontSize: 14.sp,
                color: AppColors.kFAFBFB,
                fontWeight: FontWeight.w600,
                shadows: <Shadow>[
                  BoxShadow(
                    offset: Offset(0, 2.h),
                    blurRadius: 2.r,
                    color: AppColors.k000000.withValues(alpha: .25),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
