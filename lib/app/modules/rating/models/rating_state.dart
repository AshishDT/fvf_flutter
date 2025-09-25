/// Rating state
class RatingState {
  /// Constructor
  const RatingState({
    this.lastAskDate,
    this.totalAsksThisYear = 0,
    this.snoozesThisYear = 0,
    this.hasRated = false,
  });

  /// Last date the user was asked to rate the app
  final DateTime? lastAskDate;

  /// Total number of times the user was asked to rate the app this year
  final int totalAsksThisYear;

  /// Number of times the user has snoozed the rating prompt this year
  final int snoozesThisYear;

  /// Whether the user has rated the app
  final bool hasRated;

  /// Create a copy of the current state with optional new values
  RatingState copyWith({
    DateTime? lastAskDate,
    int? totalAsksThisYear,
    int? snoozesThisYear,
    bool? hasRated,
  }) =>
      RatingState(
        lastAskDate: lastAskDate ?? this.lastAskDate,
        totalAsksThisYear: totalAsksThisYear ?? this.totalAsksThisYear,
        snoozesThisYear: snoozesThisYear ?? this.snoozesThisYear,
        hasRated: hasRated ?? this.hasRated,
      );
}
