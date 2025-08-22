import 'package:flutter/material.dart';
import 'package:fvf_flutter/app/data/config/logger.dart';
import 'package:fvf_flutter/app/data/local/user_provider.dart';
import 'package:fvf_flutter/app/data/models/md_user.dart';
import 'package:fvf_flutter/app/routes/app_pages.dart';
import 'package:fvf_flutter/app/ui/components/app_snackbar.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  /// Text editing controller for age input
  TextEditingController ageInputController = TextEditingController();

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
      final String? supabaseId = await signInAnonymously();

      if (supabaseId == null || supabaseId.isEmpty) {
        creatingUser(false);
        return;
      }

      final MdUser? _user = await AuthApiRepo.createUser(
        supabaseId: supabaseId,
        age: age,
      );

      if (_user != null && (_user.id?.isNotEmpty ?? false)) {
        UserProvider.onLogin(
          user: _user,
          userAuthToken: _user.token ?? '',
        );
        await Get.offAllNamed(
          Routes.CREATE_BET,
        );
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
    final String age = ageInputController.text.trim();

    if (age.isEmpty) {
      appSnackbar(
        message: 'Please enter your age',
        snackbarState: SnackbarState.info,
      );
      return;
    }

    final int ageValue = int.tryParse(age) ?? 0;

    if (ageValue < 18) {
      appSnackbar(
        message: 'You must be at least 18 years old to join.',
        snackbarState: SnackbarState.danger,
      );
      return;
    }

    createAnonymousUser(ageValue);
  }
}
