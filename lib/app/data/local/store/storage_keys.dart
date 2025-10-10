// ignore_for_file: public_member_api_docs

part of 'local_store.dart';

/// Local storage keys with built in helpers
class LocalStore {
  /// current locale
  static final _StoreObject<String> currentLocale =
      _StoreObject<String>(key: 'current_locale');

  /// theme mode
  static final _StoreObject<int> themeMode =
      _StoreObject<int>(key: 'theme_mode');

  /// User data
  static final _StoreObject<String> user =
      _StoreObject<String>(key: 'user_data');

  /// Auth token
  static final _StoreObject<String> authToken =
      _StoreObject<String>(key: 'auth_token');

  /// Erase all data from local storage
  static Future<void> erase() async {
    await _Store.erase();
  }

  /// Bet Valid To
  static final _StoreObject<String> betValidTo =
      _StoreObject<String>(key: 'valid_to');

  /// All bets (as JSON string)
  static final _StoreObject<String> betsJson =
      _StoreObject<String>(key: 'bets_json');

  static final _StoreObject<String> loginTime =
      _StoreObject<String>(key: 'login_time');

  /// Rating last ask date (ISO string)
  static final _StoreObject<String> ratingLastAsk =
      _StoreObject<String>(key: 'rating_last_ask');

  /// Rating total asks this year
  static final _StoreObject<int> ratingTotalAsks =
      _StoreObject<int>(key: 'rating_total_asks');

  /// Rating snoozes this year
  static final _StoreObject<int> ratingSnoozes =
      _StoreObject<int>(key: 'rating_snoozes');

  /// Rating has user already rated
  static final _StoreObject<bool> ratingHasRated =
      _StoreObject<bool>(key: 'rating_has_rated');

  /// Phone sheet – eligibility tracking
  static final _StoreObject<bool> phoneSheetFirstProfileVisit =
      _StoreObject<bool>(key: 'is_first_profile_visit');

  static final _StoreObject<int> phoneSheetLastDeclineRound =
      _StoreObject<int>(key: 'last_decline_round');

  static final _StoreObject<int> phoneSheetDeclineCount =
      _StoreObject<int>(key: 'decline_count');
}
