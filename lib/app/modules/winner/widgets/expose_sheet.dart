import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/modules/winner/widgets/expose_sheet_view.dart';
import 'package:get/get.dart';

/// ExposeSheet
class ExposeSheet {
  /// Opens the expose bottom sheet
  static void openExposeSheet() {
    showModalBottomSheet(
      context: Get.context!,
      useSafeArea: true,
      isScrollControlled: true,
      useRootNavigator: true,
      enableDrag: false,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ).r,
      ),
      builder: (BuildContext context) => ExposeSheetView(),
    );
  }
}
