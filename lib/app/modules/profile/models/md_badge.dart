import 'package:fvf_flutter/app/data/config/app_images.dart';

/// Md badge
class MdBadge {
  /// Constructor
  MdBadge({
    this.badge,
    this.description,
    this.earned,
    this.current,
  });

  /// From json
  factory MdBadge.fromJson(Map<String, dynamic> json) => MdBadge(
        badge: json['badge'],
        description: json['description'],
        earned: json['earned'],
        current: json['current'],
      );

  /// Badge
  String? badge;

  /// Description
  String? description;

  /// Earned
  bool? earned;

  /// Current
  bool? current;

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

  /// To json
  Map<String, dynamic> toJson() => <String, dynamic>{
        'badge': badge,
        'description': description,
        'earned': earned,
        'current': current,
      };
}
