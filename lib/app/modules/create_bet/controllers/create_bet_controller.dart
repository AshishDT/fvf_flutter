import 'package:flutter/cupertino.dart';
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
  RxInt turns = 0.obs;

  /// Is rolling state
  RxBool isDiceRolling = false.obs;

  /// Question for the bet
  RxString question = 'Most likely to start an OF?'.obs;

  /// Roll dice
  void rollDice() {
    turns.value++;
    enteredBet('');
    messageInputController.clear();

    Future<void>.delayed(
      const Duration(seconds: 1),
      () {
        final int index = Random().nextInt(questions.length);
        question.value = questions[index];
        question.refresh();
      },
    );
  }

  /// List of questions for the bet
  final List<String> questions = <String>[
    'Whose smile could light up a whole room?',
    'Who has the most photogenic pose?',
    'Best dressed in this pic?',
    'Whose eyes steal the spotlight?',
    'Who looks like they walked out of a magazine?',
    'Cutest candid caught on camera?',
    'Who’s serving the strongest selfie game?',
    'Which picture deserves to be framed?',
    'Who has the most iconic hairstyle here?',
    'Who looks effortlessly aesthetic?',
  ];
}
