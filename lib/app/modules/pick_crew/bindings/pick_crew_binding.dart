import 'package:get/get.dart';

import '../controllers/pick_crew_controller.dart';

/// Pick crew binding
class PickCrewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PickCrewController>(
      () => PickCrewController(),
    );
  }
}
