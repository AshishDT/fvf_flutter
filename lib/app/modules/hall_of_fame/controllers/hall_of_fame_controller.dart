import 'package:get/get.dart';
import '../../profile/models/md_badge.dart';

/// Hall of fame controller
class HallOfFameController extends GetxController {
  /// On init
  @override
  void onInit() {
    if (Get.arguments != null) {
      badges.value = Get.arguments as List<MdBadge>;
      badges.refresh();
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

  /// Badges
  RxList<MdBadge> badges = <MdBadge>[].obs;
}
