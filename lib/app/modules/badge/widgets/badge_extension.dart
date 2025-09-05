import 'package:fvf_flutter/app/data/config/app_images.dart';

/// Badge Extension
extension BadgeExtension on String {
  /// Get badge icon path
  String get badgeIcon {
    switch (this) {
      case 'Bronze':
        return AppImages.bronzeIcon;
      case 'Silver':
        return AppImages.silverIcon;
      case 'Gold':
        return AppImages.goldIcon;
      case 'Platinum':
        return AppImages.platinumIcon;
      case 'Icon':
        return AppImages.flexIcon;
      case 'BDE':
        return AppImages.bdeIcon;
      default:
        return '';
    }
  }

  /// Get badge info string
  String get badgeInfo {
    switch (this) {
      case 'Bronze':
        return 'Getting Started ✨';
      case 'Silver':
        return 'On the Rise ✨';
      case 'Gold':
        return 'Proven Winner ✨';
      case 'Platinum':
        return 'Next Level ✨';
      case 'Icon':
        return 'Certified Flex ✨';
      case 'BDE':
        return 'Certified Flex ✨';
      default:
        return '';
    }
  }
}
