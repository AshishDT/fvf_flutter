import 'package:fvf_flutter/app/data/remote/supabse_service/supabse_service.dart';
import 'package:fvf_flutter/app/routes/app_pages.dart';
import 'package:get/get.dart';

/// Splash Controller
class SplashController extends GetxController {
  /// On init
  @override
  void onInit() {
    Future<void>.delayed(
      const Duration(seconds: 1),
      () {
        if (SupaBaseService.isLoggedIn) {
          Get.offAllNamed(Routes.CREATE_BET);
        } else {
          Get.offAllNamed(Routes.AUTH);
        }
      },
    );
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
