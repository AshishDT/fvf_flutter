/// Md result
class MdResult {
  /// Constructor
  MdResult({
    this.rank,
    this.reason,
    this.userId,
    this.selfieUrl,
    this.supabaseId,
    this.score,
    this.status,
    this.userName,
    this.reactions,
  });

  /// From JSON
  factory MdResult.fromJson(Map<String, dynamic> json) => MdResult(
        rank: json['rank'],
        reason: json['reason'],
        userId: json['userId'],
        selfieUrl: json['selfieUrl'],
        supabaseId: json['supabase_id'],
        score: json['score'],
        status: json['status'],
        userName: json['username'],
        reactions: json['reactions'],
      );

  /// Rank
  int? rank;

  /// Reason
  String? reason;

  /// Status
  String? status;

  /// User ID
  String? userId;

  /// Supabase ID
  String? supabaseId;

  /// Selfie URL
  String? selfieUrl;

  /// Score
  num? score;

  /// User name
  String? userName;

  /// Reactions
  String? reactions;

  /// To JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'rank': rank,
        'reason': reason,
        'userId': userId,
        'selfieUrl': selfieUrl,
        'supabase_id': supabaseId,
        'score': score,
        'status': status,
        'username': userName,
        'reactions': reactions,
      };
}
