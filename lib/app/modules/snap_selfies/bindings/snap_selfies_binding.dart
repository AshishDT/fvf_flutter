import 'package:get/get.dart';

import '../controllers/snap_selfies_controller.dart';

/// Snap selfies binding
class SnapSelfiesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SnapSelfiesController>(
      () => SnapSelfiesController(),
    );
  }
}
