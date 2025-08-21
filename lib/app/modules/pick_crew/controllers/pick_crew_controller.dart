import 'package:fvf_flutter/app/ui/components/app_snackbar.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../../routes/app_pages.dart';

/// Pick crew controller
class PickCrewController extends GetxController {
  /// On init
  @override
  void onInit() {
    if (Get.arguments != null) {
      bet.value = Get.arguments as String;
      bet.refresh();
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

  /// Observable for bet text
  RxString bet = ''.obs;

  /// Share text
  void shareUri() {
    final Uri uri = Uri.parse('https://example.com/some-page');

    SharePlus.instance
        .share(
      ShareParams(
        uri: uri,
        title: 'Slay Crew',
        subject: 'Slay Crew Invitation',
      ),
    )
        .then(
      (ShareResult result) {
        if (result.status == ShareResultStatus.success) {
          appSnackbar(
            message: 'Invitation shared successfully!',
            snackbarState: SnackbarState.success,
          );
          Get.toNamed(
            Routes.SNAP_SELFIES,
            arguments: bet.value,
          );
        }
      },
    );
  }
}
