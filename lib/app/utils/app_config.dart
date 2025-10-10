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

  /// Privacy policy URL
  static String privacyPolicyUrl = 'https://slayapp.io/privacy_policy';

  /// Terms of service URL
  static String termsOfServiceUrl = 'https://slayapp.io/terms_of_service';

  /// App URL
  static String appUrl = 'https://play.google.com/store/apps/details?id=com.slay.org.app';
}
