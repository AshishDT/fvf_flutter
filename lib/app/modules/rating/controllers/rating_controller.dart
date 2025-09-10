import 'package:fvf_flutter/app/data/config/logger.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';

/// RatingController
class RatingController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  /// requestReview
  Future<void> requestReview() async {
    final InAppReview inAppReview = InAppReview.instance;

    try {
      if (await inAppReview.isAvailable()) {
        await inAppReview.requestReview();
      } else {
        await inAppReview.openStoreListing(
          appStoreId: '',
          microsoftStoreId: '',

        );
      }
    } catch (e) {
      logE('Error showing review dialog: $e');
    }
  }
}
