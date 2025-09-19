import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fvf_flutter/app/modules/claim_phone/controllers/claim_phone_controller.dart';
import 'package:fvf_flutter/app/modules/claim_phone/views/otp_input_sheet.dart';
import 'package:fvf_flutter/app/ui/components/app_snackbar.dart';
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

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: GradientCard(
          padding: REdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                  'Keep Your Slay Profile ✨',
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
                  'Add your number to secure it',
                  style: AppTextStyle.openRunde(
                    fontSize: 16.sp,
                    color: AppColors.kFAFBFB,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              24.verticalSpace,
              TextFormField(
                controller: controller.phoneController,
                cursorColor: AppColors.kF1F2F2,
                keyboardType: TextInputType.number,
                maxLength: 10,
                onFieldSubmitted: (String value) {
                  _onFieldSubmitted(
                    context,
                    value,
                  );
                },
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
                    maxWidth: 40.w,
                  ),
                  prefixIcon: Padding(
                    padding: REdgeInsets.only(left: 12),
                    child: SvgPicture.asset(
                      AppImages.phoneIcon,
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
                  errorStyle: const TextStyle(fontSize: 0),
                  border: _outlineBorder(),
                  disabledBorder: _outlineBorder(),
                  enabledBorder: _outlineBorder(),
                  focusedBorder: _outlineBorder(),
                  errorBorder: _outlineBorder(),
                  focusedErrorBorder: _outlineBorder(),
                ),
              ),
              24.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  OutlineInputBorder _outlineBorder() => OutlineInputBorder(
      borderRadius: BorderRadius.circular(28).r,
      borderSide: BorderSide.none,
    );

  Future<void> _onFieldSubmitted(BuildContext context, String value) async {
    final String _trimmedValue = value.trim();

    if (_trimmedValue.isEmpty || value.length < 10) {
      appSnackbar(
        message: 'Please enter a valid phone number',
        snackbarState: SnackbarState.danger,
      );
      return;
    }

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
}
