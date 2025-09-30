import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_auth/smart_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/config/logger.dart';
import '../../../data/remote/supabse_service/supabse_service.dart';
import '../../../ui/components/app_snackbar.dart';
import '../../create_bet/controllers/create_bet_controller.dart';
import '../../create_bet/repositories/create_bet_api_repo.dart';

/// Claim Phone Controller
class ClaimPhoneController extends GetxController
     {
  /// Text Controllers
  final TextEditingController phoneController = TextEditingController();

  /// OTP Controller
  final TextEditingController otpController = TextEditingController();

  /// Is Smart Auth Showed
  RxBool isSmartAuthShowed = false.obs;

  /// User claim loading
  RxBool isUserClaimLoading = false.obs;

  /// Smart auth instance
  final SmartAuth smartAuth = SmartAuth.instance;

  /// On init
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    phoneController.dispose();
    otpController.dispose();
    super.onClose();
  }

  /// Request phone hint
  Future<void> requestPhoneHint() async {
    try {
      if (isSmartAuthShowed()) {
        return;
      }

      final SmartAuthResult<String> result =
          await smartAuth.requestPhoneNumberHint();
      isSmartAuthShowed(true);

      if (result.hasData) {
        phoneController.text = result.data ?? '';
      }
    } on Exception catch (e) {
      logE('SmartAuth error: $e');
    }
  }

  /// Remove US/India country code
  String removeUSIndiaCountryCode(String input) =>
      input.replaceFirst(RegExp(r'^\+?(1|91)\s?'), '').trim();

  /// Extract Country Code (everything before last 10 digits)
  String extractCountryCode(String phoneNumber) {
    if (phoneNumber.startsWith('+') || phoneNumber.length > 10) {
      return phoneNumber.substring(0, phoneNumber.length - 10);
    }
    return '';
  }

  /// Extracts the local 10-digit number (last 10 digits)
  String extractLocalNumber(String phoneNumber) {
    if (phoneNumber.length >= 10) {
      return phoneNumber.substring(phoneNumber.length - 10);
    }
    return phoneNumber;
  }

  /// Send OTP
  Future<bool> sendOtp() async {
    String phone = phoneController.text.trim();
    if (phone.isEmpty) {
      return false;
    }

    phone = phone.replaceFirst(RegExp(r'^\+*'), '');

    logWTF('Processed Phone Number: $phone');

    try {
      await SupaBaseService.sendOtp('+1$phone');
      return true;
    } on Exception catch (e) {
      logE('Error sending OTP: $e');
      appSnackbar(
        message: 'Failed to send OTP. Please try again.',
        snackbarState: SnackbarState.danger,
      );
      return false;
    }
  }

  /// Verify OTP
  Future<bool> verifyOtp() async {
    final String phone = phoneController.text.trim();
    final String otp = otpController.text.trim();
    if (otp.isEmpty) {
      return false;
    }

    try {
      final AuthResponse res = await SupaBaseService.verifyOtp(
        phoneNumber: '+1$phone',
        token: otp,
      );

      if (res.session != null) {
        return true;
      }

      appSnackbar(
        message: 'Invalid OTP. Please try again.',
        snackbarState: SnackbarState.danger,
      );
      return false;
    } on Exception catch (e) {
      logE('Error verifying OTP: $e');
      appSnackbar(
        message: 'Failed to verify OTP. Please try again.',
        snackbarState: SnackbarState.danger,
      );
      return false;
    }
  }

  /// Claim user
  Future<void> claimUser() async {
    try {
      isUserClaimLoading(true);

      final bool? _isClaimed = await CreateBetApiRepo.userClaim(
        phone: phoneController.text.trim(),
        countryCode: '+1',
      );

      if (_isClaimed ?? false) {
        phoneController.clear();
        otpController.clear();
        Get.close(1);
        appSnackbar(
          message: 'Phone number claimed successfully!',
          snackbarState: SnackbarState.success,
        );
        Get.find<CreateBetController>().refreshProfile();
      }
    } on Exception catch (e, st) {
      logE('Error claiming user: $e');
      logE(st);
    } finally {
      isUserClaimLoading(false);
    }
  }
}
