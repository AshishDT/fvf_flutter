import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/modules/profile/controllers/profile_controller.dart';
import 'package:get/get.dart';

/// Repository for handling edit profile related bottom sheet
class EditProfileSheetRepo {
  /// Opens the edit profile input bottom sheet and dismisses it when keyboard closes
  static void openEditProfile(Widget child) {
    final ProfileController controller = Get.find<ProfileController>();
    showModalBottomSheet(
      context: Get.context!,
      useSafeArea: true,
      isScrollControlled: true,
      isDismissible: !controller.isEditing(),
      useRootNavigator: true,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ).r,
      ),
      builder: (BuildContext context) => WillPopScope(
        onWillPop: () async => !controller.isEditing(),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: child,
        ),
      ),
    );
  }
}
