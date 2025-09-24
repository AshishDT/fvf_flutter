import 'package:fvf_flutter/app/data/local/user_provider.dart';
import 'package:fvf_flutter/app/data/models/md_join_invitation.dart';
import '../../profile/models/md_badge.dart';

/// Participant Model
class MdParticipant {
  /// Constructor
  MdParticipant({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.isHost,
    this.status,
    this.joinedAt,
    this.magicLink,
    this.isActive,
    this.isDeleted,
    this.userData,
    this.selfieUrl,
    this.rank,
    this.badge,
  });

  /// From JSON
  factory MdParticipant.fromJson(Map<String, dynamic> json) => MdParticipant(
        id: json['id'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
        isHost: json['is_host'],
        status: json['status'],
        joinedAt: json['joined_at'],
        magicLink: json['magic_link'],
        isActive: json['is_active'],
        isDeleted: json['is_deleted'],
        selfieUrl: json['selfie_url'],
        userData: json['user'] == null
            ? null
            : RoundHost.fromJson(json['user'] as Map<String, dynamic>),
        badge: json['awarded_badge'] == null
            ? null
            : MdBadge.fromJson(
                json['awarded_badge'],
              ),
      );

  /// Participant Id
  final String? id;

  /// Created at
  final String? createdAt;

  /// Updated at
  final String? updatedAt;

  /// Is host
  final bool? isHost;

  /// Status
  final String? status;

  /// Joined at
  final String? joinedAt;

  /// Magic link
  final String? magicLink;

  /// Is active
  final bool? isActive;

  /// Is deleted
  final bool? isDeleted;

  /// Selfie URL
  final String? selfieUrl;

  /// User data
  final RoundHost? userData;

  /// Rank
  int? rank;

  /// Badge
  final MdBadge? badge;

  /// Check if the participant is the current user
  bool get isCurrentUser => userData?.id == UserProvider.userId;

  /// To JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'is_host': isHost,
        'status': status,
        'joined_at': joinedAt,
        'magic_link': magicLink,
        'is_active': isActive,
        'is_deleted': isDeleted,
        'selfie_url': selfieUrl,
        'user': userData?.toJson(),
        'awarded_badge': badge == null ? null : badge!.toJson(),
      };
}
