import 'package:country_picker/country_picker.dart';
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
class ClaimPhoneController extends GetxController {
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

  /// Selected country
  Rx<Country> country = Country(
    phoneCode: '1',
    countryCode: 'US',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'United States',
    example: '2015550123',
    displayName: 'United States (US) +1',
    displayNameNoCountryCode: 'United States (US)',
    e164Key: '1-US-0',
  ).obs;

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
        final String phoneCode = extractCountryCode(result.data ?? '1');

        final String localNumber = extractLocalNumber(result.data ?? '');

        final Country _selectedCountry = Country(
          phoneCode: '$phoneCode',
          countryCode: 'US',
          e164Sc: 0,
          geographic: true,
          level: 1,
          name: 'United States',
          example: '2015550123',
          displayName: 'United States (US) +1',
          displayNameNoCountryCode: 'United States (US)',
          e164Key: '1-US-0',
        );

        country(_selectedCountry);
        country.refresh();

        phoneController.text = localNumber;
      }
    } on Exception catch (e) {
      logE('SmartAuth error: $e');
    }
  }

  /// Extract Country Code (everything before last 10 digits)
  String extractCountryCode(String phoneNumber) {
    if (phoneNumber.startsWith('+') || phoneNumber.length > 10) {
      return phoneNumber.substring(0, phoneNumber.length - 10);
    }
    return '1';
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
    final String phone = phoneController.text.trim();
    if (phone.isEmpty) {
      return false;
    }

    final String countryCode = country().phoneCode;

    try {
      await SupaBaseService.sendOtp('+$countryCode$phone');
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

    final String countryCode = country().phoneCode;

    try {
      final AuthResponse res = await SupaBaseService.verifyOtp(
        phoneNumber: '+$countryCode$phone',
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
    } on AuthException catch (e) {
      logE('Error verifying OTP: $e');
      appSnackbar(
        message: e.message.isNotEmpty
            ? '${e.message}'
            : 'Failed to verify OTP. Please try again.',
        snackbarState: SnackbarState.danger,
      );
      return false;
    }
  }

  /// Claim user
  Future<void> claimUser() async {
    try {
      isUserClaimLoading(true);

      final String phone = phoneController.text.trim();
      final String countryCode = country().phoneCode;

      final bool? isClaimed = await CreateBetApiRepo.userClaim(
        phone: phone,
        countryCode: countryCode,
      );

      if (isClaimed ?? false) {
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
