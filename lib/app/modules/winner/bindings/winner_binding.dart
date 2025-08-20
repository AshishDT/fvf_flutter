import 'package:get/get.dart';

import '../controllers/winner_controller.dart';

/// Winner Binding
class WinnerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WinnerController>(
      () => WinnerController(),
    );
  }
}
