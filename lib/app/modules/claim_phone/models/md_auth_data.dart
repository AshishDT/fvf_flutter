import 'package:supabase_flutter/supabase_flutter.dart';

/// Auth data model
class MdAuthData {
  /// Constructor
  MdAuthData({
    this.authResponse,
    this.phone,
    this.countryCode,
  });

  /// Auth response
  final AuthResponse? authResponse;

  /// Phone
  final String? phone;

  /// Country code
  final String? countryCode;
}
