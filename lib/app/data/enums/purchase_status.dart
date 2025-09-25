/// Purchase status enum
enum PurchaseStatus {
  /// Purchase successful
  success,

  /// Product already purchased
  alreadyPurchased,

  /// Cancelled by user
  cancelled,

  /// Purchase is pending
  pending,

  /// Purchase failed
  error,
}
