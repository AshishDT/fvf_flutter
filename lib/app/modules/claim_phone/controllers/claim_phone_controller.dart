import 'package:flutter/material.dart';
import 'package:fvf_flutter/app/data/local/user_provider.dart';
import 'package:fvf_flutter/app/data/remote/revenue_cat/revenue_cat_service.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:smart_auth/smart_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/config/logger.dart';
import '../../../data/models/md_user.dart';
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
    final String phone = phoneController.text.trim();
    if (phone.isEmpty) {
      return false;
    }

    try {
      await SupaBaseService.sendOtp('+$phone');
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
        phoneNumber: '+$phone',
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

      final String rawInput = phoneController.text.trim();

      final String phone = rawInput.substring(rawInput.length - 10);

      final String countryCode = rawInput.length > 10
          ? '+${rawInput.substring(0, rawInput.length - 10)}'
          : '+1';

      final MdUser? _user = await CreateBetApiRepo.userClaim(
        phone: phone,
        countryCode: countryCode,
      );

      if (_user != null) {
        phoneController.clear();
        otpController.clear();
        Get.close(1);
        appSnackbar(
          message: 'Phone number claimed successfully!',
          snackbarState: SnackbarState.success,
        );

        await setPurchaseLogin(
          linkSupabaseId: _user.linkSupabaseId,
          supabaseId:
              _user.supabaseId ?? UserProvider.currentUser?.supabaseId ?? '',
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

  /// Set purchase login
  Future<void> setPurchaseLogin({
    required String supabaseId,
    String? linkSupabaseId,
  }) async {
    try {
      if (supabaseId.isNotEmpty) {
        final bool isActive = await RevenueCatService.instance
            .checkUserHasSubscription(supabaseId);

        if (isActive) {
          await Purchases.logIn(supabaseId);
          logI('Logged in with supabaseId $supabaseId (active subscription)');
          return;
        }
      }

      if (linkSupabaseId != null && linkSupabaseId.isNotEmpty) {
        final bool isActive = await RevenueCatService.instance
            .checkUserHasSubscription(linkSupabaseId);

        if (isActive) {
          await Purchases.logIn(linkSupabaseId);
          logI(
              'Logged in with linkedSupabaseId $linkSupabaseId (active subscription)');
          return;
        }
      }

      await Purchases.logIn(supabaseId);
      logI(
          'Fallback: logged in with supabaseId $supabaseId (no active subscription)');
    } on Exception catch (e, st) {
      logE('Error setting RevenueCat login: $e');
      logE(st);
    }
  }
}
