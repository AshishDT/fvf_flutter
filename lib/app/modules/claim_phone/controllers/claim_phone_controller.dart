import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_auth/smart_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/config/logger.dart';
import '../../../data/models/md_user.dart';
import '../../../data/remote/supabse_service/supabse_service.dart';
import '../../../ui/components/app_snackbar.dart';
import '../../../utils/global_keys.dart';
import '../../create_bet/repositories/create_bet_api_repo.dart';

/// Claim Phone Controller
class ClaimPhoneController extends GetxController {
  /// Form Keys
  final GlobalKey<FormState> phoneFormKey = GlobalKey<FormState>();

  /// OTP Form Key
  final GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();

  /// Text Controllers
  final TextEditingController phoneController = TextEditingController();

  /// OTP Controller
  final TextEditingController otpController = TextEditingController();

  /// Sending OTP
  RxBool isSendingOtp = false.obs;

  /// Verifying OTP
  RxBool isVerifyingOtp = false.obs;

  /// Is Smart Auth Showed
  RxBool isSmartAuthShowed = false.obs;

  /// User claim loading
  RxBool isUserClaimLoading = false.obs;

  /// Smart auth instance
  final SmartAuth smartAuth = SmartAuth.instance;

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
      isSendingOtp(true);
      await SupaBaseService.sendOtp('+1$phone');
      return true;
    } on Exception catch (e) {
      logE('Error sending OTP: $e');
      appSnackbar(
        message: 'Failed to send OTP. Please try again.',
        snackbarState: SnackbarState.danger,
      );
      return false;
    } finally {
      isSendingOtp(false);
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
      isVerifyingOtp(true);
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
    } finally {
      isVerifyingOtp(false);
    }
  }

  /// Claim user
  Future<void> claimUser() async {
    try {
      isUserClaimLoading(true);

      final String? supabaseId = globalUser().supabaseId;
      if (supabaseId == null || supabaseId.isEmpty) {
        isUserClaimLoading(false);
        return;
      }

      final MdUser? _user = await CreateBetApiRepo.userClaim(
        phone: phoneController.text.trim(),
        countryCode: '+1',
        supabaseId: supabaseId,
      );

      if (_user != null && (_user.id?.isNotEmpty ?? false)) {
        Get.close(1);
        appSnackbar(
          message: 'Phone number claimed successfully!',
          snackbarState: SnackbarState.success,
        );
      }
    } on Exception catch (e, st) {
      logE('Error claiming user: $e');
      logE(st);
    } finally {
      isUserClaimLoading(false);
    }
  }
}
