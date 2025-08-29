/// Round Status Enum
enum RoundStatus {
  /// Pending
  pending,

  /// Processing
  processing,

  /// Completed
  completed,

  ///  Failed
  failed,
}

/// Extension for RoundStatus enum
extension RoundStatusX on RoundStatus {
  /// Convert enum to string
  String get value {
    switch (this) {
      case RoundStatus.pending:
        return 'PENDING';
      case RoundStatus.processing:
        return 'PROCESSING';
      case RoundStatus.completed:
        return 'COMPLETED';
      case RoundStatus.failed:
        return 'FAILED';
    }
  }

  /// Parse from string safely
  static RoundStatus fromString(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return RoundStatus.pending;
      case 'PROCESSING':
        return RoundStatus.processing;
      case 'COMPLETED':
        return RoundStatus.completed;
      case 'FAILED':
        return RoundStatus.failed;
      default:
        return RoundStatus.pending;
    }
  }
}
