import 'package:fvf_flutter/app/data/config/app_images.dart';

/// Md badge
class MdBadge {
  /// Constructor
  MdBadge({
    this.badge,
    this.description,
    this.earned,
    this.current,
    this.earnedAt,
  });

  /// From json
  factory MdBadge.fromJson(Map<String, dynamic> json) => MdBadge(
        badge: json['badge'] ?? json['badge_type'],
        description: json['description'],
        earned: json['earned'],
        current: json['current'],
        earnedAt: json['earned_at'] == null
            ? null
            : DateTime.parse(json['earned_at']),
      );

  /// Badge
  String? badge;

  /// Description
  String? description;

  /// Earned
  bool? earned;

  /// Current
  bool? current;

  /// Earned at
  DateTime? earnedAt;

  /// Image url
  String get imageUrl {
    switch (badge?.trim()) {
      case 'BRONZE':
        return AppImages.bronze;
      case 'SILVER':
        return AppImages.silverBadge;
      case 'GOLD':
        return AppImages.goldBadge;
      case 'PLATINUM':
        return AppImages.platinumBadge;
      case 'ICONS':
        return AppImages.iconBadge;
      case 'BDE':
        return AppImages.bdeBadge;
      default:
        return AppImages.bronze;
    }
  }

  /// Get badge info string
  String get badgeInfo {
    switch (badge?.trim()) {
      case 'BRONZE':
        return 'Getting Started ✨';
      case 'SILVER':
        return 'On the Rise ✨';
      case 'GOLD':
        return 'Proven Winner ✨';
      case 'PLATINUM':
        return 'Next Level ✨';
      case 'ICONS':
        return 'Certified Flex ✨';
      case 'BDE':
        return 'Certified Flex ✨';
      default:
        return 'BRONZE';
    }
  }

  /// To json
  Map<String, dynamic> toJson() => <String, dynamic>{
        'badge': badge,
        'description': description,
        'earned': earned,
        'current': current,
        'earned_at': earnedAt?.toIso8601String(),
      };
}
