import 'package:fvf_flutter/app/modules/create_bet/models/md_participant.dart';

/// Socket data model
class MdSocketData {
  /// Constructor
  MdSocketData({
    this.round,
    this.hasAccess,
  });

  /// Factory constructor from JSON
  factory MdSocketData.fromJson(Map<String, dynamic> json) => MdSocketData(
        round: json['round'] != null ? Round.fromJson(json['round']) : null,
        hasAccess: json['hasAccess'] as bool?,
      );

  /// Round object
  final Round? round;

  /// Access flag
  final bool? hasAccess;

  /// Convert object to JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'round': round?.toJson(),
        'hasAccess': hasAccess,
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
  });

  /// From JSON
  factory Round.fromJson(Map<String, dynamic> json) => Round(
        id: json['id'] as String?,
        createdAt: json['createdAt'] as String?,
        updatedAt: json['updatedAt'] as String?,
        status: json['status'] as String?,
        type: json['type'] as String?,
        prompt: json['prompt'] as String?,
        isCustomPrompt: json['is_custom_prompt'] as bool?,
        isActive: json['is_active'] as bool?,
        isDeleted: json['is_deleted'] as bool?,
        roundJoinedEndAt: json['round_joined_end_at'] as String?,
        revealAt: json['revealAt'] as String?,
        participants: (json['participants'] as List<dynamic>?)
            ?.map((e) => MdParticipant.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  final String? id;
  final String? createdAt;
  final String? updatedAt;
  final String? status;
  final String? type;
  final String? prompt;
  final bool? isCustomPrompt;
  final bool? isActive;
  final bool? isDeleted;
  final String? roundJoinedEndAt;
  final String? revealAt;
  final List<MdParticipant>? participants;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'status': status,
        'type': type,
        'prompt': prompt,
        'is_custom_prompt': isCustomPrompt,
        'is_active': isActive,
        'is_deleted': isDeleted,
        'round_joined_end_at': roundJoinedEndAt,
        'revealAt': revealAt,
        'participants': participants?.map((e) => e.toJson()).toList(),
      };
}
