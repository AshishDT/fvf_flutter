/// Environment configuration
class EnvConfig {
  /// Environment
  static String env = const String.fromEnvironment('env');

  /// Is production
  static bool get isProd => env == 'prod';

  /// Is development
  static bool get isDev => env == 'dev';

  /// Base URL
  static String baseUrl = const String.fromEnvironment('base_url');

  /// Supabase URL
  static String supabaseUrl = const String.fromEnvironment('supabase_url');

  /// Supabase Anon Key
  static String supabaseAnonKey =
      const String.fromEnvironment('supabase_anon_key');

  /// Socket URL
  static String socketUrl = const String.fromEnvironment('socket_url');

  /// RevenueCat API Key
  static String androidRevenueCatApiKey =
      const String.fromEnvironment('android_subscription_key');
}
