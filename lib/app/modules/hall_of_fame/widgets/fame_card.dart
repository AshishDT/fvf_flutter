import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';

/// Fame card widget
class FameCard extends StatelessWidget {
  /// Constructor
  const FameCard({
    required this.imageUrl,
    required this.name,
    required this.description,
    super.key,
  });

  /// Image url
  final String imageUrl;

  /// Name
  final String name;

  /// Description
  final String description;

  @override
  Widget build(BuildContext context) => Padding(
        padding: REdgeInsets.only(bottom: 27),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SvgPicture.asset(
              imageUrl,
              width: 36.w,
              height: 36.h,
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
                    color: AppColors.kffffff,
                  ),
                ),
                4.verticalSpace,
                Text(
                  description,
                  style: AppTextStyle.openRunde(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.kFAFBFB,
                  ),
                ),
              ],
            )
          ],
        ),
      );
}
