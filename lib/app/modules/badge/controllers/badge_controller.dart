import 'package:fvf_flutter/app/modules/profile/models/md_badge.dart';
import 'package:get/get.dart';

/// Badge Controller
class BadgeController extends GetxController {
  /// On init
  @override
  void onInit() {
    if (Get.arguments != null) {
      badge = Get.arguments as MdBadge;
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

  /// Badge
  MdBadge badge = MdBadge();
}
