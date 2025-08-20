import 'package:get/get.dart';

import '../../snap_selfies/models/md_user_selfie.dart';

/// Winner Controller
class WinnerController extends GetxController {
  /// On init
  @override
  void onInit() {
    if (Get.arguments != null) {
      final List<MdUserSelfie> _selfies = Get.arguments as List<MdUserSelfie>;

      if (_selfies.isNotEmpty) {
        _selfies.sort((MdUserSelfie a, MdUserSelfie b) =>
            a.rank?.compareTo(b.rank ?? 0) ?? 0);

        selfies.value = _selfies;
        selfies.refresh();
      }
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

  /// List of selfies taken by the user
  RxList<MdUserSelfie> selfies = <MdUserSelfie>[].obs;

  /// Get first rank
  Rx<MdUserSelfie> get firstRank =>
      selfies().firstWhere((u) => u.rank == 1).obs;

  /// Get second rank
  Rx<MdUserSelfie> get secondRank =>
      selfies().firstWhere((u) => u.rank == 2).obs;

  /// Get third rank
  Rx<MdUserSelfie> get thirdRank =>
      selfies().firstWhere((u) => u.rank == 3).obs;
}
