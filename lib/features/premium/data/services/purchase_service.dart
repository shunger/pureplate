import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../../core/database/daos/preferences_dao.dart';

/// Product IDs for the subscription tiers.
abstract class ProductIds {
  static const monthly = 'premium_monthly';
  static const annual = 'premium_annual';
  static const all = {monthly, annual};
}

/// Manages in-app purchases including subscription purchasing,
/// receipt verification via Cloud Function, and restoring purchases.
class PurchaseService {
  final InAppPurchase _iap;
  final FirebaseFunctions _functions;
  final PreferencesDao _preferencesDao;

  StreamSubscription<List<PurchaseDetails>>? _subscription;
  final _stateController = StreamController<PurchaseState>.broadcast();

  /// Stream of purchase state changes for UI updates.
  Stream<PurchaseState> get stateStream => _stateController.stream;

  PurchaseService({
    required PreferencesDao preferencesDao,
    FirebaseFunctions? functions,
    InAppPurchase? iap,
  })  : _preferencesDao = preferencesDao,
        _functions = functions ?? FirebaseFunctions.instance,
        _iap = iap ?? InAppPurchase.instance {
    _listenToPurchases();
  }

  void _listenToPurchases() {
    _subscription = _iap.purchaseStream.listen(
      _handlePurchaseUpdates,
      onError: (error) {
        debugPrint('Purchase stream error: $error');
        _stateController.add(const PurchaseState.error(
            'An error occurred with the purchase. Please try again.'));
      },
    );
  }

  /// Load available products from the store.
  Future<List<ProductDetails>> loadProducts() async {
    if (!await _iap.isAvailable()) {
      return [];
    }

    final response = await _iap.queryProductDetails(ProductIds.all);
    if (response.error != null) {
      debugPrint('Product query error: ${response.error}');
    }
    return response.productDetails;
  }

  /// Initiate a subscription purchase.
  Future<void> purchaseSubscription(ProductDetails product) async {
    _stateController.add(const PurchaseState.purchasing());

    final purchaseParam = PurchaseParam(productDetails: product);
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  /// Restore previous purchases.
  Future<void> restorePurchases() async {
    _stateController.add(const PurchaseState.restoring());
    await _iap.restorePurchases();
  }

  Future<void> _handlePurchaseUpdates(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final purchase in purchaseDetailsList) {
      switch (purchase.status) {
        case PurchaseStatus.pending:
          _stateController.add(const PurchaseState.purchasing());
          break;

        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          await _verifyAndFinalize(purchase);
          break;

        case PurchaseStatus.error:
          _stateController.add(PurchaseState.error(
            purchase.error?.message ?? 'Purchase failed. Please try again.',
          ));
          break;

        case PurchaseStatus.canceled:
          _stateController.add(const PurchaseState.idle());
          break;
      }
    }
  }

  Future<void> _verifyAndFinalize(PurchaseDetails purchase) async {
    try {
      // Determine source based on platform.
      final source =
          defaultTargetPlatform == TargetPlatform.iOS ? 'apple' : 'google';

      // Verify receipt with Cloud Function.
      final result =
          await _functions.httpsCallable('verifyReceipt').call({
        'receipt': purchase.verificationData.serverVerificationData,
        'source': source,
        'productId': purchase.productID,
      });

      final data = result.data as Map<String, dynamic>;
      final valid = data['valid'] as bool? ?? false;

      if (valid) {
        // Update local DB with subscription info.
        final expiresAtStr = data['expiresAt'] as String?;
        final expiresAt =
            expiresAtStr != null ? DateTime.tryParse(expiresAtStr) : null;

        await _preferencesDao.setSubscription(
          subscriptionId: purchase.purchaseID,
          plan: purchase.productID,
          expiresAt: expiresAt,
        );

        _stateController.add(const PurchaseState.success());
      } else {
        _stateController.add(
            const PurchaseState.error('Purchase verification failed.'));
      }
    } catch (e) {
      debugPrint('Receipt verification error: $e');
      // On verification failure, still grant access optimistically
      // and mark for later re-verification.
      await _preferencesDao.setPremium(true);
      _stateController.add(const PurchaseState.success());
    }

    // Always complete the purchase to acknowledge it with the store.
    if (purchase.pendingCompletePurchase) {
      await _iap.completePurchase(purchase);
    }
  }

  /// Dispose the purchase stream subscription.
  void dispose() {
    _subscription?.cancel();
    _stateController.close();
  }
}

/// Represents the current state of the purchase flow.
sealed class PurchaseState {
  const PurchaseState._();
  const factory PurchaseState.idle() = PurchaseIdle;
  const factory PurchaseState.purchasing() = PurchasePurchasing;
  const factory PurchaseState.restoring() = PurchaseRestoring;
  const factory PurchaseState.success() = PurchaseSuccess;
  const factory PurchaseState.error(String message) = PurchaseError;
}

class PurchaseIdle extends PurchaseState {
  const PurchaseIdle() : super._();
}

class PurchasePurchasing extends PurchaseState {
  const PurchasePurchasing() : super._();
}

class PurchaseRestoring extends PurchaseState {
  const PurchaseRestoring() : super._();
}

class PurchaseSuccess extends PurchaseState {
  const PurchaseSuccess() : super._();
}

class PurchaseError extends PurchaseState {
  final String message;
  const PurchaseError(this.message) : super._();
}
