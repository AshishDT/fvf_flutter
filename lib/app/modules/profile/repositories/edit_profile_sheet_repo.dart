import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Repository for handling edit profile related bottom sheet
class EditProfileSheetRepo {
  /// Is sheet open
  static RxBool isSheetOpen = false.obs;

  /// Opens the edit profile input bottom sheet and dismisses it when keyboard closes
  static void openEditProfile(
    Widget child, {
    VoidCallback? onComplete,
  }) {
    isSheetOpen(true);
    showModalBottomSheet(
      context: Get.context!,
      useSafeArea: true,
      isScrollControlled: true,
      useRootNavigator: true,
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
