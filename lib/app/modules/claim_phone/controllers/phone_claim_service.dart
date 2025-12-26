import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/global_keys.dart';
import '../views/phone_number_sheet.dart';
import 'claim_phone_controller.dart';

/// Phone Claim Service
class PhoneClaimService {
  /// Opens the claim flow if criteria match
  static Future<void> open({
    bool fromLogin = false,
    bool fromMenu = false,
  }) async {
    if (fromLogin) {
      await _showPhoneSheet(
        isFromLogin: true,
        fromMenu: fromMenu,
      );
      return;
    }

    final String? phone = globalUser().phone;

    final bool? isClaimed = globalUser().isClaim;

    final bool isAlreadyClaimed =
        (phone != null && phone.isNotEmpty) && (isClaimed ?? false);

    if (isAlreadyClaimed) {
      return;
    }

    // Show Phone Sheet
    await _showPhoneSheet();
  }

  /// Internal method to show phone sheet and OTP flow
  static Future<void> _showPhoneSheet({
    bool isFromLogin = false,
    bool fromMenu = false,
  }) async {
    final ClaimPhoneController controller = Get.put(ClaimPhoneController());

    await controller.resetAllFields();

    controller.isFromLogin(isFromLogin);
    controller.isFromLogin.refresh();
    controller.isFromMenu(fromMenu);
    controller.isFromMenu.refresh();

    await showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const PhoneNumberSheet(),
    );
  }
}
