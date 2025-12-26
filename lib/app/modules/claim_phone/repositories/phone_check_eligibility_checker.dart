import '../../../data/local/store/local_store.dart';

/// A utility class to determine whether to show the phone number collection sheet.
class PhoneClaimChecker {
  /// Base retry gap in rounds.
  static const int _retryAfterRounds = 5;

  /// Returns whether the sheet should be shown right now.
  static Future<bool> shouldShowSheet({
    required int totalRounds,
  }) async {
    final bool isFirstProfileVisit =
        LocalStore.phoneSheetFirstProfileVisit() ?? true;
    final int? lastDeclineRound = LocalStore.phoneSheetLastDeclineRound();
    final int declineCount = LocalStore.phoneSheetDeclineCount() ?? 0;

    if (isFirstProfileVisit && totalRounds > 0) {
      LocalStore.phoneSheetFirstProfileVisit(false);
      return true;
    }

    if (lastDeclineRound != null) {
      final int requiredRoundsGap = _retryAfterRounds * (declineCount + 1);
      final int roundsSinceLastDecline = totalRounds - lastDeclineRound;

      if (roundsSinceLastDecline >= requiredRoundsGap) {
        return true;
      }
    }

    return false;
  }

  /// Call this when the user declines the sheet.
  static Future<void> markDeclined({
    required int currentRoundCount,
  }) async {
    final int currentDeclineCount = LocalStore.phoneSheetDeclineCount() ?? 0;

    LocalStore.phoneSheetDeclineCount(currentDeclineCount + 1);
    LocalStore.phoneSheetLastDeclineRound(currentRoundCount);
  }
}
