import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/local/store/local_store.dart';
import '../views/phone_number_sheet.dart';
import 'claim_phone_controller.dart';

/// Phone Claim Service
class PhoneClaimService {
  /// Opens the claim flow if criteria match
  static Future<void> open({
    required int currentRound,
    required bool hasSubmittedFirstRoundPhoto,
    required String? userName,
  }) async {
    // Basic eligibility check
    if (!hasSubmittedFirstRoundPhoto ||
        currentRound <= 1 ||
        (userName?.isEmpty ?? true)) {
      return;
    }

    final int lastAttemptRound = LocalStore.phoneClaimLastRound() ?? 0;
    final int attemptCount = LocalStore.phoneClaimAttempt() ?? 0;

    final bool isFirstAttempt = attemptCount == 0;

    if (!isFirstAttempt) {
      final int minRoundsGap = 5 * (1 << (attemptCount - 1));
      if (currentRound - lastAttemptRound < minRoundsGap) {
        // Deceleration: wait until enough rounds have passed
        return;
      }
    }

    LocalStore.phoneClaimAttempt(attemptCount + 1);
    LocalStore.phoneClaimLastRound(currentRound);
    LocalStore.phoneClaimLastTime(DateTime.now().toIso8601String());

    // Show Phone Sheet
    await _showPhoneSheet();
  }

  /// Internal method to show phone sheet and OTP flow
  static Future<bool> _showPhoneSheet() async {
    final ClaimPhoneController controller = Get.put(ClaimPhoneController());

    await showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const PhoneNumberSheet(),
    );

    return controller.isUserClaimLoading.isFalse;
  }
}
