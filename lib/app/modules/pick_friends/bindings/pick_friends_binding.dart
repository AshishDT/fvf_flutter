import 'package:get/get.dart';

import '../controllers/pick_friends_controller.dart';

/// Binding for PickFriends
class PickFriendsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PickFriendsController>(
      () => PickFriendsController(),
    );
  }
}
