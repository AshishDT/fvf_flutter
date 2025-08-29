import 'package:fvf_flutter/app/data/config/logger.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// RevenueCatService
class RevenueCatService {
  /// Private constructor
  RevenueCatService._internal();

  /// Singleton instance
  static final RevenueCatService _instance = RevenueCatService._internal();

  /// Getter to access instance
  static RevenueCatService get instance => _instance;

  /// Product identifiers (must match App Store / Play Console)
  final List<String> _productIds = <String>[
    'one_round:round-pe-1',
    'weekly_round:round-pe-7',
  ];

  /// Initialize RevenueCat
  Future<void> initRevenueCat(String apiKey, {String? userId}) async {
    await Purchases.setLogLevel(LogLevel.debug);

    await Purchases.configure(
      PurchasesConfiguration(apiKey)
        // ..appUserID = userId,
    );
  }

  /// Fetch offerings
  Future<List<Package>> fetchOfferings() async {
    try {
      final Offerings offerings = await Purchases.getOfferings();
      logI('AvailablePackages :::: ${offerings.current?.availablePackages}');
      if (offerings.current != null) {
        return offerings.current!.availablePackages;
      }
      return <Package>[];
    } catch (e, st) {
      logE('⚠️ Error fetching offerings: $e');
      logE(st);
      return <Package>[];
    }
  }

  /// Fetch products directly (without offerings)
  Future<List<StoreProduct>> fetchProducts() async {
    try {
      final List<StoreProduct> products =
          await Purchases.getProducts(_productIds);
      logI('Fetched products: $products');
      return products;
    } catch (e, st) {
      logE('⚠️ Error fetching products: $e');
      logE(st);
      return <StoreProduct>[];
    }
  }

  /// Purchase a product by identifier
  Future<bool> purchaseProduct(StoreProduct storeProduct) async {
    try {
      final PurchaseResult customerInfo =
          await Purchases.purchaseStoreProduct(storeProduct);
      return customerInfo.customerInfo.entitlements.all['premium']?.isActive ??
          false;
    } catch (e, st) {
      logE('⚠️ Purchase failed: $e');
      logE(st);
      return false;
    }
  }

  /// Restore purchases
  Future<bool> restorePurchases() async {
    try {
      final CustomerInfo customerInfo = await Purchases.restorePurchases();
      return customerInfo.entitlements.all['premium']?.isActive ?? false;
    } catch (e, st) {
      logE('⚠️ Restore failed: $e');
      logE(st);
      return false;
    }
  }

  /// Check if user has premium
  Future<bool> isPremiumUser() async {
    try {
      final CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.entitlements.all['premium']?.isActive ?? false;
    } catch (e, st) {
      logE('⚠️ Error checking premium: $e');
      logE(st);
      return false;
    }
  }
}
