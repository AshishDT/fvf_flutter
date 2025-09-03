import 'dart:convert';

/// User Rounds Response Model
class MdUserRounds {
  MdUserRounds({
    this.rounds,
    this.count,
    this.total,
  });

  factory MdUserRounds.fromJson(Map<String, dynamic> json) => MdUserRounds(
    rounds: json['rounds'] == null
        ? []
        : List<MdRound>.from(
      json['rounds'].map((x) => MdRound.fromJson(x)),
    ),
    count: json['count'],
    total: json['total'],
  );

  List<MdRound>? rounds;
  int? count;
  int? total;

  Map<String, dynamic> toJson() => {
    'rounds': rounds?.map((x) => x.toJson()).toList(),
    'count': count,
    'total': total,
  };

  String asString() => json.encode(toJson());
}

/// Round model
class MdRound {
  MdRound({
    this.roundId,
    this.prompt,
    this.reason,
    this.createdAt,
    this.hasAccessed,
    this.result,
    this.rank,
    this.selfieUrl,
    this.reactions,
  });

  factory MdRound.fromJson(Map<String, dynamic> json) => MdRound(
    roundId: json['roundId'],
    prompt: json['prompt'],
    reason: json['reason'],
    createdAt:
    json['createdAt'] == null ? null : DateTime.parse(json['createdAt']),
    hasAccessed: json['hasAccessed'],
    result: json['result'] == null
        ? []
        : List<Result>.from(
      json['result'].map((x) => Result.fromJson(x)),
    ),
    rank: json['rank'],
    selfieUrl: json['selfie_url'],
    reactions: json['reactions'],
  );

  String? roundId;
  String? prompt;
  String? reason;
  DateTime? createdAt;
  bool? hasAccessed;
  List<Result>? result;
  int? rank;
  String? selfieUrl;
  Map<String, dynamic>? reactions;

  Map<String, dynamic> toJson() => {
    'roundId': roundId,
    'prompt': prompt,
    'reason': reason,
    'createdAt': createdAt?.toIso8601String(),
    'hasAccessed': hasAccessed,
    'result': result?.map((x) => x.toJson()).toList(),
    'rank': rank,
    'selfie_url': selfieUrl,
    'reactions': reactions,
  };

  /// CopyWith method
  MdRound copyWith({
    String? roundId,
    String? prompt,
    String? reason,
    DateTime? createdAt,
    bool? hasAccessed,
    List<Result>? result,
    int? rank,
    String? selfieUrl,
    Map<String, dynamic>? reactions,
  }) => MdRound(
      roundId: roundId ?? this.roundId,
      prompt: prompt ?? this.prompt,
      reason: reason ?? this.reason,
      createdAt: createdAt ?? this.createdAt,
      hasAccessed: hasAccessed ?? this.hasAccessed,
      result: result ?? this.result,
      rank: rank ?? this.rank,
      selfieUrl: selfieUrl ?? this.selfieUrl,
      reactions: reactions ?? this.reactions,
    );
}

/// Participant model
class Result {
  Result({
    this.rank,
    this.score,
    this.reason,
    this.status,
    this.userId,
    this.username,
    this.selfieUrl,
    this.supabaseId,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    rank: json['rank'],
    score: json['score'],
    reason: json['reason'],
    status: json['status'],
    userId: json['userId'],
    username: json['username'],
    selfieUrl: json['selfieUrl'],
    supabaseId: json['supabase_id'],
  );

  int? rank;
  int? score;
  String? reason;
  String? status;
  String? userId;
  String? username;
  String? selfieUrl;
  String? supabaseId;

  Map<String, dynamic> toJson() => {
    'rank': rank,
    'score': score,
    'reason': reason,
    'status': status,
    'userId': userId,
    'username': username,
    'selfieUrl': selfieUrl,
    'supabase_id': supabaseId,
  };
}
