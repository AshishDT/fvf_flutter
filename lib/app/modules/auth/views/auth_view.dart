import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:fvf_flutter/app/routes/app_pages.dart';
import 'package:fvf_flutter/app/ui/components/animated_column.dart';
import 'package:fvf_flutter/app/ui/components/app_button.dart';
import 'package:fvf_flutter/app/ui/components/gradient_card.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';
import 'package:fvf_flutter/app/utils/widget_ext.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

/// Auth view
class AuthView extends GetView<AuthController> {
  /// Auth view constructor
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.kF5FCFF,
        body: GradientCard(
          child: Padding(
            padding: REdgeInsets.symmetric(horizontal: 24),
            child: AnimatedColumn(
              children: <Widget>[
                125.verticalSpace,
                Align(
                  child: Image(
                    image: const AssetImage(
                      AppImages.appLogo,
                    ),
                    height: 108.h,
                    width: 190.w,
                  ),
                ),
                16.verticalSpace,
                Align(
                  child: RichText(
                    text: TextSpan(
                      text: 'Will',
                      style: AppTextStyle.openRunde(
                        color: AppColors.kffffff,
                        fontSize: 40.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: ' AI',
                          style: AppTextStyle.openRunde(
                            color: AppColors.kffffff,
                            fontSize: 40.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: ' pick',
                          style: AppTextStyle.openRunde(
                            color: AppColors.kffffff,
                            fontSize: 40.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: ' you',
                          style: AppTextStyle.openRunde(
                            color: AppColors.kffffff,
                            fontSize: 40.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: '?',
                          style: AppTextStyle.openRunde(
                            color: AppColors.kffffff,
                            fontSize: 40.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                AppButton(
                  buttonText: 'Let’s Goooo!',
                  onPressed: () {
                    Get.toNamed(Routes.AGE_INPUT);
                  },
                ),
                16.verticalSpace,
                AppButton(
                  buttonText: 'Login',
                  onPressed: () {
                    Get.toNamed(Routes.AGE_INPUT);
                  },
                  style: AppTextStyle.openRunde(
                    color: AppColors.kF1F2F2,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(28).r,
                  ),
                ),
              ],
            ),
          ),
        ),
      ).withGPad(
        context,
        decoration: const BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            image: AssetImage(
              AppImages.gradientCardBg,
            ),
          ),
        ),
      );
}
