import 'package:get/get.dart';

import '../../../data/remote/deep_link/deep_link_service.dart';

/// Auth Controller
class AuthController extends GetxController {
  /// On init
  @override
  void onInit() {
    DeepLinkService.initBranchListener();
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
}
