import 'package:fvf_flutter/app/modules/create_bet/models/md_round.dart';

/// Round Details Model
class MdRoundDetails {
  ///  Constructor
  MdRoundDetails({
    this.round,
    this.hasAccess,
  });

  /// From JSON
  factory MdRoundDetails.fromJson(Map<String, dynamic> json) => MdRoundDetails(
        round: json['round'] == null ? null : MdRound.fromJson(json['round']),
        hasAccess: json['hasAccess'],
      );

  /// Round
  MdRound? round;

  /// Has access
  bool? hasAccess;

  /// To JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'round': round?.toJson(),
        'hasAccess': hasAccess,
      };
}
