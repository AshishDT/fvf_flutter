import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fvf_flutter/app/modules/claim_phone/controllers/claim_phone_controller.dart';
import 'package:fvf_flutter/app/modules/claim_phone/views/otp_input_sheet.dart';
import 'package:fvf_flutter/app/ui/components/app_snackbar.dart';
import 'package:fvf_flutter/app/ui/components/country_picker.dart';
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
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: GradientCard(
            padding: REdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
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
                    autofocus: true,
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
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    textInputAction: TextInputAction.go,
                    decoration: InputDecoration(
                      hintText: '',
                      counterText: '',
                      prefix: GestureDetector(
                        onTap: () {
                          CountryPicker.show(
                            context,
                            onSelect: (Country country) {
                              controller.country(country);
                              controller.country.refresh();
                            },
                          );
                        },
                        child: IntrinsicWidth(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              SvgPicture.asset(
                                AppImages.phoneIcon,
                                height: 24.h,
                                width: 24.w,
                              ),
                              5.horizontalSpace,
                              Obx(
                                () => Text(
                                  '+ ${controller.country().phoneCode} ',
                                  style: AppTextStyle.openRunde(
                                    color: AppColors.kffffff,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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

  Future<void> _onFieldSubmitted(BuildContext context, String value) async {
    final String _trimmedValue = value.trim();

    if (_trimmedValue.isEmpty || !_trimmedValue.contains(RegExp(r'^\d+$'))) {
      appSnackbar(
        message: 'Please enter digits only',
        snackbarState: SnackbarState.danger,
      );
      return;
    }

    if (_trimmedValue.length < 10) {
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
