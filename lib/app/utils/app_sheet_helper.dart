import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';
import 'package:get/get.dart';
import 'package:fvf_flutter/app/utils/widget_ext.dart';
import '../data/config/app_colors.dart';
import '../ui/components/app_button.dart';

/// App Sheet Repository
class AppSheetRepo {
  /// Change language bottom sheet
  static void shoSomething({
    final void Function()? onApply,
    Widget? languageWidget,
  }) {
    _show(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          10.verticalSpace,
          Center(
            child: Container(
              height: 6.h,
              width: 44.w,
              decoration: BoxDecoration(
                color: AppColors.kA4A4A4,
                borderRadius: BorderRadius.circular(3).r,
              ),
            ),
          ),
          22.verticalSpace,
          Text(
            'Show Something',
            style: AppTextStyle.openRunde(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.k000000,
            ),
            textAlign: TextAlign.start,
          ),
          if (languageWidget != null) ...<Widget>[
            languageWidget,
          ],
          32.verticalSpace,
          AppButton(
            buttonText: 'Continue',
            onPressed: () {
              Get.back();
              onApply?.call();
            },
          ),
        ],
      ),
    );
  }

  /// Show a bottom sheet with the given child widget
  static void _show({
    required Widget child,
  }) {
    showModalBottomSheet(
      context: Get.context!,
      backgroundColor: AppColors.kffffff,
      useSafeArea: true,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ).r,
      ),
      builder: (BuildContext context) => Padding(
        padding: REdgeInsets.symmetric(horizontal: 16),
        child: child.withGPad(
          context,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ).r,
          ),
        ),
      ),
    );
  }
}
