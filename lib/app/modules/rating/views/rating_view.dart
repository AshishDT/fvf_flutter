import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:fvf_flutter/app/ui/components/animated_list_view.dart';
import 'package:fvf_flutter/app/ui/components/app_button.dart';
import 'package:fvf_flutter/app/ui/components/common_app_bar.dart';
import 'package:fvf_flutter/app/ui/components/gradient_card.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/rating_controller.dart';

/// RatingView
class RatingView extends GetView<RatingController> {
  /// Constructor
  const RatingView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.kF5FCFF,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Obx(
              () => AppButton(
                buttonText: 'Rate Slay',
                onPressed: controller.requestReview,
                isLoading: controller.isReviewing(),
              ),
            ),
            16.verticalSpace,
            AppButton(
              buttonText: 'Maybe Later',
              onPressed: controller.onMaybeLater,
              buttonColor: Colors.transparent,
              style: AppTextStyle.openRunde(
                fontSize: 16.sp,
                color: AppColors.kD9DEDF,
                fontWeight: FontWeight.w700,
              ),
            ),
            20.verticalSpace,
          ],
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
                  'You’re Crushing It! ',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.openRunde(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.kffffff,
                    height: 1,
                  ),
                ),
                16.verticalSpace,
                Text(
                  'Drop us 5 ⭐ if you vibe',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.openRunde(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.kFAFBFB,
                  ),
                ),
                Lottie.asset(
                  AppImages.ratingStar,
                ),
              ],
            ),
          ),
        ),
      );
}
