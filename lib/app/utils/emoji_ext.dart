import 'package:fvf_flutter/app/data/config/app_images.dart';

/// Emoji Extension
extension EmojiExtension on String {
  /// Get emoji image path
  String get emojiImagePath {
    switch (this) {
      case '🔥':
        return AppImages.fireEmoji;
      case '❤️':
        return AppImages.heartEmoji;
      case '😂':
        return AppImages.laughingEmoji;
      case '😮':
        return AppImages.shockingEmoji;
      case '😢':
        return AppImages.sadEmoji;
      default:
        return '';
    }
  }
}
