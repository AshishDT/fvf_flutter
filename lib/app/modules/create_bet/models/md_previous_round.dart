/// Model class for previous round
class MdPreviousRound {
  /// Constructor
  MdPreviousRound({
    this.id,
    this.participants,
    this.lastPlayedAt,
    this.isAdded,
  });

  /// From JSON
  factory MdPreviousRound.fromJson(Map<String, dynamic> json) =>
      MdPreviousRound(
        id: json['id'],
        participants: json['user_ids'] == null
            ? <MdPreviousParticipant>[]
            : List<MdPreviousParticipant>.from(json['user_ids']!
                .map((dynamic x) => MdPreviousParticipant.fromJson(x))),
        lastPlayedAt: json['last_played_at'] == null
            ? null
            : DateTime.parse(json['last_played_at']),
      );

  /// ID
  String? id;

  /// User IDs
  List<MdPreviousParticipant>? participants;

  /// Last played at
  DateTime? lastPlayedAt;

  /// Is added
  bool? isAdded;

  /// To JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'user_ids': participants == null
            ? <dynamic>[]
            : List<dynamic>.from(
                participants!.map(
                  (MdPreviousParticipant x) => x.toJson(),
                ),
              ),
        'last_played_at': lastPlayedAt?.toIso8601String(),
      };
}

/// Model class for previous participant user
class MdPreviousParticipant {
  /// Constructor
  MdPreviousParticipant({
    this.id,
    this.username,
    this.profileUrl,
    this.isAdded,
  });

  /// From JSON
  factory MdPreviousParticipant.fromJson(Map<String, dynamic> json) =>
      MdPreviousParticipant(
        id: json['id'],
        username: json['username'],
        profileUrl: json['profile_url'],
      );

  /// User ID
  String? id;

  /// Username
  String? username;

  /// User profile URL
  String? profileUrl;

  /// Is added
  bool? isAdded;

  /// To JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'username': username,
        'profile_url': profileUrl,
      };
}
