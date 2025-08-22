import 'package:flutter/cupertino.dart';
import 'package:fvf_flutter/app/modules/create_bet/repositories/create_bet_api_repo.dart';
import 'package:get/get.dart';
import 'dart:math';

/// Create Bet Controller
class CreateBetController extends GetxController with WidgetsBindingObserver {
  /// On init
  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _prevBottomInset.value = View.of(Get.context!).viewInsets.bottom;
      },
    );

    getBets();

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

  /// List of questions
  RxList<String> bets = <String>[].obs;

  /// Question for the bet
  RxString bet = ''.obs;

  /// Roll dice
  void rollDice() {
    rollCounter.value++;
    enteredBet('');
    messageInputController.clear();

    Future<void>.delayed(
      const Duration(seconds: 1),
      () {
        final int index = Random().nextInt(bets.length);
        bet.value = bets[index];
        bet.refresh();
      },
    );
  }

  /// Get bets from API
  Future<void> getBets() async {
    isLoading(true);
    try {
      final List<String>? _betData = await CreateBetApiRepo.getBets();

      bets(_betData ?? <String>[]);
      bets.refresh();

      rollDice();
    } finally {
      isLoading(false);
    }
  }
}
