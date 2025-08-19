import 'package:get/get.dart';

import '../controllers/ai_choosing_controller.dart';

class AiChoosingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AiChoosingController>(
      () => AiChoosingController(),
    );
  }
}
