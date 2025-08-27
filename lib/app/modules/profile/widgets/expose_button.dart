import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../data/config/app_colors.dart';
import '../../../data/config/app_images.dart';
import '../../../ui/components/app_button.dart';
import '../../../utils/app_text_style.dart';
import '../controllers/profile_controller.dart';

/// EXPOSE BUTTON
class ExposeButton extends StatelessWidget {
  /// Expose buttons
  const ExposeButton({
    required this.controller,
    super.key,
  });

  /// Profile controller
  final ProfileController controller;

  @override
  Widget build(BuildContext context) => Obx(
        () => AnimatedSize(
          duration: 300.milliseconds,
          child: Visibility(
            visible: !controller.isExposed() && controller.currentIndex() == 1,
            child: AppButton(
              buttonText: '',
              height: 57.h,
              onPressed: () {},
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage(AppImages.buttonBg),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(28).r,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Expose Everyone 👀',
                    style: AppTextStyle.openRunde(
                      fontSize: 18.sp,
                      color: AppColors.kFAFBFB,
                      fontWeight: FontWeight.w700,
                      height: .8,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    'See how everyone placed!',
                    style: AppTextStyle.openRunde(
                      fontSize: 12.sp,
                      color: AppColors.kFAFBFB,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ).paddingAll(24.w),
          ),
        ),
      );
}
