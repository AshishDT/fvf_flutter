import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';

/// Rank card widget
class RankCard extends StatelessWidget {
  /// Constructor for RankCard
  const RankCard({
    required this.rank,
    super.key,
  });

  /// Creates a [RankCard] widget with the specified rank.
  final int rank;

  @override
  Widget build(BuildContext context) => IntrinsicWidth(
        child: rank == 1
            ? SvgPicture.asset(
                height: 30.h,
                width: 82.w,
                AppImages.firstRank,
              )
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12).r,
                  color: AppColors.kF1F2F2.withValues(alpha: 0.36),
                ),
                height: 24.h,
                padding: REdgeInsets.symmetric(horizontal: 8),
                child: Center(
                  child: Text(
                    '$rank\st Place',
                    style: AppTextStyle.openRunde(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.kffffff,
                    ),
                  ),
                ),
              ),
      );
}
