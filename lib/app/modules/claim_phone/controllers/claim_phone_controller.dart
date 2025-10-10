import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fvf_flutter/app/data/models/md_user.dart';
import 'package:fvf_flutter/app/modules/claim_phone/models/md_check_phone.dart';
import 'package:get/get.dart';
import 'package:smart_auth/smart_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/config/logger.dart';
import '../../../data/local/store/local_store.dart';
import '../../../data/local/user_provider.dart';
import '../../../data/remote/deep_link/deep_link_incoming_data_handler.dart';
import '../../../data/remote/notification_service/notification_actions_handler.dart';
import '../../../data/remote/notification_service/notification_service.dart';
import '../../../data/remote/supabse_service/supabse_service.dart';
import '../../../routes/app_pages.dart';
import '../../../ui/components/app_snackbar.dart';
import '../../create_bet/controllers/create_bet_controller.dart';
import '../../create_bet/repositories/create_bet_api_repo.dart';
import '../models/md_auth_data.dart';
import '../models/md_country_info.dart';
import '../models/md_phone_data.dart';
import '../repositories/claim_phone_api_repo.dart';

/// Claim Phone Controller
class ClaimPhoneController extends GetxController {
  /// Text Controllers
  final TextEditingController phoneController = TextEditingController();

  /// OTP Controller
  final TextEditingController otpController = TextEditingController();

  /// Is Smart Auth Showed
  RxBool isSmartAuthShowed = false.obs;

  /// Is from login
  RxBool isFromLogin = false.obs;

  /// Is from menu
  RxBool isFromMenu = false.obs;

  /// Smart auth instance
  final SmartAuth smartAuth = SmartAuth.instance;

  /// Show resend otp
  RxBool showResendOtp = false.obs;

  /// Validator key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Otp validator key
  final GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();

  /// Selected country
  Rx<MdPhoneData> country = MdPhoneData(
    phoneCode: '1',
    flagEmoji: '🇺🇸',
    countryCode: 'US',
  ).obs;

  /// On init
  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        requestPhoneHint();
      },
    );
    super.onInit();
  }

  @override
  void onClose() {
    phoneController.dispose();
    otpController.dispose();
    super.onClose();
  }

  /// Invitation ID
  Future<void> resetAllFields() async {
    phoneController.clear();
    otpController.clear();
    isSmartAuthShowed(false);
    isFromLogin(false);
    isFromMenu(false);
    country(
      MdPhoneData(
        phoneCode: '1',
        countryCode: 'US',
        flagEmoji: '🇺🇸',
      ),
    );
    formKey.currentState?.reset();
    otpFormKey.currentState?.reset();
    showResendOtp(false);
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

        final CountryInfo info = getCountryInfoFromPhoneCode(phoneCode);

        final MdPhoneData _selectedCountry = MdPhoneData(
          phoneCode: '$phoneCode',
          countryCode: info.countryCode,
          flagEmoji: info.flagEmoji,
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
    final String digits = phoneNumber.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 10) {
      final String code = digits.substring(0, digits.length - 10);
      if (code.isEmpty) {
        return '1';
      } else {
        return code;
      }
    }
    return '1';
  }

  /// Extracts only the local 10-digit number.
  String extractLocalNumber(String phoneNumber) {
    final String digits = phoneNumber.replaceAll(RegExp(r'\D'), '');
    if (digits.length >= 10) {
      return digits.substring(digits.length - 10);
    }
    return digits;
  }

  /// Send OTP
  Future<bool> sendOtp() async {
    final String phone = phoneController.text.trim();
    if (phone.isEmpty) {
      return false;
    }

    final String countryCode = country().phoneCode;

    try {
      await SupaBaseService.sendOtp(
        phoneNumber: '+$countryCode$phone',
        fromLogin: isFromLogin(),
        fromMenu: isFromMenu(),
      );
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
  Future<AuthResponse?> verifyOtp() async {
    final String phone = phoneController.text.trim();
    final String otp = otpController.text.trim();
    if (otp.isEmpty) {
      return null;
    }

    final String countryCode = country().phoneCode;

    try {
      final AuthResponse res = await SupaBaseService.verifyOtp(
        phoneNumber: '+$countryCode$phone',
        token: otp,
        fromLogin: isFromLogin(),
        fromMenu: isFromMenu(),
      );

      if (res.session != null) {
        return res;
      }

      showResendOtp(true);
      appSnackbar(
        message: 'Invalid OTP. Please try again.',
        snackbarState: SnackbarState.danger,
      );
      return null;
    } on AuthException catch (e) {
      showResendOtp(true);
      logE('Error verifying OTP: $e');
      appSnackbar(
        message: e.message.isNotEmpty
            ? '${e.message}'
            : 'Failed to verify OTP. Please try again.',
        snackbarState: SnackbarState.danger,
      );
      return null;
    }
  }

  /// Claim user
  Future<void> claimUser() async {
    try {
      final String phone = phoneController.text.trim();
      final String countryCode = country().phoneCode;

      final bool? isClaimed = await CreateBetApiRepo.userClaim(
        phone: phone,
        countryCode: '+$countryCode',
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
    }
  }

  /// Open URL
  Future<void> openUrl(String url) async {
    final Uri _url = Uri.parse(url);
    final bool _launched = await launchUrl(
      _url,
      mode: LaunchMode.externalApplication,
    );

    if (!_launched) {
      appSnackbar(
        message: 'Could not launch $url',
        snackbarState: SnackbarState.danger,
      );
    }
  }

  /// After verify OTP
  Future<void> afterVerifyOtp({
    required AuthResponse authResponse,
  }) async {
    if (isFromLogin()) {
      await checkPhone(authResponse: authResponse);
      return;
    }

    await claimUser();
  }

  /// Check phone
  Future<void> checkPhone({
    required AuthResponse authResponse,
  }) async {
    try {
      final String phone = phoneController.text.trim();
      final String countryCode = country().phoneCode;

      final MdCheckPhone? _checkPhone = await ClaimPhoneApiRepo.checkPhone(
        phone: phone,
        phoneCode: '+$countryCode',
      );

      final String? _fcmToken = await NotificationService().getToken();
      logI('FCM Token: $_fcmToken');

      if (_fcmToken == null || _fcmToken.isEmpty) {
        appSnackbar(
          message: 'Something went wrong! Please try again later.',
          snackbarState: SnackbarState.danger,
        );
        return;
      }

      if (_checkPhone?.isExist ?? false) {
        final MdUser? _user = await ClaimPhoneApiRepo.login(
          phone: phone,
          phoneCode: '+$countryCode',
          fcmToken: _fcmToken,
          userId: _checkPhone?.id ?? '',
        );

        if (_user != null && (_user.id?.isNotEmpty ?? false)) {
          LocalStore.loginTime(DateTime.now().toIso8601String());
          UserProvider.onLogin(
            user: _user,
            userAuthToken: _user.token ?? '',
          );

          if (isFromMenu()) {
            Get.close(0);
            Get.find<CreateBetController>().refreshProfile();
            appSnackbar(
              message: (_user.username?.isNotEmpty ?? false)
                  ? 'Login successful! Welcome back ${_user.username ?? ''}'
                  : 'Login successful! Phone number linked.',
              snackbarState: SnackbarState.success,
            );
            return;
          }

          unawaited(
            Get.offAllNamed(
              Routes.CREATE_BET,
            ),
          );

          appSnackbar(
            message: (_user.username?.isNotEmpty ?? false)
                ? 'Login successful! Welcome back ${_user.username ?? ''}'
                : 'Login successful! Phone number linked.',
            snackbarState: SnackbarState.success,
          );

          if (invitationId().isNotEmpty) {
            if (isViewOnly()) {
              await NotificationActionsHandler.handleRoundDetails(
                roundId: invitationId(),
                isViewOnly: true,
              );
              invitationId('');
              isViewOnly(false);
              return;
            }

            await joinProjectInvitation(invitationId());
            invitationId('');
            isViewOnly(false);
          }
        } else {
          appSnackbar(
            message: 'Oops! Something went wrong, please try again.',
            snackbarState: SnackbarState.danger,
          );
        }
      } else {
        if (isFromMenu()) {
          final MdUser? _user = await ClaimPhoneApiRepo.login(
            phone: phone,
            phoneCode: '+$countryCode',
            fcmToken: _fcmToken,
            userId: authResponse.user?.id ?? '',
            dob: UserProvider.currentUser?.dob?.toIso8601String(),
          );

          if (_user != null) {
            Get.close(0);
            LocalStore.loginTime(DateTime.now().toIso8601String());
            UserProvider.onLogin(
              user: _user,
              userAuthToken: _user.token ?? '',
            );

            appSnackbar(
              message: 'Login successful! Phone number linked.',
              snackbarState: SnackbarState.success,
            );
            Get.find<CreateBetController>().refreshProfile();
          } else {
            appSnackbar(
              message: 'Oops! Something went wrong, please try again.',
              snackbarState: SnackbarState.danger,
            );
          }

          return;
        }

        Get.close(0);
        unawaited(
          Get.toNamed(
            Routes.AGE_INPUT,
            arguments: MdAuthData(
              authResponse: authResponse,
              phone: phone,
              countryCode: '+$countryCode',
            ),
          ),
        );
      }
    } on Exception catch (e) {
      logE('Error checking phone: $e');
    }
  }

  /// Join project invitation
  Future<void> resendOtp() async {
    final String phone = phoneController.text.trim();
    if (phone.isEmpty) {
      return;
    }

    otpController.clear();
    otpFormKey.currentState?.reset();
    otpFormKey.currentState?.save();

    final String countryCode = country().phoneCode;

    try {
      await SupaBaseService.sendOtp(
        phoneNumber: '+$countryCode$phone',
        fromLogin: isFromLogin(),
        fromMenu: isFromMenu(),
      );
      showResendOtp(false);
    } on Exception catch (e) {
      logE('Error resending OTP: $e');
      appSnackbar(
        message: 'Failed to resend OTP. Please try again.',
        snackbarState: SnackbarState.danger,
      );
    }
  }
}
