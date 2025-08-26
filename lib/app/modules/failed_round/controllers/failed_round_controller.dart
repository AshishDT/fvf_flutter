import 'package:fvf_flutter/app/modules/create_bet/models/md_round.dart';
import 'package:get/get.dart';

/// Failed round controller
class FailedRoundController extends GetxController {
  /// On init
  @override
  void onInit() {
    if (Get.arguments != null) {
      if (Get.arguments['reason'] != null) {
        reason = Get.arguments['reason'] as String;
      }

      if (Get.arguments['sub_reason'] != null) {
        subReason = Get.arguments['sub_reason'] as String;
      }

      if (Get.arguments['round'] != null) {
        round = Get.arguments['round'] as MdRound;
      }
    }
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

  /// Reason for failure
  String reason = '';

  /// Sub-reason for failure
  String subReason = '';

  /// Round
  MdRound round = MdRound();

}
