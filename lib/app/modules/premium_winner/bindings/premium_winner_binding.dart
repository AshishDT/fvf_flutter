import 'package:get/get.dart';

import '../controllers/premium_winner_controller.dart';

/// PremiumWinnerBinding
class PremiumWinnerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PremiumWinnerController>(
      () => PremiumWinnerController(),
    );
  }
}
