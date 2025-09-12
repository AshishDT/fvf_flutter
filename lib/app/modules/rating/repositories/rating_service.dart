import '../models/rating_rules.dart';
import '../models/rating_state.dart';

/// Rating service to determine when to prompt user for app rating
class RatingService {
  /// Determines if the rating prompt should be shown based on various criteria
  bool shouldShowRating({
    required DateTime installDate,
    required int totalWins,
    required int crewStreakDays,
    required RatingState state,
    required DateTime now,
  }) {
    if (state.hasRated) {
      return false;
    }

    final int installedDays = now.difference(installDate).inDays;
    if (installedDays < RatingRules.minInstallDays) {
      return false;
    }

    final bool hasProgress = totalWins >= RatingRules.minWins ||
        crewStreakDays >= RatingRules.minCrewStreakDays;
    if (!hasProgress) {
      return false;
    }

    if (state.totalAsksThisYear >= RatingRules.maxAsksPerYear) {
      return false;
    }

    if (state.lastAskDate != null) {
      final int daysSinceLastAsk = now.difference(state.lastAskDate!).inDays;

      if (daysSinceLastAsk < RatingRules.askCooldownDays) {
        return false;
      }

      if (state.snoozesThisYear > 0 &&
          daysSinceLastAsk < RatingRules.snoozeCooldownDays) {
        return false;
      }
    }

    return true;
  }

  /// Call when user taps [Rate Slay]
  RatingState markRated(RatingState state, DateTime now) => state.copyWith(
        hasRated: true,
        lastAskDate: now,
        totalAsksThisYear: state.totalAsksThisYear + 1,
      );

  /// Call when user taps [Maybe Later]
  RatingState snooze(RatingState state, DateTime now) {
    if (state.snoozesThisYear >= RatingRules.maxSnoozesPerYear) {
      return state.copyWith(
        totalAsksThisYear: RatingRules.maxAsksPerYear,
        lastAskDate: now,
      );
    }

    return state.copyWith(
      lastAskDate: now,
      snoozesThisYear: state.snoozesThisYear + 1,
    );
  }
}
