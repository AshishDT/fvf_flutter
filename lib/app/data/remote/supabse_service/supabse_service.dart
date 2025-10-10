import 'dart:async';
import 'dart:developer';
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

    if (isLoggedIn && !isSessionValid) {
      await SupaBaseService.refreshSession();
    }
  }

  /// Supabase instance
  static final SupabaseClient _instance = Supabase.instance.client;

  /// Current anonymous session
  static Session? anonymousSession;

  /// Is logged in
  static bool get isLoggedIn => _instance.auth.currentUser != null;

  /// Is session valid
  static bool get isSessionValid {
    final Session? session = _instance.auth.currentSession;
    if (session == null) {
      return false;
    }
    final DateTime expiresAt = session.expiresAt != null
        ? DateTime.fromMillisecondsSinceEpoch(session.expiresAt! * 1000)
        : DateTime.now();
    return DateTime.now().isBefore(expiresAt);
  }

  /// Current user log out
  static Future<void> logout() async {
    await _instance.auth.signOut();
  }

  /// Refresh session
  static Future<void> refreshSession() async {
    final AuthResponse _res = await _instance.auth.refreshSession();
    log(
      'Auth refreshed: ${_res.user?.toJson()} || Session refreshed: ${_res.session?.toJson()}',
    );
  }

  /// Sign in anonymously
  static Future<AuthResponse> signInAnonymously() async {
    final AuthResponse response = await _instance.auth.signInAnonymously();
    return response;
  }

  /// Send OTP to phone number
  static Future<void> sendOtp({
    required String phoneNumber,
    bool fromLogin = false,
  }) async {
    if (!fromLogin) {
      anonymousSession = _instance.auth.currentSession;
    }

    await _instance.auth.signInWithOtp(
      phone: phoneNumber,
    );
  }

  /// Verify OTP
  static Future<AuthResponse> verifyOtp({
    required String phoneNumber,
    required String token,
    bool fromLogin = false,
  }) async {
    final AuthResponse response = await _instance.auth.verifyOTP(
      phone: phoneNumber,
      token: token,
      type: OtpType.sms,
    );

    if (fromLogin) {
      anonymousSession = null;
    }

    if (response.session == null) {
      return response;
    }

    if (!fromLogin) {
      final String? refreshToken = anonymousSession?.refreshToken;
      if (refreshToken == null || refreshToken.isEmpty) {
        logE('Missing refresh token for anonymous session');
        return response;
      }
      return _instance.auth.setSession(refreshToken);
    }

    return response;
  }
}
