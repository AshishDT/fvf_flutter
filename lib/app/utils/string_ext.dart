/// String extension methods for common string manipulations.
extension StringExt on String {
  /// Converts the string to a title case format.
  String get getInitials {
    if (trim().isEmpty) {
      return '?';
    }
    final List<String> parts = trim().split(' ');
    if (parts.length == 1) {
      return parts[0].substring(0, 1).toUpperCase();
    } else {
      return (parts[0].substring(0, 1) + parts[1].substring(0, 1))
          .toUpperCase();
    }
  }
}
