import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:fvf_flutter/app/data/config/env_config.dart';
import 'package:fvf_flutter/app/data/config/logger.dart';
import 'package:fvf_flutter/app/data/local/user_provider.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../enums/purchase_status.dart';
import '../../models/md_purchase_result.dart';
import '../notification_service/notification_service.dart';

/// RevenueCat Service
class RevenueCatService {
  /// Private constructor
  RevenueCatService._internal();

  /// Singleton instance
  static final RevenueCatService _instance = RevenueCatService._internal();

  /// Getter to access instance
  static RevenueCatService get instance => _instance;

  /// Cached products
  static final RxList<StoreProduct> _products = <StoreProduct>[].obs;

  /// Product identifiers (expandable in future)
  final List<String> _productIds = <String>[
    'slay_always_exposed_weekly',
    'slay.current_round',
    'one_more_slay',
  ];

  /// Weekly product ID
  String get weeklyProductId => _productIds.first;

  /// Current round product ID
  String get currentRoundProductId => _productIds[1];

  /// One more slay product ID
  String get oneMoreSlayProductId => _productIds[2];

  /// Entitlement key
  static const String _premiumEntitlement = 'premium';

  /// Current round entitlement key
  static const String _currentRoundEntitlement = 'current_round_access';

  /// One more slay entitlement key
  static const String _oneMoreSlayEntitlement = 'one_more_slay';

  /// Initialize RevenueCat
  Future<void> initRevenueCat() async {
    if (Platform.isAndroid) {
      await Purchases.configure(
        PurchasesConfiguration(
          EnvConfig.androidRevenueCatApiKey,
        ),
      );
    }

    await _fetchOfferingsAndProducts();
  }

  /// Fetch offerings and cache products from them
  Future<void> _fetchOfferingsAndProducts() async {
    try {
      final Offerings offerings = await Purchases.getOfferings();
      log('Offerings fetched: $offerings');

      final List<StoreProduct> allProducts = <StoreProduct>[];
      for (final Offering offering in offerings.all.values) {
        for (final Package package in offering.availablePackages) {
          allProducts.add(package.storeProduct);
        }
      }

      _products.assignAll(allProducts);
      logI('Products cached from offerings: ${allProducts.length}');
    } on Exception catch (e, st) {
      logE('Error fetching offerings/products: $e');
      logE(st);
    }
  }

  /// Get cached products
  List<StoreProduct> get products => _products;

  /// Purchase weekly subscription
  Future<MdPurchaseResult> purchaseWeeklySubscription() async =>
      _purchaseProduct(
        weeklyProductId,
        entitlementKey: _premiumEntitlement,
      );

  /// Purchase one more slay (one-time)
  Future<MdPurchaseResult> purchaseOneMoreSlay() async => _purchaseProduct(
        oneMoreSlayProductId,
        entitlementKey: _oneMoreSlayEntitlement,
      );

  /// Purchase current round (one-time)
  Future<MdPurchaseResult> purchaseCurrentRound({
    required String roundId,
  }) async =>
      _purchaseProduct(
        currentRoundProductId,
        entitlementKey: _currentRoundEntitlement,
        roundId: roundId,
      );

  /// Purchase a product by productId and return MdPurchaseResult
  Future<MdPurchaseResult> _purchaseProduct(
    String productId, {
    required String entitlementKey,
    String? roundId,
  }) async {
    final String? userId = UserProvider.currentUser?.id;

    final String? _fcmToken = await NotificationService().getToken();

    await Purchases.setAttributes(
      <String, String>{
        if (roundId != null && roundId.isNotEmpty) 'round_id': roundId,
        'product_context': entitlementKey,
        'user_id': userId ?? '',
        'fcm_token': _fcmToken ?? '',
      },
    );

    try {
      StoreProduct? product = _products.firstWhereOrNull(
        (StoreProduct p) =>
            p.identifier == productId || p.identifier.startsWith('$productId:'),
      );

      if (product == null) {
        logE('Product $productId not found. Refetching...');
        await _fetchOfferingsAndProducts();
        product = _products.firstWhereOrNull((StoreProduct p) =>
            p.identifier == productId ||
            p.identifier.startsWith('$productId:'));
        if (product == null) {
          logE('Still not found after refetching.');
          return MdPurchaseResult(
            status: PurchaseStatus.error,
            productId: productId,
            appUserId: userId,
          );
        }
      }

      final PurchaseResult result =
          await Purchases.purchaseStoreProduct(product);

      final bool isActive =
          result.customerInfo.entitlements.all[entitlementKey]?.isActive ??
              false;
      final PurchaseStatus status =
          isActive ? PurchaseStatus.success : PurchaseStatus.pending;

      return MdPurchaseResult(
        status: status,
        productId: productId,
        appUserId: result.customerInfo.originalAppUserId,
        customerInfo: result.customerInfo,
      );
    } on PlatformException catch (e) {
      logE('Purchase failed: $e');

      final dynamic details = e.details;
      final dynamic code = e.code;
      final bool userCancelled =
          details is Map && details['userCancelled'] == true;

      PurchaseStatus status;

      if (userCancelled) {
        status = PurchaseStatus.cancelled;
      } else if (code == '6' ||
          (details is Map &&
              details['readableErrorCode'] == 'ProductAlreadyPurchasedError')) {
        status = PurchaseStatus.alreadyPurchased;
      } else {
        status = PurchaseStatus.error;
      }

      return MdPurchaseResult(
        status: status,
        productId: productId,
        appUserId: UserProvider.currentUser?.id,
      );
    } on Exception catch (e, st) {
      logE('Unexpected purchase error: $e');
      logE(st);
      return MdPurchaseResult(
        status: PurchaseStatus.error,
        productId: productId,
        appUserId: UserProvider.currentUser?.id,
      );
    }
  }
}
