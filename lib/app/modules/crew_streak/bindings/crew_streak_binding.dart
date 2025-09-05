import 'package:get/get.dart';

import '../controllers/crew_streak_controller.dart';

class CrewStreakBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CrewStreakController>(
      () => CrewStreakController(),
    );
  }
}
