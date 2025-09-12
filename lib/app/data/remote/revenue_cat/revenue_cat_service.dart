import 'package:fvf_flutter/app/data/config/logger.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// RevenueCatService
class RevenueCatService {
  /// Private constructor
  RevenueCatService._internal();

  /// Singleton instance
  static final RevenueCatService _instance = RevenueCatService._internal();

  /// Getter to access instance
  static RevenueCatService get instance => _instance;

  /// Cached products
  static final RxList<StoreProduct> _products = <StoreProduct>[].obs;

  /// Product identifiers (must match Play Console / App Store)
  final List<String> _productIds = <String>[
    'slay_current_round',
    'slay_always_exposed_weekly',
  ];

  /// Initialize RevenueCat + fetch products once
  Future<void> initRevenueCat({String? userId}) async {
    await Purchases.setLogLevel(LogLevel.debug);

    await Purchases.configure(
      PurchasesConfiguration(
        'goog_UxAaepnPQpZBRxFejFmUKwgBzlR',
      ),
    );
  }

  /// Internal fetch products and cache
  Future<void> _fetchProducts() async {
    try {
      final List<StoreProduct> products =
      await Purchases.getProducts(_productIds);

      _products.assignAll(products);
      logI('Products cached: $products');
    } on Exception catch (e, st) {
      logE('Error fetching products: $e');
      logE(st);
    }
  }

  /// Get cached products
  List<StoreProduct> get products => _products;

  /// Purchase a product by productId
  Future<bool> purchase(String productId) async {
    try {
      logWTF('Attempting to purchase product: $productId');
      final StoreProduct? product =
      _products.firstWhereOrNull((StoreProduct p) => p.identifier == productId);

      if (product == null) {
        logE('Product $productId not found in cache. Refetching...');
        await _fetchProducts();
        return purchase(productId);
      }

      final PurchaseResult result =
      await Purchases.purchaseStoreProduct(product);

      return result.customerInfo.entitlements.all['premium']?.isActive ?? false;
    } on Exception catch (e, st) {
      logE('Purchase failed: $e');
      logE(st);
      return false;
    }
  }

  /// Restore purchases
  Future<bool> restorePurchases() async {
    try {
      final CustomerInfo info = await Purchases.restorePurchases();
      return info.entitlements.all['premium']?.isActive ?? false;
    } on Exception catch (e, st) {
      logE('⚠Restore failed: $e');
      logE(st);
      return false;
    }
  }

  /// Check if user has premium
  Future<bool> isPremiumUser() async {
    try {
      final CustomerInfo info = await Purchases.getCustomerInfo();
      return info.entitlements.all['premium']?.isActive ?? false;
    } on Exception catch (e, st) {
      logE('Error checking premium: $e');
      logE(st);
      return false;
    }
  }
}
