import 'dart:async';
import 'package:fvf_flutter/app/data/config/logger.dart';
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

  /// Send OTP to phone number
  static Future<void> sendOtp(String phoneNumber) async {
    await _instance.auth.signInWithOtp(
      phone: phoneNumber,
    );
  }

  /// Verify OTP
  static Future<AuthResponse> verifyOtp({
    required String phoneNumber,
    required String token,
  }) async {
    final AuthResponse response = await _instance.auth.verifyOTP(
      phone: phoneNumber,
      token: token,
      type: OtpType.sms,
    );
    return response;
  }
}
