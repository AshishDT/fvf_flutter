import '../enums/purchase_status.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// Model returned from purchase attempts
class MdPurchaseResult {
  /// Constructor
  MdPurchaseResult({
    required this.status,
    required this.productId,
    this.appUserId,
    this.customerInfo,
  });

  /// Status
  final PurchaseStatus status;

  /// App User ID
  final String? appUserId;

  /// Product ID
  final String productId;

  /// Customer Info
  final CustomerInfo? customerInfo;
}
