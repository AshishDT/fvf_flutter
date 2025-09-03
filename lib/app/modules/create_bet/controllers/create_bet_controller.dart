import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fvf_flutter/app/data/config/logger.dart';
import 'package:fvf_flutter/app/data/local/store/local_store.dart';
import 'package:fvf_flutter/app/data/models/md_user.dart';
import 'package:fvf_flutter/app/data/remote/supabse_service/supabse_service.dart';
import 'package:fvf_flutter/app/modules/ai_choosing/enums/round_status_enum.dart';
import 'package:fvf_flutter/app/modules/create_bet/models/md_bet.dart';
import 'package:fvf_flutter/app/modules/create_bet/models/md_round.dart';
import 'package:fvf_flutter/app/modules/create_bet/repositories/create_bet_api_repo.dart';
import 'package:fvf_flutter/app/ui/components/app_snackbar.dart';
import 'package:get/get.dart';
import 'package:gotrue/src/types/auth_response.dart';
import 'package:smart_auth/smart_auth.dart';

import '../../../data/local/user_provider.dart';
import '../../../data/models/md_join_invitation.dart';
import '../../../data/remote/deep_link/deep_link_service.dart';
import '../../../routes/app_pages.dart';
import '../../profile/models/md_profile.dart';
import '../../profile/repositories/profile_api_repo.dart';
import '../models/md_participant.dart';

/// Create Bet Controller
class CreateBetController extends GetxController with WidgetsBindingObserver {
  /// Scaffold key
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  /// Form Key
  final GlobalKey<FormState> phoneFormKey = GlobalKey<FormState>();

  /// OTP Form Key
  final GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();

  /// Phone controller
  final TextEditingController phoneController = TextEditingController();

  /// OTP controller
  final TextEditingController otpController = TextEditingController();

  /// isSendingOtp
  final RxBool isSendingOtp = false.obs;

  /// isVerifyingOtp
  final RxBool isVerifyingOtp = false.obs;

  /// Smart auth instance
  final SmartAuth smartAuth = SmartAuth.instance;

  /// isSmartAuthShowed
  RxBool isSmartAuthShowed = false.obs;

  /// Is User Claim Loading
  RxBool isUserClaimLoading = true.obs;

  /// On init
  @override
  void onInit() {
    DeepLinkService.initBranchListener();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _prevBottomInset.value = View.of(Get.context!).viewInsets.bottom;
      },
    );

    getBets();
    getUser();

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
    WidgetsBinding.instance.removeObserver(this);
    phoneController.dispose();
    otpController.dispose();
    super.onClose();
  }

  @override
  void didChangeMetrics() {
    final double currentViewInsets = View.of(Get.context!).viewInsets.bottom;

    if (_prevBottomInset() > 0 && currentViewInsets == 0) {
      if (Get.isOverlaysOpen) {
        Get.back();
      }
    }

    _prevBottomInset.value = currentViewInsets;
  }

  /// Observable to track keyboard visibility
  RxBool isKeyboardVisible = false.obs;

  /// Entered bet
  RxString enteredBet = ''.obs;

  /// Previous bottom inset for keyboard
  final RxDouble _prevBottomInset = 0.0.obs;

  /// Text editing controller for chat input field
  TextEditingController messageInputController = TextEditingController();

  /// Number of turns for the dice
  RxInt rollCounter = 0.obs;

  /// Is loading
  RxBool isLoading = true.obs;

  /// Is create round loading
  RxBool createRoundLoading = false.obs;

  /// User profile
  Rx<MdProfile> profile = MdProfile().obs;

  /// All bets fetched from API (original copy)
  final RxList<MdBet> _allBets = <MdBet>[].obs;

  /// Remaining bets pool
  final RxList<MdBet> _betsPool = <MdBet>[].obs;

  /// Question for the bet (currently shown)
  RxString bet = ''.obs;

  /// Show next bet when rolling dice
  void rollDice() {
    if (createRoundLoading()) {
      appSnackbar(
        message: 'Please wait, creating round...',
        snackbarState: SnackbarState.warning,
      );
      return;
    }

    if (_betsPool.isEmpty && _allBets.isNotEmpty) {
      _betsPool.assignAll(_allBets);
    }

    showNextBet();
  }

  /// Get bets from API
  Future<void> getBets() async {
    isLoading(true);
    try {
      final String? savedBetsJson = LocalStore.betsJson();
      final String? betValidTo = LocalStore.betValidTo();

      final DateTime now = DateTime.now();
      final DateTime? validTo =
          betValidTo != null ? DateTime.tryParse(betValidTo)?.toLocal() : null;
      if (savedBetsJson != null && validTo != null && validTo.isAfter(now)) {
        final List<dynamic> decoded = jsonDecode(savedBetsJson);
        final List<MdBet> savedBets =
            decoded.map((e) => MdBet.fromJson(e)).toList();

        _allBets.assignAll(savedBets);
        _betsPool.assignAll(savedBets);

        Future<void>.delayed(
          const Duration(milliseconds: 300),
          () {
            showNextBet();
          },
        );
        return;
      }

      final List<MdBet>? bets = await CreateBetApiRepo.getQuestion();

      if (bets != null && bets.isNotEmpty) {
        _allBets.assignAll(bets);
        _betsPool.assignAll(bets);

        showNextBet();

        final String betsJsonStr =
            jsonEncode(bets.map((b) => b.toJson()).toList());

        LocalStore.betsJson(betsJsonStr);
        LocalStore.betValidTo(bets.first.validTo?.toIso8601String() ?? '');
      }
    } finally {
      isLoading(false);
    }
  }

  /// Show next bet from the pool
  void showNextBet() {
    if (_betsPool.isEmpty) {
      bet.value = '';
      return;
    }

    rollCounter.value++;

    final int randomIndex = _betsPool.length > 1
        ? (DateTime.now().millisecondsSinceEpoch % _betsPool.length)
        : 0;

    final MdBet nextBet = _betsPool.removeAt(randomIndex);

    bet.value = nextBet.question ?? '';

    enteredBet('');
    messageInputController.clear();
  }

  /// On bet pressed
  Future<void> onBetPressed() async {
    createRoundLoading(true);

    try {
      final String prompt =
          enteredBet().trim().isNotEmpty ? enteredBet() : bet();

      final bool isCustomPrompt = enteredBet().trim().isNotEmpty &&
          messageInputController.text.trim().isNotEmpty;

      final MdRound? _round = await CreateBetApiRepo.createRound(
        prompt: prompt,
        isCustomPrompt: isCustomPrompt,
      );

      if (_round != null) {
        unawaited(
          Get.toNamed(
            Routes.SNAP_SELFIES,
            arguments: MdJoinInvitation(
              id: _round.id ?? '',
              createdAt: _round.createdAt?.toIso8601String(),
              type: _round.id,
              prompt: _round.prompt ?? '',
              isCustomPrompt: _round.isCustomPrompt ?? false,
              isActive: _round.isActive ?? false,
              isDeleted: _round.isDeleted ?? false,
              status: _round.status?.value,
              updatedAt: _round.updatedAt?.toIso8601String(),
              roundJoinedEndAt: _round.roundJoinedEndAt,
              previousParticipants: _round.previousParticipants,
              participants: <MdParticipant>[
                MdParticipant(
                  createdAt: DateTime.now().toIso8601String(),
                  id: _round.host?.id ?? '',
                  isActive: true,
                  isDeleted: false,
                  isHost: true,
                  joinedAt: DateTime.now().toIso8601String(),
                  userData: _round.host,
                ),
              ],
              host: _round.host,
            ),
          ),
        );

        appSnackbar(
          message:
              'Round created successfully! for "$prompt", please pick a crew.',
          snackbarState: SnackbarState.success,
        );
      }
    } finally {
      createRoundLoading(false);
    }
  }

  /// User profile
  Future<void> getUser() async {
    try {
      final MdProfile? _user = await ProfileApiRepo.getUser();
      if (_user != null) {
        profile(_user);

        final String? userAuthToken = UserProvider.authToken;

        UserProvider.onLogin(
          user: profile().user!,
          userAuthToken: userAuthToken ?? '',
        );
      }
    } on Exception catch (e, st) {
      logE('Error getting user: $e');
      logE(st);
    }
  }

  /// Request phone hint
  Future<void> requestPhoneHint(TextEditingController controller) async {
    try {
      if (isSmartAuthShowed()) {
        return;
      }
      final SmartAuthResult<String> result =
          await smartAuth.requestPhoneNumberHint();
      isSmartAuthShowed(true);
      if (result.hasData) {
        controller.text = result.data ?? '';
      }
    } catch (e) {
      logE('SmartAuth error: $e');
    }
  }

  /// Remove US/India country code from phone number
  String removeUSIndiaCountryCode(String input) =>
      input.replaceFirst(RegExp(r'^\+?(1|91)\s?'), '').trim();

  /// Send OTP
  Future<bool> sendOtp() async {
    String phone = phoneController.text.trim();
    if (phone.isEmpty) {
      return false;
    }

    phone = phone.replaceFirst(RegExp(r'^\+*'), '');
    try {
      isSendingOtp(true);
      await SupaBaseService.sendOtp('+$phone');
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
        phoneNumber: phone,
        token: otp,
      );
      if (res.session != null) {
        return true;
      } else {
        appSnackbar(
          message: 'Invalid OTP. Please try again.',
          snackbarState: SnackbarState.danger,
        );
        return false;
      }
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
  Future<void> claimUser({
    required String phone,
    required String countryCode,
  }) async {
    try {
      isUserClaimLoading(true);
      final String? supabaseId = globalUser().supabaseId;

      if (supabaseId == null && (supabaseId?.isEmpty ?? true)) {
        isUserClaimLoading(false);
        return;
      }

      countryCode = countryCode.replaceFirst(RegExp(r'^\+*'), '');
      final MdUser? _user = await CreateBetApiRepo.userClaim(
        phone: phone,
        countryCode: '+$countryCode',
        supabaseId: supabaseId ?? '',
      );

      if (_user != null && (_user.id?.isNotEmpty ?? false)) {
        Get.close(1);
      }
    } on Exception catch (e, st) {
      logE('Error getting user: $e');
      logE(st);
    } finally {
      isUserClaimLoading(false);
    }
  }

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
}
