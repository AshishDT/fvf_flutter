import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:fvf_flutter/app/routes/app_pages.dart';
import 'package:fvf_flutter/app/ui/components/animated_column.dart';
import 'package:fvf_flutter/app/ui/components/app_button.dart';
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
        body: Padding(
          padding: REdgeInsets.symmetric(horizontal: 24),
          child: AnimatedColumn(
            children: <Widget>[
              125.verticalSpace,
              Align(
                child: Image(
                  image: const AssetImage(
                    AppImages.appLogo,
                  ),
                  height: 180.h,
                  width: 180.w,
                ),
              ),
              16.verticalSpace,
              Align(
                child: RichText(
                  text: TextSpan(
                    text: 'Will',
                    style: AppTextStyle.openRunde(
                      color: AppColors.k3D4445,
                      fontSize: 40.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: ' AI',
                        style: AppTextStyle.openRunde(
                          color: AppColors.k2A2E2F,
                          fontSize: 40.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: ' pick',
                        style: AppTextStyle.openRunde(
                          color: AppColors.k3D4445,
                          fontSize: 40.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: ' you',
                        style: AppTextStyle.openRunde(
                          color: AppColors.k2A2E2F,
                          fontSize: 40.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: '?',
                        style: AppTextStyle.openRunde(
                          color: AppColors.k3D4445,
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
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage(AppImages.buttonBg),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(28).r,
                ),
              ),
              16.verticalSpace,
              AppButton(
                buttonText: 'I Have an Account',
                onPressed: () {
                  Get.toNamed(Routes.AGE_INPUT);
                },
                style: AppTextStyle.openRunde(
                  color: AppColors.kA8B3B5,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
                decoration: BoxDecoration(
                  color: AppColors.kF5FCFF,
                  borderRadius: BorderRadius.circular(28).r,
                ),
              ),
            ],
          ),
        ),
      ).withGPad(context);
}
