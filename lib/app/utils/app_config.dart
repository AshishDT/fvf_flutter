/// App configuration settings
class AppConfig {
  /// Max part
  static int maxPart = 8;

  /// Min part
  static int minPart = 2;

  /// Min submissions[Selfie]
  static int minSubmissions = 2;

  /// Round duration in minutes
  static num roundDurationInMinutes = 1.5;

  /// Round duration in seconds
  static int get roundDurationInSeconds {
    final int minutes = roundDurationInMinutes.floor();
    final double fractionalMinutes =
        (roundDurationInMinutes - minutes).toDouble();

    return (minutes * 60) + (fractionalMinutes * 60).round();
  }
}
