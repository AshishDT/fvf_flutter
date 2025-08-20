import 'package:get/get.dart';

import '../controllers/camera_controller.dart';

/// Centralized dependency injection for the Camera module.
class CameraBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PickSelfieCameraController>(
      () => PickSelfieCameraController(),
    );
  }
}
