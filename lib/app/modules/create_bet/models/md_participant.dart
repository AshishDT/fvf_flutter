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
      };
}
