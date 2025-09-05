import 'package:get/get.dart';

import '../controllers/hall_of_fame_controller.dart';

/// Hall of fame binding
class HallOfFameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HallOfFameController>(
      () => HallOfFameController(),
    );
  }
}
