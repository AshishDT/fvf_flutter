import 'package:get/get.dart';

import '../controllers/failed_round_controller.dart';

/// Failed round bindings
class FailedRoundBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FailedRoundController>(
      () => FailedRoundController(),
    );
  }
}
