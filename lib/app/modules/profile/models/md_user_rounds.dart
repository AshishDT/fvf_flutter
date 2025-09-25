import 'dart:convert';

import 'package:fvf_flutter/app/modules/ai_choosing/models/md_result.dart';

/// User Rounds Response Model
class MdUserRounds {
  /// Constructor
  MdUserRounds({
    this.rounds,
    this.count,
    this.total,
  });

  /// From JSON
  factory MdUserRounds.fromJson(Map<String, dynamic> json) => MdUserRounds(
        rounds: json['rounds'] == null
            ? <MdRound>[]
            : List<MdRound>.from(
                json['rounds'].map((x) => MdRound.fromJson(x)),
              ),
        count: json['count'],
        total: json['total'],
      );

  /// Rounds
  List<MdRound>? rounds;

  /// Count
  int? count;

  /// Total
  int? total;

  /// To JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'rounds': rounds?.map((MdRound x) => x.toJson()).toList(),
        'count': count,
        'total': total,
      };

  /// To String
  String asString() => json.encode(toJson());
}

/// Round model
class MdRound {
  /// Constructor
  MdRound({
    this.roundId,
    this.prompt,
    this.reason,
    this.createdAt,
    this.hasAccessed,
    this.results,
    this.rank,
    this.selfieUrl,
    this.reactions,
  });

  /// From JSON
  factory MdRound.fromJson(Map<String, dynamic> json) => MdRound(
        roundId: json['roundId'],
        prompt: json['prompt'],
        reason: json['reason'],
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt']),
        hasAccessed: json['hasAccessed'],
        results: json['result'] == null
            ? <MdResult>[]
            : List<MdResult>.from(
                json['result'].map((x) => MdResult.fromJson(x)),
              ),
        rank: json['rank'],
        selfieUrl: json['selfie_url'],
        reactions: json['reactions'],
      );

  /// roundId
  String? roundId;

  /// Prompt
  String? prompt;

  /// Reason
  String? reason;

  /// Created at
  DateTime? createdAt;

  /// Has accessed
  bool? hasAccessed;

  /// Result
  List<MdResult>? results;

  /// Rank
  int? rank;

  /// Selfie URL
  String? selfieUrl;

  /// Reactions
  String? reactions;

  /// To JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'roundId': roundId,
        'prompt': prompt,
        'reason': reason,
        'createdAt': createdAt?.toIso8601String(),
        'hasAccessed': hasAccessed,
        'result': results?.map((MdResult x) => x.toJson()).toList(),
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
    List<MdResult>? result,
    int? rank,
    String? selfieUrl,
    String? reactions,
  }) =>
      MdRound(
        roundId: roundId ?? this.roundId,
        prompt: prompt ?? this.prompt,
        reason: reason ?? this.reason,
        createdAt: createdAt ?? this.createdAt,
        hasAccessed: hasAccessed ?? this.hasAccessed,
        results: result ?? this.results,
        rank: rank ?? this.rank,
        selfieUrl: selfieUrl ?? this.selfieUrl,
        reactions: reactions ?? this.reactions,
      );
}
