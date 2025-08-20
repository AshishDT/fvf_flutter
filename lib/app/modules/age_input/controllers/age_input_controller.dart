import 'package:flutter/material.dart';
import 'package:fvf_flutter/app/routes/app_pages.dart';
import 'package:fvf_flutter/app/ui/components/app_snackbar.dart';
import 'package:get/get.dart';

/// Age Input Controller
class AgeInputController extends GetxController {
  /// On init
  @override
  void onInit() {
    super.onInit();
  }

  /// On ready
  @override
  void onReady() {
    super.onReady();
  }

  /// On close
  @override
  void onClose() {
    super.onClose();
  }

  /// Text editing controller for age input
  TextEditingController ageInputController = TextEditingController();

  /// Callback for when the "Next" button is pressed
  void onNext() {
    final String age = ageInputController.text.trim();

    if (age.isEmpty) {
      appSnackbar(
        message: 'Please enter your age',
        snackbarState: SnackbarState.info,
      );
      return;
    }

    final int ageValue = int.tryParse(age) ?? 0;

    if (ageValue < 18) {
      appSnackbar(
        message: 'You must be at least 18 years old to join.',
        snackbarState: SnackbarState.danger,
      );
      return;
    }

    Get.toNamed(Routes.CREATE_BET);
  }
}
