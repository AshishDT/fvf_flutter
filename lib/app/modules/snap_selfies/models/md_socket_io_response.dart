import 'package:fvf_flutter/app/modules/create_bet/models/md_participant.dart';

import '../../ai_choosing/enums/round_status_enum.dart';
import '../../ai_choosing/models/md_crew.dart';
import '../../ai_choosing/models/md_result.dart';

/// Socket data model
class MdSocketData {
  /// Constructor
  MdSocketData({
    this.round,
    this.hasAccess,
    this.error,
  });

  /// Factory constructor from JSON
  factory MdSocketData.fromJson(Map<String, dynamic> json) => MdSocketData(
        round: json['round'] != null ? Round.fromJson(json['round']) : null,
        hasAccess: json['hasAccess'] as bool?,
        error: json['error'],
      );

  /// Round object
  final Round? round;

  /// Access flag
  final bool? hasAccess;

  /// Error message
  final String? error;

  /// Convert object to JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'round': round?.toJson(),
        'hasAccess': hasAccess,
        'error': error,
      };
}

/// Round model
class Round {
  /// Constructor
  Round({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.type,
    this.prompt,
    this.isCustomPrompt,
    this.isActive,
    this.isDeleted,
    this.roundJoinedEndAt,
    this.revealAt,
    this.participants,
    this.results,
    this.crew,
  });

  /// From JSON
  factory Round.fromJson(Map<String, dynamic> json) => Round(
        id: json['id'] as String?,
        createdAt: json['createdAt'] as String?,
        updatedAt: json['updatedAt'] as String?,
        status: json['status'] != null
            ? RoundStatusX.fromString(json['status'] as String)
            : null,
        type: json['type'] as String?,
        prompt: json['prompt'] as String?,
        isCustomPrompt: json['is_custom_prompt'] as bool?,
        isActive: json['is_active'] as bool?,
        isDeleted: json['is_deleted'] as bool?,
        roundJoinedEndAt: json['round_joined_end_at'] == null
            ? null
            : DateTime.tryParse(json['round_joined_end_at']),
        revealAt: json['revealAt'] as String?,
        participants: (json['participants'] as List<dynamic>?)
            ?.map((e) => MdParticipant.fromJson(e as Map<String, dynamic>))
            .toList(),
        results: json['results'] == null
            ? <MdResult>[]
            : List<MdResult>.from(
                json['results'].map((x) => MdResult.fromJson(x))),
        crew: json['crew'] == null ? null : MdCrew.fromJson(json['crew']),
      );

  /// Properties
  final String? id;

  /// Creation timestamp
  final String? createdAt;

  /// Update timestamp
  final String? updatedAt;

  /// Status of the round
  final RoundStatus? status;

  /// Type of the round
  final String? type;

  /// Prompt for the round
  final String? prompt;

  /// Indicates if the prompt is custom
  final bool? isCustomPrompt;

  /// Indicates if the round is active
  final bool? isActive;

  /// Indicates if the round is deleted
  final bool? isDeleted;

  /// End time for joining the round
  final DateTime? roundJoinedEndAt;

  /// Reveal time for the round
  final String? revealAt;

  /// List of participants
  final List<MdParticipant>? participants;

  /// Results
  final List<MdResult>? results;

  /// Crew
  final MdCrew? crew;

  /// Convert object to JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'status': status?.value,
        'type': type,
        'prompt': prompt,
        'is_custom_prompt': isCustomPrompt,
        'is_active': isActive,
        'is_deleted': isDeleted,
        'round_joined_end_at': roundJoinedEndAt?.toIso8601String(),
        'revealAt': revealAt,
        'participants':
            participants?.map((MdParticipant e) => e.toJson()).toList(),
        'results': results == null
            ? <dynamic>[]
            : List<dynamic>.from(results!.map((MdResult x) => x.toJson())),
        'crew': crew?.toJson(),
      };
}
