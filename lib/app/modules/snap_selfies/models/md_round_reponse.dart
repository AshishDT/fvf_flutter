import 'dart:convert';

import 'package:fvf_flutter/app/modules/create_bet/models/md_round.dart';

/// Root Model
class RoundResponse {
  /// Constructor
  RoundResponse({
    required this.round,
    required this.hasAccess,
  });

  /// Helper for raw string parsing
  factory RoundResponse.fromRawJson(String str) =>
      RoundResponse.fromJson(json.decode(str));

  /// From JSON
  factory RoundResponse.fromJson(Map<String, dynamic> json) => RoundResponse(
        round: MdRound.fromJson(json['round'] as Map<String, dynamic>),
        hasAccess: json['hasAccess'] as bool,
      );

  /// Round
  final MdRound round;

  /// Has access
  final bool hasAccess;

  /// To JSON
  Map<String, dynamic> toJson() => {
        'round': round.toJson(),
        'hasAccess': hasAccess,
      };

  /// Helper for raw string parsing
  String toRawJson() => json.encode(toJson());
}
