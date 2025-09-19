import 'package:flutter/services.dart';
import 'package:emoji_regex/emoji_regex.dart';

/// Emoji limiter formatter
class EmojiLimiterFormatter extends TextInputFormatter {
  /// Emoji limiter formatted
  EmojiLimiterFormatter({this.maxEmojis = 5});

  /// Max emojis
  final int maxEmojis;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final RegExp regex = emojiRegex();
    final List<RegExpMatch> matches = regex.allMatches(newValue.text).toList();

    if (matches.length <= maxEmojis) {
      return newValue;
    }

    return oldValue;
  }
}
