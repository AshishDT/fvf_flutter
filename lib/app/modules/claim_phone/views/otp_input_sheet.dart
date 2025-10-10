import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fvf_flutter/app/data/config/app_images.dart';
import 'package:fvf_flutter/app/modules/claim_phone/controllers/claim_phone_controller.dart';
import 'package:fvf_flutter/app/ui/components/gradient_card.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/config/app_colors.dart';
import '../../../utils/app_text_style.dart';

/// OtpSheet widget (non-draggable, keyboard-aware)
class OtpSheet extends GetView<ClaimPhoneController> {
  /// Otp sheet
  const OtpSheet({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: GradientCard(
            padding: REdgeInsets.symmetric(horizontal: 24, vertical: 24),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24.r),
            ),
            child: Padding(
              padding: REdgeInsets.only(
                bottom: _bottom(context),
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
                      'We sent you a code 🚀',
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
                      'Please enter the code we sent',
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
                      onFieldSubmitted: (String value) {
                        _onFieldSubmitted(context);
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the OTP';
                        }
                        if (value.length < 6) {
                          return 'Incorrect code. Please try again.';
                        }
                        return null;
                      },
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        hintText: '',
                        prefixIconConstraints: BoxConstraints(
                          maxHeight: 24.h,
                          maxWidth: 40.w,
                        ),
                        prefixIcon: Padding(
                          padding: REdgeInsets.only(left: 12, top: 3),
                          child: SvgPicture.asset(
                            AppImages.otp123,
                            height: 24.h,
                            width: 24.w,
                          ),
                        ),
                        contentPadding: REdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 15,
                        ),
                        fillColor: AppColors.kF1F2F2.withValues(alpha: 0.36),
                        hoverColor: AppColors.kF1F2F2.withValues(alpha: 0.36),
                        focusColor: AppColors.kF1F2F2.withValues(alpha: 0.36),
                        filled: true,
                        counterText: '',
                        errorStyle: AppTextStyle.openRunde(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.kB52F4A,
                        ),
                        border: _outlineBorder(),
                        disabledBorder: _outlineBorder(),
                        enabledBorder: _outlineBorder(),
                        focusedBorder: _outlineBorder(),
                        errorBorder: _outlineBorder(),
                        focusedErrorBorder: _outlineBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  /// Bottom
  double _bottom(BuildContext context) =>
      MediaQuery.of(context).systemGestureInsets.bottom > 12
          ? MediaQuery.of(context).systemGestureInsets.bottom - 12
          : MediaQuery.of(context).systemGestureInsets.bottom;

  OutlineInputBorder _outlineBorder() => OutlineInputBorder(
        borderRadius: BorderRadius.circular(28).r,
        borderSide: BorderSide.none,
      );

  Future<void> _onFieldSubmitted(BuildContext context) async {
    final AuthResponse? _authResponse = await controller.verifyOtp();
    if (_authResponse != null) {
      await controller.afterVerifyOtp(authResponse: _authResponse);
    }
  }
}
