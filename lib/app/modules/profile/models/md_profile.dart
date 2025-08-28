import 'dart:convert';
import 'package:fvf_flutter/app/data/models/md_user.dart';

/// MdProfile model (only data)
class MdProfile {
  MdProfile({
    this.user,
    this.round,
  });

  /// From JSON
  factory MdProfile.fromJson(Map<String, dynamic> json) => MdProfile(
    user: json['user'] == null ? null : MdUser.fromJson(json['user']),
    round: json['round'] == null ? null : Round.fromJson(json['round']),
  );

  /// User object
  MdUser? user;

  /// Round object
  Round? round;

  /// To JSON
  Map<String, dynamic> toJson() => {
    'user': user?.toJson(),
    'round': round?.toJson(),
  };

  /// As string
  String asString() => json.encode(toJson());
}

/// Round model
class Round {
  /// Constructor
  Round({
    this.userId,
    this.totalRound,
    this.winsCount,
    this.wins,
    this.emojiCount,
  });

  /// From JSON
  factory Round.fromJson(Map<String, dynamic> json) => Round(
    userId: json['userId'],
    totalRound: json['total_round'],
    winsCount: json['wins_count'],
    emojiCount: json['emoji_count'],
    wins: json['wins'] == null
        ? <dynamic>[]
        : List<dynamic>.from(json['wins'].map((x) => x)),
  );

  /// User ID
  String? userId;

  /// Total rounds
  int? totalRound;

  /// Wins count
  int? winsCount;

  /// Emoji count
  int? emojiCount;

  /// Wins list
  List<dynamic>? wins;

  /// To JSON
  Map<String, dynamic> toJson() => {
    'userId': userId,
    'total_round': totalRound,
    'wins_count': winsCount,
    'emoji_count': emojiCount,
    'wins': wins == null ? <dynamic>[] : List<dynamic>.from(wins!.map((x) => x)),
  };
}
