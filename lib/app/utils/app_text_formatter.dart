import 'package:flutter/services.dart';
import 'package:emoji_regex/emoji_regex.dart';

/// Allows only letters, numbers, spaces, and emojis; limits emojis to [maxEmojis].
class AppTextFormatter extends TextInputFormatter {
  /// Constructor for AppTextFormatter
  AppTextFormatter({this.maxEmojis = 5});

  /// Maximum number of emojis allowed in the input.
  final int maxEmojis;

  static final RegExp _whitelist = RegExp(
    r'[\p{Letter}\p{Number}\s]|'
    r'(?:'
    r'[\u00A9\u00AE\u203C\u2049\u2122\u2139\u2194-\u2199\u21A9-\u21AA\u231A-\u231B\u2328\u23CF\u23E9-\u23F3\u23F8-\u23FA\u24C2\u25AA-\u25AB\u25B6\u25C0\u25FB-\u25FE\u2600-\u27BF\u2934-\u2935\u2B05-\u2B07\u2B1B-\u2B1C\u2B50\u2B55\u3030\u303D\u3297\u3299]'
    r'|[\uD83C\uD000-\uD83C\uDFFF][\uDC00-\uDFFF]?'
    r'|[\uD83D\uD000-\uD83D\uDFFF][\uDC00-\uDFFF]?'
    r'|[\uD83E\uD000-\uD83E\uDFFF][\uDC00-\uDFFF]?'
    r')',
    unicode: true,
  );

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final StringBuffer buffer = StringBuffer();
    for (final int rune in newValue.text.runes) {
      final String ch = String.fromCharCode(rune);
      if (_whitelist.hasMatch(ch)) {
        buffer.write(ch);
      }
    }
    final String cleaned = buffer.toString();

    final RegExp emojiRe = emojiRegex();
    final List<RegExpMatch> matches = emojiRe.allMatches(cleaned).toList();
    if (matches.length > maxEmojis) {
      return oldValue;
    }

    final TextSelection selection = TextSelection.collapsed(
      offset: cleaned.length,
    );
    return TextEditingValue(
      text: cleaned,
      selection: selection,
    );
  }
}
