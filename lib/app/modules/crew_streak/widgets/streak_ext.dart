/// Streak Extension
extension StreakExtension on int {
  /// Get Streak Info
  String get streakInfo {
    if (this > 0 && this < 7) {
      return 'Off to Fire';
    } else if (this >= 7 && this < 14) {
      return 'One Week Strong';
    } else if (this >= 14 && this < 30) {
      return 'Unstoppable Crew';
    } else if (this >= 30 && this < 50) {
      return 'Flame Never Dies';
    } else if (this >= 50 && this < 100) {
      return 'Legendary Run';
    } else if (this >= 100) {
      return 'Immortal Flame';
    } else {
      return 'No streak yet';
    }
  }
}
