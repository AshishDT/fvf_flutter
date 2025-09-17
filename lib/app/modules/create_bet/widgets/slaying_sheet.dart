import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/modules/create_bet/widgets/slaying_sheet_view.dart';
import 'package:get/get.dart';

/// SlayingSheet
class SlayingSheet {
  /// Opens the slaying bottom sheet
  static void openSlayingSheet({
    VoidCallback? onSlayed,
    VoidCallback? onUnlimitedSlayed,
  }) {
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
      builder: (BuildContext context) => SlayingSheetView(
        onSlayed: onSlayed,
        onUnlimitedSlayed: onUnlimitedSlayed,
      ),
    );
  }
}
