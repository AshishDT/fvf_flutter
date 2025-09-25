import 'package:fvf_flutter/app/data/config/logger.dart';
import 'package:fvf_flutter/app/modules/rating/models/rating_state.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import '../repositories/rating_repository.dart' show RatingRepository;
import '../repositories/rating_service.dart';

/// RatingController
class RatingController extends GetxController {
  /// State
  RatingState state = const RatingState();

  /// Repo
  final RatingRepository _repo = RatingRepository();

  /// Service
  final RatingService service = RatingService();

  @override
  void onInit() {
    state = _repo.load();
    super.onInit();
  }

  /// Is reviewing
  RxBool isReviewing = false.obs;

  /// Request review
  Future<void> requestReview() async {
    isReviewing(true);

    final InAppReview inAppReview = InAppReview.instance;

    try {
      final bool alreadyRated = state.hasRated;

      if (!alreadyRated && await inAppReview.isAvailable()) {
        await inAppReview.requestReview();
      } else {
        await inAppReview.openStoreListing();
      }

      if (!alreadyRated) {
        state = service.markRated(state, DateTime.now());
        _repo.save(state);
      }
    } on Exception catch (e) {
      logE('Error showing review dialog: $e');
    } finally {
      isReviewing(false);
    }
  }

  /// On rate now
  void onMaybeLater() {
    if (isReviewing()) {
      return;
    }
    state = service.snooze(state, DateTime.now());
    _repo.save(state);
    Get.back();
  }
}
