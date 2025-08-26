import '../../modules/create_bet/models/md_participant.dart';

/// Represents a round that the user joined
class MdJoinInvitation {
  /// Constructor
  MdJoinInvitation({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.type,
    this.prompt,
    this.isCustomPrompt,
    this.label,
    this.isJobScheduled,
    this.isActive,
    this.isDeleted,
    this.roundJoinedEndAt,
    this.revealAt,
    this.host,
    this.participants,
  });

  /// From JSON
  factory MdJoinInvitation.fromJson(Map<String, dynamic> json) =>
      MdJoinInvitation(
        id: json['id'] as String?,
        createdAt: json['createdAt'] as String?,
        updatedAt: json['updatedAt'] as String?,
        status: json['status'] as String?,
        type: json['type'] as String?,
        prompt: json['prompt'] as String?,
        isCustomPrompt: json['is_custom_prompt'] as bool?,
        label: json['label'] as String?,
        isJobScheduled: json['is_job_scheduled'] as bool?,
        isActive: json['is_active'] as bool?,
        isDeleted: json['is_deleted'] as bool?,
        roundJoinedEndAt: json['round_joined_end_at'] == null ?
            null
            : DateTime.tryParse(json['round_joined_end_at']),
        revealAt: json['revealAt'] as String?,
        host: json['host'] == null
            ? null
            : RoundHost.fromJson(json['host'] as Map<String, dynamic>),
        participants: json['participants'] == null
            ? <MdParticipant>[]
            : (json['participants'] as List<dynamic>?)
                ?.map((e) => MdParticipant.fromJson(e as Map<String, dynamic>))
                .toList(),
      );

  /// Round Id
  final String? id;

  /// Created at
  final String? createdAt;

  /// Updated at
  final String? updatedAt;

  /// Status
  final String? status;

  /// Type
  final String? type;

  /// Prompt
  final String? prompt;

  /// Is custom prompt
  final bool? isCustomPrompt;

  /// Label
  final String? label;

  /// Is job scheduled
  final bool? isJobScheduled;

  /// Is active
  final bool? isActive;

  /// Is deleted
  final bool? isDeleted;

  /// Round joined end at
  final DateTime? roundJoinedEndAt;

  /// Reveal at
  final String? revealAt;

  /// Host
  final RoundHost? host;

  /// Participants
  List<MdParticipant>? participants;

  /// To JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'status': status,
        'type': type,
        'prompt': prompt,
        'is_custom_prompt': isCustomPrompt,
        'label': label,
        'is_job_scheduled': isJobScheduled,
        'is_active': isActive,
        'is_deleted': isDeleted,
        'round_joined_end_at': roundJoinedEndAt?.toIso8601String(),
        'revealAt': revealAt,
        'host': host?.toJson(),
        'participants': participants?.map((e) => e.toJson()).toList(),
      };
}

/// Represents the host of the round
class RoundHost {
  /// Constructor
  RoundHost({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.username,
    this.phone,
    this.countryCode,
    this.profilePic,
    this.profileUrl,
    this.isClaim,
    this.age,
    this.linkSupabaseId,
    this.fcmToken,
    this.winnerStreakCount,
    this.totalWins,
    this.dailyTeamFvfCount,
    this.lastTeamFvfRoundAt,
    this.winnerStreakUpdatedAt,
    this.lastActiveAt,
    this.isNotified,
    this.isActive,
    this.isDeleted,
    this.supabaseId,
  });

  /// From JSON
  factory RoundHost.fromJson(Map<String, dynamic> json) => RoundHost(
        id: json['id'] as String?,
        createdAt: json['createdAt'] as String?,
        updatedAt: json['updatedAt'] as String?,
        username: json['username'] as String?,
        phone: json['phone'] as String?,
        countryCode: json['country_code'] as String?,
        profilePic: json['profile_pic'] as String?,
        profileUrl: json['profile_url'] as String?,
        isClaim: json['is_claim'] as bool?,
        age: json['age'] as int?,
        linkSupabaseId: json['link_supabase_id'] as String?,
        fcmToken: json['fcm_token'] as String?,
        winnerStreakCount: json['winner_streak_count'] as int?,
        totalWins: json['total_wins'] as int?,
        dailyTeamFvfCount: json['daily_team_fvf_count'] as int?,
        lastTeamFvfRoundAt: json['last_team_fvf_round_at'] as String?,
        winnerStreakUpdatedAt: json['winner_streak_updated_at'] as String?,
        lastActiveAt: json['last_active_at'] as String?,
        isNotified: json['is_notified'] as bool?,
        isActive: json['is_active'] as bool?,
        isDeleted: json['is_deleted'] as bool?,
        supabaseId: json['supabase_id'] as String?,
      );

  /// Host Id
  final String? id;

  /// Created at
  final String? createdAt;

  /// Updated at
  final String? updatedAt;

  /// Username
  final String? username;

  /// Phone
  final String? phone;

  /// Country code
  final String? countryCode;

  /// Profile picture
  final String? profilePic;

  /// Profile URL
  final String? profileUrl;

  /// Is claim
  final bool? isClaim;

  /// Age
  final int? age;

  /// Link Supabase ID
  final String? linkSupabaseId;

  /// FCM token
  final String? fcmToken;

  /// Winner streak count
  final int? winnerStreakCount;

  /// Total wins
  final int? totalWins;

  /// Daily team FVF count
  final int? dailyTeamFvfCount;

  /// Last team FVF round at
  final String? lastTeamFvfRoundAt;

  /// Winner streak updated at
  final String? winnerStreakUpdatedAt;

  /// Last active at
  final String? lastActiveAt;

  /// Is notified
  final bool? isNotified;

  /// Is active
  final bool? isActive;

  /// Is deleted
  final bool? isDeleted;

  /// Supabase ID
  final String? supabaseId;

  /// To JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'username': username,
        'phone': phone,
        'country_code': countryCode,
        'profile_pic': profilePic,
        'profile_url': profileUrl,
        'is_claim': isClaim,
        'age': age,
        'link_supabase_id': linkSupabaseId,
        'fcm_token': fcmToken,
        'winner_streak_count': winnerStreakCount,
        'total_wins': totalWins,
        'daily_team_fvf_count': dailyTeamFvfCount,
        'last_team_fvf_round_at': lastTeamFvfRoundAt,
        'winner_streak_updated_at': winnerStreakUpdatedAt,
        'last_active_at': lastActiveAt,
        'is_notified': isNotified,
        'is_active': isActive,
        'is_deleted': isDeleted,
        'supabase_id': supabaseId,
      };
}
