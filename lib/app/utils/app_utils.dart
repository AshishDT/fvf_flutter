import 'package:get/get.dart';
import 'package:flutter/services.dart';

/// To hide the keyboard
void hideKeyboard() {
  Get.focusScope?.unfocus();
}

/// Haptic feedback for light impact
void lightHapticFeedback() {
  HapticFeedback.lightImpact();
}
