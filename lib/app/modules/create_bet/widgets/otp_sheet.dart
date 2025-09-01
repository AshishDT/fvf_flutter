import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/data/config/logger.dart';
import 'package:fvf_flutter/app/data/local/user_provider.dart';
import 'package:fvf_flutter/app/modules/create_bet/controllers/create_bet_controller.dart';
import 'package:fvf_flutter/app/ui/components/app_button.dart';
import 'package:fvf_flutter/app/ui/components/gradient_card.dart';
import 'package:get/get.dart';

import '../../../data/config/app_colors.dart';
import '../../../utils/app_text_style.dart';

/// OtpSheet widget
class OtpSheet extends GetView<CreateBetController> {
  /// Constructor for OtpSheet
  const OtpSheet({super.key});

  @override
  Widget build(BuildContext context) => Obx(
        () => PopScope(
          canPop: !controller.isVerifyingOtp(),
          child: Padding(
            padding: REdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: DraggableScrollableSheet(
              initialChildSize: 0.4,
              minChildSize: 0.3,
              maxChildSize: 0.65,
              builder: (_, ScrollController scrollController) => GradientCard(
                padding: REdgeInsets.symmetric(horizontal: 24),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24.r),
                ),
                child: ListView(
                  controller: scrollController,
                  children: <Widget>[
                    12.verticalSpace,
                    Center(
                      child: Container(
                        height: 4.h,
                        width: 48.w,
                        decoration: BoxDecoration(
                          color: AppColors.kF1F2F2.withValues(alpha: .42),
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                    ),
                    16.verticalSpace,
                    Center(
                      child: Text(
                        'Don’t lose your Slay ✨',
                        style: AppTextStyle.openRunde(
                          fontSize: 24.sp,
                          color: AppColors.kffffff,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    16.verticalSpace,
                    Center(
                      child: Text(
                        'Secure your profile and verify with OTP',
                        style: AppTextStyle.openRunde(
                          fontSize: 16.sp,
                          color: AppColors.kFAFBFB,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    24.verticalSpace,
                    Form(
                      key: controller.otpFormKey,
                      child: FormField(
                        validator: (Object? value) {
                          final String phone =
                              controller.otpController.text.trim();
                          if (phone.isEmpty) {
                            return 'OTP is required';
                          }
                          final RegExp regex = RegExp(r'^\+?[0-9]+$');
                          if (!regex.hasMatch(phone)) {
                            return 'OTP must contain digits only';
                          }
                          if (phone.length != 6) {
                            return 'OTP must be 6 digits';
                          }
                          return null;
                        },
                        builder: (FormFieldState<Object> field) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            AnimatedContainer(
                              duration: 300.milliseconds,
                              padding: REdgeInsets.symmetric(
                                  horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.kF1F2F2.withValues(alpha: 0.36),
                                borderRadius: BorderRadius.circular(28).r,
                              ),
                              child: TextFormField(
                                controller: controller.otpController,
                                cursorColor: AppColors.kF1F2F2,
                                keyboardType: TextInputType.number,
                                maxLength: 6,
                                style: AppTextStyle.openRunde(
                                  color: AppColors.kffffff,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.sp,
                                ),
                                textInputAction: TextInputAction.go,
                                decoration: InputDecoration(
                                  hintText: '- - - -',
                                  hintStyle: AppTextStyle.openRunde(
                                    color: AppColors.kffffff,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.sp,
                                  ),
                                  counterText: '',
                                  prefixIconConstraints: BoxConstraints(
                                    maxHeight: 24.h,
                                    maxWidth: 24.w,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.pin,
                                    color: AppColors.kF1F2F2,
                                    size: 24.sp,
                                  ),
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  focusedErrorBorder: InputBorder.none,
                                ),
                              ),
                            ),
                            if (field.hasError)
                              Text(
                                field.errorText ?? '',
                                style: AppTextStyle.openRunde(
                                  fontSize: 12.sp,
                                  color:
                                      AppColors.kFAFBFB.withValues(alpha: 0.6),
                                  fontWeight: FontWeight.w500,
                                ),
                              ).paddingOnly(left: 10.w, top: 4.h),
                          ],
                        ),
                      ),
                    ),
                    24.verticalSpace,
                    AppButton(
                      buttonText: 'Save',
                      isLoading: controller.isVerifyingOtp(),
                      onPressed: () async {
                        if (controller.otpFormKey.currentState?.validate() ??
                            false) {
                          final bool isOptVerified =
                              await controller.verifyOtp();
                          if (isOptVerified) {
                            await controller.claimUser(
                              phone: controller.extractLocalNumber(
                                controller.phoneController.text.trim(),
                              ),
                              countryCode: controller.extractCountryCode(
                                controller.phoneController.text.trim(),
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
