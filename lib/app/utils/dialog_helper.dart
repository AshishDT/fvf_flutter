import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';
import 'package:get/get.dart';
import 'package:fvf_flutter/generated/locales.g.dart';
import '../data/config/app_colors.dart';
import '../data/enums/language_enum.dart';
import '../ui/components/app_button.dart';

/// Dialog helper
class DialogHelper {
  /// Show a dialog to confirm log out
  static void onLogOut({
    void Function()? onPositiveClick,
    LanguageEnum selectedLanguage = LanguageEnum.english,
  }) {
    _showDialog(
      title: LocaleKeys.dialog_title.tr,
      msg: LocaleKeys.dialog_message.tr,
      negTxt: LocaleKeys.dialog_cancel_button.tr,
      posTxt: LocaleKeys.dialog_confirm_button.tr,
      negative: () {},
      positive: () {
        onPositiveClick?.call();
      },
    );
  }

  /// Show a dialog
  static void _showDialog({
    required String title,
    required String msg,
    required String negTxt,
    required String posTxt,
    Function()? negative,
    Function()? positive,
    Color? positiveButtonColor,
    Color? negativeButtonColor,
  }) {
    showDialog<void>(
      barrierDismissible: false,
      context: Get.context!,
      barrierColor: Colors.black54,
      builder: (BuildContext context) => _appDialogWidget(
        context,
        title: title,
        msg: msg,
        negTxt: negTxt,
        posTxt: posTxt,
        negative: negative,
        positive: positive,
        negativeButtonColor: negativeButtonColor,
        positiveButtonColor: positiveButtonColor,
      ),
    );
  }

  /// Show a single button dialog
  static void showSingleButtonDialog({
    required String title,
    required String posTxt,
    String? msg,
    Function()? positive,
    Color? buttonColor,
  }) {
    showDialog<void>(
      barrierDismissible: false,
      context: Get.context!,
      barrierColor: Colors.black54,
      builder: (BuildContext context) => singleButtonDialog(
        context,
        title: title,
        msg: msg,
        posTxt: posTxt,
        positive: positive,
        buttonColor: buttonColor,
      ),
    );
  }

  /// Dialog widget
  static Widget _appDialogWidget(
    BuildContext context, {
    required String title,
    required String negTxt,
    required String posTxt,
    String? msg,
    Function()? negative,
    Function()? positive,
    Color? positiveButtonColor,
    Color? negativeButtonColor,
  }) =>
      Dialog(
        insetPadding: REdgeInsets.all(16),
        backgroundColor: AppColors.kffffff,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24).r,
        ),
        child: Padding(
          padding: REdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                textAlign: TextAlign.left,
                style: AppTextStyle.openRunde(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.k000000.withValues(alpha: 82),
                ),
              ),
              if (msg != null && msg.isNotEmpty) ...<Widget>[
                12.verticalSpace,
                Text(
                  msg,
                  textAlign: TextAlign.left,
                  style: AppTextStyle.openRunde(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.k000000.withValues(alpha: 60),
                  ),
                ),
              ],
              36.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: AppButton(
                      buttonColor: negativeButtonColor ?? AppColors.kA4A4A4,
                      buttonText: negTxt,
                      onPressed: () {
                        Get.back();
                        negative?.call();
                      },
                    ),
                  ),
                  17.horizontalSpace,
                  Expanded(
                    child: AppButton(
                      buttonColor: positiveButtonColor ?? AppColors.k00A4A6,
                      buttonText: posTxt,
                      onPressed: () {
                        Get.back();
                        positive?.call();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  /// Show a single button dialog
  static Widget singleButtonDialog(
    BuildContext context, {
    required String title,
    required String posTxt,
    String? msg,
    Function()? positive,
    Color? buttonColor,
  }) =>
      Dialog(
        insetPadding: REdgeInsets.all(16),
        backgroundColor: AppColors.kffffff,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24).r,
        ),
        child: Padding(
          padding: REdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                textAlign: TextAlign.left,
                style: AppTextStyle.openRunde(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.k000000.withValues(alpha: 82),
                ),
              ),
              if (msg != null && msg.isNotEmpty) ...<Widget>[
                12.verticalSpace,
                Text(
                  msg,
                  textAlign: TextAlign.left,
                  style: AppTextStyle.openRunde(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.k000000.withValues(alpha: 60),
                  ),
                ),
              ],
              36.verticalSpace,
              Center(
                child: AppButton(
                  buttonColor: buttonColor ?? AppColors.k00A4A6,
                  width: 150.w,
                  buttonText: posTxt,
                  onPressed: () {
                    Get.back();
                    positive?.call();
                  },
                ),
              ),
            ],
          ),
        ),
      );
}
