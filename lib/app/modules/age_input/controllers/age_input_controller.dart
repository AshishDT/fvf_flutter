import 'dart:async';
import 'package:fvf_flutter/app/data/config/logger.dart';
import 'package:fvf_flutter/app/data/local/store/local_store.dart';
import 'package:fvf_flutter/app/data/local/user_provider.dart';
import 'package:fvf_flutter/app/data/models/md_user.dart';
import 'package:fvf_flutter/app/data/remote/notification_service/notification_service.dart';
import 'package:fvf_flutter/app/routes/app_pages.dart';
import 'package:fvf_flutter/app/ui/components/app_snackbar.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/remote/deep_link/deep_link_incoming_data_handler.dart';
import '../../../data/remote/notification_service/notification_actions_handler.dart';
import '../../../data/remote/supabse_service/supabse_service.dart';
import '../../auth/repositories/auth_api_repo.dart';
import '../../claim_phone/models/md_auth_data.dart';
import '../../claim_phone/repositories/claim_phone_api_repo.dart';

/// Age Input Controller
class AgeInputController extends GetxController {
  /// Observable state
  final RxBool creatingUser = false.obs;

  /// Auth data (passed via arguments)
  MdAuthData authData = MdAuthData();

  /// Selected date observable (default 18 years ago)
  final Rx<DateTime> selectedDate =
      DateTime.now().subtract(const Duration(days: 365 * 18)).obs;

  /// Is this flow from login?
  bool get isFromLogin =>
      authData.authResponse != null &&
      (authData.phone?.isNotEmpty ?? false) &&
      (authData.countryCode?.isNotEmpty ?? false);

  @override
  void onInit() {
    if (Get.arguments != null) {
      final MdAuthData _args = Get.arguments as MdAuthData;
      authData = _args;
    }

    super.onInit();
  }

  /// Get FCM token or show error snack-bar
  Future<String?> _getFcmTokenOrShowError() async {
    final String? token = await NotificationService().getToken();
    if (token == null || token.isEmpty) {
      appSnackbar(
        message: 'Something went wrong! Please try again later.',
        snackbarState: SnackbarState.danger,
      );
      return null;
    }
    logI('FCM Token: $token');
    return token;
  }

  /// Handle post login actions
  Future<void> _handlePostLogin(MdUser user) async {
    LocalStore.loginTime(DateTime.now().toIso8601String());
    UserProvider.onLogin(
      user: user,
      userAuthToken: user.token ?? '',
    );

    unawaited(
      Get.offAllNamed(Routes.CREATE_BET),
    );

    if (invitationId().isEmpty) {
      return;
    }

    if (isViewOnly()) {
      await NotificationActionsHandler.handleRoundDetails(
        roundId: invitationId(),
        isViewOnly: true,
      );
    } else {
      await joinProjectInvitation(invitationId());
    }

    invitationId('');
    isViewOnly(false);
  }

  /// Sign in anonymously with Supabase
  Future<String?> _signInAnonymously() async {
    try {
      final AuthResponse response = await SupaBaseService.signInAnonymously();
      return response.user?.id;
    } on AuthException catch (e) {
      logWTF('Error signing in anonymously: ${e.message}');
      appSnackbar(
        message: e.message,
        snackbarState: SnackbarState.danger,
      );
      return null;
    }
  }

  /// Create anonymous user
  Future<void> _createAnonymousUser() async {
    creatingUser(true);
    try {
      final String? fcmToken = await _getFcmTokenOrShowError();
      if (fcmToken == null) {
        return;
      }

      final String? supabaseId = await _signInAnonymously();
      if (supabaseId == null || supabaseId.isEmpty) {
        return;
      }

      final MdUser? user = await AuthApiRepo.createUser(
        supabaseId: supabaseId,
        date: selectedDate().toIso8601String(),
        fcmToken: fcmToken,
      );

      if (user != null && (user.id?.isNotEmpty ?? false)) {
        await _handlePostLogin(user);
      } else {
        appSnackbar(
          message: 'Failed to create user. Please try again.',
          snackbarState: SnackbarState.danger,
        );
      }
    } finally {
      creatingUser(false);
    }
  }

  /// Login user
  Future<void> _loginUser() async {
    creatingUser(true);
    try {
      final String? fcmToken = await _getFcmTokenOrShowError();
      if (fcmToken == null) {
        return;
      }

      final MdUser? user = await ClaimPhoneApiRepo.login(
        phone: authData.phone ?? '',
        phoneCode: authData.countryCode ?? '',
        fcmToken: fcmToken,
        userId: authData.authResponse?.user?.id ?? '',
        dob: selectedDate().toIso8601String(),
      );

      if (user != null && (user.id?.isNotEmpty ?? false)) {
        await _handlePostLogin(user);
      } else {
        appSnackbar(
          message: 'Oops! Something went wrong, please try again.',
          snackbarState: SnackbarState.danger,
        );
      }
    } on Exception {
      creatingUser(false);
    } finally {
      creatingUser(false);
    }
  }

  /// On Next button pressed
  void onNext() {
    final int age = _calculateAge(selectedDate.value);

    if (age < 18) {
      appSnackbar(
        message: 'You must be at least 18 years old to join.',
        snackbarState: SnackbarState.danger,
      );
      return;
    }

    if (age > 100) {
      appSnackbar(
        message: 'Please enter a valid age! It should be less than 100.',
        snackbarState: SnackbarState.info,
      );
      return;
    }

    isFromLogin ? _loginUser() : _createAnonymousUser();
  }

  /// Calculate age from birth date
  int _calculateAge(DateTime birthDate) {
    final DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}
