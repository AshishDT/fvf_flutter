import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Repository for handling chat related bottom sheets
class ChatFieldSheetRepo {
  /// Is sheet open
  static RxBool isSheetOpen = false.obs;

  /// Opens the chat input bottom sheet and dismisses it when keyboard closes
  static void openChatField(
    Widget child, {
    VoidCallback? onComplete,
  }) {
    isSheetOpen(true);
    showModalBottomSheet(
      context: Get.context!,
      useSafeArea: true,
      isScrollControlled: true,
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
    ).whenComplete(
      () {
        isSheetOpen(false);
        onComplete?.call();
      },
    );
  }
}
