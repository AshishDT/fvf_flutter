import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:fvf_flutter/app/modules/claim_phone/controllers/phone_claim_service.dart';
import 'package:fvf_flutter/app/routes/app_pages.dart';
import 'package:fvf_flutter/app/ui/components/animated_column.dart';
import 'package:fvf_flutter/app/ui/components/app_button.dart';
import 'package:fvf_flutter/app/ui/components/gradient_card.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';
import 'package:get/get.dart';

import '../../../utils/app_config.dart';
import '../controllers/auth_controller.dart';

/// Auth view
class AuthView extends GetView<AuthController> {
  /// Auth view constructor
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.kF5FCFF,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AppButton(
              buttonText: 'Let’s Goooo!',
              style: AppTextStyle.openRunde(
                color: AppColors.kffffff,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
              onPressed: () {
                Get.toNamed(Routes.AGE_INPUT);
              },
            ),
            16.verticalSpace,
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'By continuing, you agree to Slay’s ',
                style: AppTextStyle.openRunde(
                  color: AppColors.kA8B3B5,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Terms of Service',
                    style: AppTextStyle.openRunde(
                      color: AppColors.kC0C8C9,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        controller.openUrl(
                          AppConfig.termsOfServiceUrl,
                        );
                      },
                  ),
                  TextSpan(
                    text: ' and ',
                    style: AppTextStyle.openRunde(
                      color: AppColors.kA8B3B5,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: 'Privacy Policy',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        controller.openUrl(
                          AppConfig.privacyPolicyUrl,
                        );
                      },
                    style: AppTextStyle.openRunde(
                      color: AppColors.kC0C8C9,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ).paddingSymmetric(horizontal: 24),
        body: GradientCard(
          child: Padding(
            padding: REdgeInsets.symmetric(horizontal: 24),
            child: SafeArea(
              child: AnimatedColumn(
                children: <Widget>[
                  Container(
                    width: Get.width,
                    height: 45.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            PhoneClaimService.open(
                              fromLogin: true,
                            );
                          },
                          child: Text(
                            'Login',
                            style: AppTextStyle.openRunde(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.kffffff,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  88.verticalSpace,
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
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'See where',
                        style: AppTextStyle.openRunde(
                          color: AppColors.kffffff,
                          fontSize: 40.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: ' you\n',
                            style: AppTextStyle.openRunde(
                              color: AppColors.kffffff,
                              fontSize: 40.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: 'stand with',
                            style: AppTextStyle.openRunde(
                              color: AppColors.kffffff,
                              fontSize: 40.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: ' AI',
                            style: AppTextStyle.openRunde(
                              color: AppColors.kffffff,
                              fontSize: 40.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: '.',
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
                ],
              ),
            ),
          ),
        ),
      );
}
