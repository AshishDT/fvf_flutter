import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/utils/app_decorations_ext.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';
import 'package:get/get.dart';
import '../data/config/app_colors.dart';
import '../ui/components/app_button.dart';

/// Dialog helper
class DialogHelper {
  /// Show a dialog to confirm log out
  static void onBackOfAiChoosing({
    void Function()? onPositiveClick,
  }) {
    _showDialog(
      title: 'Are you sure you want to leave?',
      msg: 'Your current progress will be lost.',
      negTxt: 'No, Stay',
      posTxt: 'Yes, Proceed',
      negative: () {},
      positive: () {
        onPositiveClick?.call();
      },
    );
  }

  /// Show a dialog to confirm log out
  static void onBackOfWinner({
    void Function()? onPositiveClick,
  }) {
    _showDialog(
      title: 'Are you sure you want to leave?',
      msg: 'You will not be able to see the results again.',
      negTxt: 'No, Stay',
      posTxt: 'Yes, Proceed',
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
        child: Container(
          decoration: AppDecorations.fancyGradient().copyWith(
            borderRadius: BorderRadius.circular(24).r,
          ),
          child: Padding(
            padding: REdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AutoSizeText(
                  title,
                  textAlign: TextAlign.left,
                  maxLines: 2,
                  style: AppTextStyle.openRunde(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.kffffff,
                  ),
                ),
                if (msg != null && msg.isNotEmpty) ...<Widget>[
                  12.verticalSpace,
                  AutoSizeText(
                    msg,
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    style: AppTextStyle.openRunde(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.kffffff,
                    ),
                  ),
                ],
                36.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: AppButton(
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
        ),
      );
}
