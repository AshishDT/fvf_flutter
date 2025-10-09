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

  /// Observable to track if user creation is in progress
  RxBool creatingUser = false.obs;

  /// Selected date observable
  Rx<DateTime> selectedDate = DateTime.now().obs;

  /// Sign in anonymously
  Future<String?> signInAnonymously() async {
    try {
      final AuthResponse _authResponse =
          await SupaBaseService.signInAnonymously();

      final User? user = _authResponse.user;

      if (user != null) {
        return user.id;
      }

      return null;
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
  Future<void> createAnonymousUser(int age) async {
    creatingUser(true);
    try {
      final String? _fcmToken = await NotificationService().getToken();
      logI('FCM Token: $_fcmToken');

      if (_fcmToken == null || _fcmToken.isEmpty) {
        appSnackbar(
          message: 'Something went wrong! Please try again later.',
          snackbarState: SnackbarState.danger,
        );
        return;
      }

      final String? supabaseId = await signInAnonymously();

      if (supabaseId == null || supabaseId.isEmpty) {
        creatingUser(false);
        return;
      }

      final MdUser? _user = await AuthApiRepo.createUser(
        supabaseId: supabaseId,
        age: age,
        fcmToken: _fcmToken,
      );

      if (_user != null && (_user.id?.isNotEmpty ?? false)) {
        LocalStore.loginTime(DateTime.now().toIso8601String());
        UserProvider.onLogin(
          user: _user,
          userAuthToken: _user.token ?? '',
        );
        unawaited(
          Get.offAllNamed(
            Routes.CREATE_BET,
          ),
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
          message: 'Failed to create user. Please try again.',
          snackbarState: SnackbarState.danger,
        );
      }
    } finally {
      creatingUser(false);
    }
  }

  /// Callback for when the "Next" button is pressed
  void onNext() {
    final DateTime birthDate = selectedDate.value;

    final DateTime today = DateTime.now();
    int ageValue = today.year - birthDate.year;

    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      ageValue--;
    }

    if (ageValue < 18) {
      appSnackbar(
        message: 'You must be at least 18 years old to join.',
        snackbarState: SnackbarState.danger,
      );
      return;
    }

    if (ageValue > 100) {
      appSnackbar(
        message: 'Please enter a valid age! It should be less than 100.',
        snackbarState: SnackbarState.info,
      );
      return;
    }

    createAnonymousUser(ageValue);
  }
}
