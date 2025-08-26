import '../../../data/models/md_join_invitation.dart';
import '../enums/round_status_enum.dart';

/// AI result model
class MdAiResultData {
  /// Constructor
  MdAiResultData({
    this.id,
    this.status,
    this.prompt,
    this.results,
    this.revealAt,
    this.host,
  });

  /// From JSON
  factory MdAiResultData.fromJson(Map<String, dynamic> json) => MdAiResultData(
    id: json['id'],
    status: json['status'] == null
        ? null
        : RoundStatusX.fromString(json['status'].toString()),
    prompt: json['prompt'],
    results: json['results'] == null
        ? <MdResult>[]
        : List<MdResult>.from(
        json['results'].map((x) => MdResult.fromJson(x))),
    revealAt:
    json['revealAt'] == null ? null : DateTime.parse(json['revealAt']),
    host: json['host'] == null ? null : RoundHost.fromJson(json['host']),
  );

  /// AI result id
  String? id;

  /// Status
  RoundStatus? status;

  /// Prompt
  String? prompt;

  /// Results
  List<MdResult>? results;

  /// Reveal at
  DateTime? revealAt;

  /// Host
  RoundHost? host;

  /// To JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'status': status?.value,
        'prompt': prompt,
        'results': results == null
            ? <dynamic>[]
            : List<dynamic>.from(results!.map((MdResult x) => x.toJson())),
        'revealAt': revealAt?.toIso8601String(),
        'host': host?.toJson(),
      };
}

/// Md result
class MdResult {
  /// Constructor
  MdResult({
    this.rank,
    this.reason,
    this.userId,
    this.selfieUrl,
    this.supabaseId,
  });

  /// From JSON
  factory MdResult.fromJson(Map<String, dynamic> json) => MdResult(
        rank: json['rank'],
        reason: json['reason'],
        userId: json['userId'],
        selfieUrl: json['selfieUrl'],
        supabaseId: json['supabase_id'],
      );

  /// Rank
  int? rank;

  /// Reason
  String? reason;

  /// User ID
  String? userId;

  /// Supabase ID
  String? supabaseId;

  /// Selfie URL
  String? selfieUrl;

  /// To JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'rank': rank,
        'reason': reason,
        'userId': userId,
        'selfieUrl': selfieUrl,
        'supabase_id': supabaseId,
      };
}
