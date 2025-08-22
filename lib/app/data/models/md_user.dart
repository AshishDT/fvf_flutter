import 'dart:convert';

/// User model
class MdUser {
  /// Constructor
  MdUser({
    this.supabaseId,
    this.fcmToken,
    this.age,
    this.username,
    this.phone,
    this.countryCode,
    this.profilePic,
    this.profileUrl,
    this.linkSupabaseId,
    this.lastTeamFvfRoundAt,
    this.winnerStreakUpdatedAt,
    this.lastActiveAt,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.isClaim,
    this.winnerStreakCount,
    this.totalWins,
    this.dailyTeamFvfCount,
    this.isNotified,
    this.isActive,
    this.isDeleted,
    this.token,
  });

  /// From JSON
  factory MdUser.fromJson(Map<String, dynamic> json) => MdUser(
        supabaseId: json['supabase_id'],
        fcmToken: json['fcm_token'],
        age: json['age'],
        username: json['username'],
        phone: json['phone'],
        countryCode: json['country_code'],
        profilePic: json['profile_pic'],
        profileUrl: json['profile_url'],
        linkSupabaseId: json['link_supabase_id'],
        lastTeamFvfRoundAt: json['last_team_fvf_round_at'] == null
            ? null
            : DateTime.parse(json['last_team_fvf_round_at']),
        winnerStreakUpdatedAt: json['winner_streak_updated_at'] == null
            ? null
            : DateTime.parse(json['winner_streak_updated_at']),
        lastActiveAt: json['last_active_at'] == null
            ? null
            : DateTime.parse(json['last_active_at']),
        id: json['id'],
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt']),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt']),
        isClaim: json['is_claim'],
        winnerStreakCount: json['winner_streak_count'],
        totalWins: json['total_wins'],
        dailyTeamFvfCount: json['daily_team_fvf_count'],
        isNotified: json['is_notified'],
        isActive: json['is_active'],
        isDeleted: json['is_deleted'],
        token: json['token'],
      );

  /// Su
  String? supabaseId;

  /// FCM token
  String? fcmToken;

  /// Age
  int? age;

  /// Username
  String? username;

  /// Phone
  String? phone;

  /// Country code
  String? countryCode;

  /// Profile picture URL
  String? profilePic;

  /// Profile URL
  String? profileUrl;

  /// Link Supabase ID
  String? linkSupabaseId;

  /// Last team FVF round at
  DateTime? lastTeamFvfRoundAt;

  /// Winner streak updated at
  DateTime? winnerStreakUpdatedAt;

  /// Last active at
  DateTime? lastActiveAt;

  /// ID
  String? id;

  /// Created at
  DateTime? createdAt;

  /// Updated at
  DateTime? updatedAt;

  /// Is claim
  bool? isClaim;

  /// Winner streak count
  int? winnerStreakCount;

  /// Total wins
  int? totalWins;

  /// Daily team FVF count
  int? dailyTeamFvfCount;

  /// Is notified
  bool? isNotified;

  /// Is active
  bool? isActive;

  /// Is deleted
  bool? isDeleted;

  /// Token
  String? token;

  /// To JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'supabase_id': supabaseId,
        'fcm_token': fcmToken,
        'age': age,
        'username': username,
        'phone': phone,
        'country_code': countryCode,
        'profile_pic': profilePic,
        'profile_url': profileUrl,
        'link_supabase_id': linkSupabaseId,
        'last_team_fvf_round_at': lastTeamFvfRoundAt,
        'winner_streak_updated_at': winnerStreakUpdatedAt,
        'last_active_at': lastActiveAt,
        'id': id,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'is_claim': isClaim,
        'winner_streak_count': winnerStreakCount,
        'total_wins': totalWins,
        'daily_team_fvf_count': dailyTeamFvfCount,
        'is_notified': isNotified,
        'is_active': isActive,
        'is_deleted': isDeleted,
        'token': token,
      };

  /// To json
  String asString() => json.encode(toJson());
}
