/// Model class representing premium access details.
class MdPremiumAccess {
  /// Constructor for MdPremiumAccess.
  MdPremiumAccess({
    this.identifier,
    this.isActive,
    this.latestPurchaseDate,
    this.originalPurchaseDate,
    this.expirationDate,
    this.unsubscribeDetectedAt,
    this.productPlan,
    this.appUserId,
  });

  /// Identifier for the premium access.
  final String? identifier;

  /// User ID associated with the premium access.
  final String? appUserId;

  /// Indicates whether the premium access is currently active.
  final bool? isActive;

  /// The latest purchase date of the premium access.
  final String? latestPurchaseDate;

  /// The original purchase date of the premium access.
  final String? originalPurchaseDate;

  /// Expiration date of the premium access, if applicable.
  final String? expirationDate;

  /// Date when unsubscribe was detected, if applicable.
  final String? unsubscribeDetectedAt;

  /// Product plan associated with the premium access, if applicable.
  final String? productPlan;
}
