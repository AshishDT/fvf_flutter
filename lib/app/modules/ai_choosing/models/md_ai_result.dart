import 'package:fvf_flutter/app/modules/ai_choosing/models/md_result.dart';

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


