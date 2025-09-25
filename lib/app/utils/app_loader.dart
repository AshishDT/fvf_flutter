// ignore_for_file: depend_on_referenced_packages, always_specify_types

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';
import 'package:get/get.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import '../data/config/app_colors.dart';

/// Loader
class Loader {
  /// Is Open Dialog
  static bool isOpen = false;

  /// Is More Than 20 Sec
  static RxBool isTakingMoreThan20Sec = false.obs;

  /// Show Dialog
  static void show({
    String? msg,
  }) {
    FocusScope.of(Get.context!).unfocus();

    isTakingMoreThan20Sec(false);
    isTakingMoreThan20Sec.refresh();

    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.custom
      ..backgroundColor = Colors.transparent
      ..indicatorColor = Colors.transparent
      ..textColor = Colors.transparent
      ..boxShadow = [];

    if (!isOpen) {
      isOpen = true;

      if ((msg?.isNotEmpty ?? false) && msg != null) {
        Future.delayed(
          const Duration(seconds: 20),
          () {
            isTakingMoreThan20Sec(true);
            isTakingMoreThan20Sec.refresh();
          },
        );
      }
      EasyLoading.show(
        indicator: PopScope(
          canPop: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: SizedBox(
                  width: 45.w,
                  height: 45.h,
                  child: SleekCircularSlider(
                    appearance: CircularSliderAppearance(
                      spinnerMode: true,
                      size: 50,
                      customColors: CustomSliderColors(
                        dotColor: Colors.transparent,
                        trackColor: Colors.transparent,
                        progressBarColor: Colors.transparent,
                        shadowColor: Colors.black38,
                        progressBarColors: <Color>[
                          const Color(0xFFFFDBF6),
                          const Color(0xFFFF70DB),
                          const Color(0xFF6C75FF),
                          const Color(0xFF4DD0FF),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if ((msg?.isNotEmpty ?? false) && msg != null) ...[
                5.verticalSpace,
                Center(
                  child: Obx(
                    () => Text(
                      isTakingMoreThan20Sec()
                          ? 'Hang in there... This could take some time.'
                          : msg,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.openRunde(
                        color: AppColors.k101928,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        dismissOnTap: false,
        maskType: EasyLoadingMaskType.black,
      );
    }
  }

  /// Dismiss Dialog
  static void dismiss() {
    if (isOpen) {
      isOpen = false;
      EasyLoading.dismiss();
    }
  }
}
