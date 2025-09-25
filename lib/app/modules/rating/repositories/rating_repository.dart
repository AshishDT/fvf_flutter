import '../../../data/local/store/local_store.dart';
import '../models/rating_state.dart';

/// Rating repository to load/save rating state
class RatingRepository {
  /// Load current rating state from LocalStore
  RatingState load() {
    final String? lastAskStr = LocalStore.ratingLastAsk();
    final DateTime? lastAskDate = (lastAskStr != null && lastAskStr.isNotEmpty)
        ? DateTime.tryParse(lastAskStr)
        : null;

    return RatingState(
      lastAskDate: lastAskDate,
      totalAsksThisYear: LocalStore.ratingTotalAsks() ?? 0,
      snoozesThisYear: LocalStore.ratingSnoozes() ?? 0,
      hasRated: LocalStore.ratingHasRated() ?? false,
    );
  }

  /// Save updated rating state into LocalStore
  void save(RatingState state) {
    if (state.lastAskDate != null) {
      LocalStore.ratingLastAsk(state.lastAskDate!.toIso8601String());
    }
    LocalStore.ratingTotalAsks(state.totalAsksThisYear);
    LocalStore.ratingSnoozes(state.snoozesThisYear);
    LocalStore.ratingHasRated(state.hasRated);
  }
}
