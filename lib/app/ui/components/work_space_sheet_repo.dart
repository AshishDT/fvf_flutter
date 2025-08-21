import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Repository for handling workspace related bottom sheets
class WorkSpaceSheetRepo {
  /// Opens the chat input bottom sheet and dismisses it when keyboard closes
  static void openChatField(Widget child, {bool isDismissible = false}) {
    showModalBottomSheet(
      context: Get.context!,
      useSafeArea: true,
      isScrollControlled: true,
      isDismissible: isDismissible,
      useRootNavigator: true,
      enableDrag: false,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ).r,
      ),
      builder: (BuildContext context) => SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: child,
      ),
    );
  }
}
