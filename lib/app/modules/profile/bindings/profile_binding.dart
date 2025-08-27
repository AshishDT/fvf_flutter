import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

/// Profile binding
class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
  }
}
