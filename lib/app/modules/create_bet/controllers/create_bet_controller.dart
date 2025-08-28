import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fvf_flutter/app/data/config/logger.dart';
import 'package:fvf_flutter/app/modules/ai_choosing/enums/round_status_enum.dart';
import 'package:fvf_flutter/app/modules/create_bet/models/md_bet.dart';
import 'package:fvf_flutter/app/modules/create_bet/models/md_round.dart';
import 'package:fvf_flutter/app/modules/create_bet/repositories/create_bet_api_repo.dart';
import 'package:fvf_flutter/app/ui/components/app_snackbar.dart';
import 'package:get/get.dart';
import 'package:smart_auth/smart_auth.dart';

import '../../../data/models/md_join_invitation.dart';
import '../../../data/remote/deep_link/deep_link_service.dart';
import '../../../routes/app_pages.dart';
import '../models/md_participant.dart';

/// Create Bet Controller
class CreateBetController extends GetxController with WidgetsBindingObserver {
  /// Scaffold key
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  /// Phone controller
  final TextEditingController phoneController = TextEditingController();

  /// Smart auth instance
  final SmartAuth smartAuth = SmartAuth.instance;

  /// isSmartAuthShowed
  RxBool isSmartAuthShowed = false.obs;

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

    rollDice(
      fromInit: true,
    );

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
    messageInputFocusNode.dispose();
    super.onClose();
  }

  @override
  void didChangeMetrics() {
    final double currentViewInsets = View.of(Get.context!).viewInsets.bottom;

    if (_prevBottomInset() > 0 && currentViewInsets == 0) {
      Get.back();
    }

    _prevBottomInset.value = currentViewInsets;
  }

  /// Observable to track keyboard visibility
  RxBool isKeyboardVisible = false.obs;

  /// Entered bet
  RxString enteredBet = ''.obs;

  /// Previous bottom inset for keyboard
  final RxDouble _prevBottomInset = 0.0.obs;

  /// Focus node for chat input field
  final FocusNode messageInputFocusNode = FocusNode();

  /// Text editing controller for chat input field
  TextEditingController messageInputController = TextEditingController();

  /// Number of turns for the dice
  RxInt rollCounter = 0.obs;

  /// Is loading
  RxBool isLoading = true.obs;

  /// Is create round loading
  RxBool createRoundLoading = false.obs;

  /// Question for the bet
  RxString bet = ''.obs;

  /// Roll dice
  void rollDice({
    bool fromInit = false,
  }) {
    if (createRoundLoading()) {
      appSnackbar(
        message: 'Please wait, creating round...',
        snackbarState: SnackbarState.warning,
      );
      return;
    }

    getBets(
      fromInit: fromInit,
    );
  }

  /// Get bets from API
  Future<void> getBets({
    bool fromInit = false,
  }) async {
    if (!fromInit) {
      rollCounter.value++;
    }

    isLoading(true);
    try {
      if (fromInit) {
        Future<void>.delayed(
          const Duration(milliseconds: 300),
          () {
            rollCounter.value++;
          },
        );
      }
      final MdBet? _bet = await CreateBetApiRepo.getQuestion();

      if (_bet != null && _bet.question != null && _bet.question!.isNotEmpty) {
        bet.value = _bet.question!;
      }

      enteredBet('');
      messageInputController.clear();
    } finally {
      isLoading(false);
    }
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
        logI('Phone number hint: ${result.data}');
        // final String phone = removeUSIndiaCountryCode(result.data ?? '');
        controller.text = result.data ?? '';
      }
    } catch (e) {
      logE('SmartAuth error: $e');
    }
  }

  /// Remove US/India country code from phone number
  String removeUSIndiaCountryCode(String input) =>
      input.replaceFirst(RegExp(r'^\+?(1|91)\s?'), '').trim();
}
