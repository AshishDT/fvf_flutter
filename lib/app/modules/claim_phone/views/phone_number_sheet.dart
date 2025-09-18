import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fvf_flutter/app/modules/claim_phone/controllers/claim_phone_controller.dart';
import 'package:fvf_flutter/app/modules/claim_phone/views/otp_input_sheet.dart';
import 'package:fvf_flutter/app/ui/components/app_button.dart';
import 'package:fvf_flutter/app/ui/components/gradient_card.dart';
import 'package:get/get.dart';

import '../../../data/config/app_colors.dart';
import '../../../data/config/app_images.dart';
import '../../../utils/app_text_style.dart';

/// PhoneNumberSheet widget (non-draggable, keyboard-aware)
class PhoneNumberSheet extends GetView<ClaimPhoneController> {
  /// Phone number sheet
  const PhoneNumberSheet({super.key});

  @override
  Widget build(BuildContext context) {
    // Request phone hint as soon as the sheet is opened
    Future<void>.microtask(() => controller.requestPhoneHint());

    return Obx(
      () => PopScope(
        canPop: !controller.isSendingOtp(),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: GradientCard(
              padding: REdgeInsets.symmetric(horizontal: 24, vertical: 24),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
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
                      'Secure your profile and progress with your number',
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
                    key: controller.phoneFormKey,
                    child: FormField<String>(
                      validator: (Object? value) {
                        final String phone =
                            controller.phoneController.text.trim();
                        if (phone.isEmpty) {
                          return 'Phone number is required';
                        }
                        final RegExp regex = RegExp(r'^\+?[0-9]+$');
                        if (!regex.hasMatch(phone)) {
                          return 'Phone number must contain digits only';
                        }
                        return null;
                      },
                      builder: (FormFieldState<Object> field) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          AnimatedContainer(
                            duration: 300.milliseconds,
                            padding: REdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.kF1F2F2.withValues(alpha: 0.36),
                              borderRadius: BorderRadius.circular(28).r,
                            ),
                            child: TextFormField(
                              controller: controller.phoneController,
                              cursorColor: AppColors.kF1F2F2,
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              style: AppTextStyle.openRunde(
                                color: AppColors.kffffff,
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                              ),
                              textInputAction: TextInputAction.go,
                              decoration: InputDecoration(
                                hintText: '',
                                counterText: '',
                                prefixIconConstraints: BoxConstraints(
                                  maxHeight: 24.h,
                                  maxWidth: 24.w,
                                ),
                                prefixIcon: SvgPicture.asset(
                                  AppImages.phoneIcon,
                                  height: 24.h,
                                  width: 24.w,
                                ),
                                errorStyle: const TextStyle(fontSize: 0),
                                border: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
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
                                color: AppColors.kFAFBFB.withValues(alpha: 0.6),
                                fontWeight: FontWeight.w500,
                              ),
                            ).paddingOnly(left: 10.w, top: 4.h),
                        ],
                      ),
                    ),
                  ),
                  24.verticalSpace,
                  AppButton(
                    buttonText: 'Send OTP',
                    isLoading: controller.isSendingOtp(),
                    onPressed: () async {
                      if (controller.phoneFormKey.currentState?.validate() ??
                          false) {
                        final bool isOtpSend = await controller.sendOtp();
                        if (isOtpSend) {
                          Get.close(1);
                          await showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => const OtpSheet(),
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
}
