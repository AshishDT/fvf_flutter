/// Rating rules and thresholds for prompting user feedback.
class RatingRules {
  /// Minimum number of days since app installation before prompting for a rating.
  static const int minInstallDays = 2;

  /// Minimum number of wins required before prompting for a rating.
  static const int minWins = 2;

  /// Minimum number of days in a crew streak before prompting for a rating.
  static const int minCrewStreakDays = 2;

  /// Cooldown periods and maximum prompts per year.
  static const int askCooldownDays = 90;

  /// Cooldown period after snoozing before prompting again.
  static const int snoozeCooldownDays = 30;

  /// Maximum number of times to ask for a rating per year.
  static const int maxAsksPerYear = 3;

  /// Maximum number of times the user can snooze the rating prompt per year.
  static const int maxSnoozesPerYear = 2;
}
