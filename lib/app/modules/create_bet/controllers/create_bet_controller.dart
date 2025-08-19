import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

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

    chatInputController.addListener(
      () {
        isMessageEntered(chatInputController.text.trim().isNotEmpty);
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
    chatInputController.dispose();
    chatInputFocusNode.dispose();
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

  /// Previous bottom inset for keyboard
  final RxDouble _prevBottomInset = 0.0.obs;

  /// Is message entered state
  RxBool isMessageEntered = false.obs;

  /// Chat input controller
  final TextEditingController chatInputController = TextEditingController();

  /// Focus node for chat input field
  final FocusNode chatInputFocusNode = FocusNode();
}
