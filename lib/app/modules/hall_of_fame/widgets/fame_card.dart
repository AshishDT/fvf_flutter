import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

/// Fame card widget
class FameCard extends StatelessWidget {
  /// Constructor
  const FameCard({
    required this.imageUrl,
    required this.name,
    required this.description,
    this.isActive = false,
    this.isCurrent = false,
    super.key,
  });

  /// Image url
  final String imageUrl;

  /// Name
  final String name;

  /// Description
  final String description;

  /// Is active
  final bool isActive;

  /// Is current
  final bool isCurrent;

  @override
  Widget build(BuildContext context) => Padding(
        padding: REdgeInsets.only(bottom: 27),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 48.h,
              width: 48.w,
              decoration: !isCurrent ? null : _currentDecoration(),
              child: Align(
                child: SvgPicture.asset(
                  imageUrl,
                  width: 36.w,
                  height: 36.h,
                  colorFilter: !isActive
                      ? ColorFilter.mode(
                          AppColors.kFAFBFB.withValues(alpha: 0.35),
                          BlendMode.srcIn,
                        )
                      : null,
                ),
              ),
            ),
            16.horizontalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  name,
                  style: AppTextStyle.openRunde(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: !isActive
                        ? AppColors.kFAFBFB.withValues(alpha: 0.35)
                        : AppColors.kffffff,
                  ),
                ),
                4.verticalSpace,
                Text(
                  description,
                  style: AppTextStyle.openRunde(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: !isActive
                        ? AppColors.kFAFBFB.withValues(alpha: 0.35)
                        : AppColors.kFAFBFB,
                  ),
                ),
              ],
            )
          ],
        ),
      );

  /// Current decoration
  BoxDecoration _currentDecoration() => BoxDecoration(
      shape: BoxShape.circle,
      border: GradientBoxBorder(
        width: 2.w,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xFFFFDBF6),
            Color(0xFFFF70DB),
            Color(0xFF6C75FF),
            Color(0xFF4DD0FF),
          ],
          stops: <double>[0.1407, 0.228, 0.5635, 1.0],
        ),
      ),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          Color(0xFFFB46CD),
          Color(0xFF6C75FF),
          Color(0xFF0DBFFF),
        ],
        stops: <double>[
          0.1407,
          0.5635,
          1,
        ],
      ),
      boxShadow: <BoxShadow>[
        const BoxShadow(
          color: Color(0xFFFF70DB),
          blurRadius: 12,
          spreadRadius: 3,
        ),
        BoxShadow(
          color: const Color(0xFF000000).withValues(alpha: 0.36),
          offset: const Offset(0, 3),
          blurRadius: 8,
        ),
      ],
    );
}
