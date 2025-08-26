import '../../../data/models/md_join_invitation.dart';
import 'md_participant.dart';

/// To parse this JSON data, do
class MdRound {
  /// Md round
  MdRound({
    this.prompt,
    this.isCustomPrompt,
    this.host,
    this.roundJoinedEndAt,
    this.status,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.isActive,
    this.isDeleted,
    this.participants,
  });

  /// From JSON
  factory MdRound.fromJson(Map<String, dynamic> json) => MdRound(
        prompt: json['prompt'],
        isCustomPrompt: json['is_custom_prompt'],
        host: json['host'] == null ? null : RoundHost.fromJson(json['host']),
        roundJoinedEndAt: json['round_joined_end_at'] == null
            ? null
            : DateTime.parse(json['round_joined_end_at']),
        status: json['status'],
        id: json['id'],
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt']),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt']),
        isActive: json['is_active'],
        isDeleted: json['is_deleted'],
        participants: json['participants'] == null
            ? <MdParticipant>[]
            : (json['participants'] as List<dynamic>)
                .map((dynamic e) => MdParticipant.fromJson(e))
                .toList(),
      );

  /// Prompt
  String? prompt;

  /// Is custom prompt
  bool? isCustomPrompt;

  /// Host
  RoundHost? host;

  /// Round joined end at
  DateTime? roundJoinedEndAt;

  /// Status
  String? status;

  /// Round Id
  String? id;

  /// Created at
  DateTime? createdAt;

  /// Updated at
  DateTime? updatedAt;

  /// Is active
  bool? isActive;

  /// Is deleted
  bool? isDeleted;

  /// Participants in the round
  List<MdParticipant>? participants;

  /// To JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'prompt': prompt,
        'is_custom_prompt': isCustomPrompt,
        'host': host?.toJson(),
        'round_joined_end_at': roundJoinedEndAt?.toIso8601String(),
        'status': status,
        'id': id,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'is_active': isActive,
        'is_deleted': isDeleted,
        'participants': participants?.map((e) => e.toJson()).toList(),
      };
}
