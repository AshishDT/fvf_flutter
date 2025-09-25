import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/modules/profile/widgets/profile_image_card.dart';

import '../../../data/config/app_colors.dart';
import '../../../data/config/app_images.dart';
import '../../../utils/app_text_style.dart';

/// EMPTY PROFILE PLACEHOLDER
class EmptyProfilePlaceholder extends StatelessWidget {
  /// Empty profile placeholder constructor
  const EmptyProfilePlaceholder({
    required this.navigatorTag,
    super.key,
  });

  /// Navigator tag
  final String navigatorTag;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 100.w,
              width: 100.w,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.kF1F2F2,
              ),
              child: ProfileImageCard(
                placeholderAsset: AppImages.profilePlaceholder,
                navigatorTag: navigatorTag,
              ),
            ),
            16.verticalSpace,
            Text(
              'add profile pic',
              style: AppTextStyle.openRunde(
                fontSize: 15.sp,
                color: AppColors.kC0C8C9,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
}
