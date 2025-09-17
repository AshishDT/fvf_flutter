import 'package:fvf_flutter/app/modules/profile/models/md_profile_args.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

/// Profile binding
class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    if (Get.arguments is MdProfileArgs) {
      Get.put(
        () => ProfileController(),
        tag: (Get.arguments as MdProfileArgs).tag,
        permanent: true,
      );
    }
  }
}
