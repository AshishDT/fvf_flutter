import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:fvf_flutter/app/modules/badge/widgets/badge_extension.dart';
import 'package:fvf_flutter/app/modules/badge/widgets/rotating_image.dart';
import 'package:fvf_flutter/app/ui/components/animated_list_view.dart';
import 'package:fvf_flutter/app/ui/components/app_button.dart';
import 'package:fvf_flutter/app/ui/components/common_app_bar.dart';
import 'package:fvf_flutter/app/ui/components/gradient_card.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';
import 'package:get/get.dart';

import '../controllers/badge_controller.dart';

/// Badge View
class BadgeView extends GetView<BadgeController> {
  /// Constructor
  const BadgeView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.kF5FCFF,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AppButton(
          buttonText: 'Claim Badge',
          onPressed: () {},
        ).paddingSymmetric(horizontal: 24.w),
        body: GradientCard(
          padding: REdgeInsets.symmetric(horizontal: 24),
          child: SafeArea(
            child: AnimatedListView(
              children: <Widget>[
                const CommonAppBar(
                  leadingIcon: AppImages.closeIconWhite,
                ),
                64.verticalSpace,
                Text(
                  'Gold',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.openRunde(
                    fontSize: 40.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.kffffff,
                    height: 1,
                  ),
                ),
                24.verticalSpace,
                Text(
                  'Gold'.badgeInfo,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.openRunde(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.kffffff,
                  ),
                ),
                56.verticalSpace,
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    const RotatingImage(),
                    Image.asset(
                      AppImages.badgeCardBg,
                      height: 120.w,
                      width: 120.w,
                    ),
                    SvgPicture.asset(
                      'Gold'.badgeIcon,
                      height: 46.w,
                      width: 46.w,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
