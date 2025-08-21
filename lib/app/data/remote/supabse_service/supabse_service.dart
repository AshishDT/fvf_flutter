import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../config/env_config.dart';

/// Supabase service
class SupaBaseService {
  /// Init
  static Future<void> init() async {
    await Supabase.initialize(
      url: EnvConfig.supabaseUrl,
      anonKey: EnvConfig.supabaseAnonKey,
    );
  }

  /// Supabase instance
  static final SupabaseClient _instance = Supabase.instance.client;

  /// Current user
  static User? get currentUser => _instance.auth.currentUser;

  /// Is logged in
  static bool get isLoggedIn => _instance.auth.currentUser != null;

  /// User ID
  static String get userId => _instance.auth.currentUser?.id ?? '';

  /// Sign in anonymously
  static Future<AuthResponse> signInAnonymously() async {
    final AuthResponse response = await _instance.auth.signInAnonymously();
    return response;
  }
}
