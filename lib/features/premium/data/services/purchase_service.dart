import 'dart:async';
import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/database/daos/preferences_dao.dart';

/// Product IDs for the subscription tiers.
/// Mirrored in functions/src/constants/products.ts.
abstract class ProductIds {
  static const monthly = 'premium_monthly';
  static const annual = 'premium_annual';
  static const all = {monthly, annual};
}

/// Manages in-app purchases including subscription purchasing,
/// receipt verification via Cloud Function, and restoring purchases.
///
/// Entitlement is never granted locally on the strength of a failed or
/// unreachable verification. A purchase the server could not confirm is
/// persisted and retried instead — see [retryPendingVerification].
class PurchaseService {
  static const _pendingKey = 'pending_purchase_verification';

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

  /// Re-submits a receipt the server could not confirm last time.
  ///
  /// Call on app start. Does nothing when there is no pending receipt.
  Future<void> retryPendingVerification() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_pendingKey);
    if (raw == null) return;

    late final Map<String, dynamic> pending;
    try {
      pending = jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      await prefs.remove(_pendingKey);
      return;
    }

    debugPrint('Retrying pending purchase verification');
    await _verifyReceipt(
      receipt: pending['receipt'] as String,
      source: pending['source'] as String,
      productId: pending['productId'] as String,
      purchaseId: pending['purchaseId'] as String?,
      announce: false,
    );
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
          // Nothing was bought, so acknowledge and clear it from the queue.
          await _completeIfNeeded(purchase);
          break;

        case PurchaseStatus.canceled:
          _stateController.add(const PurchaseState.idle());
          await _completeIfNeeded(purchase);
          break;
      }
    }
  }

  Future<void> _verifyAndFinalize(PurchaseDetails purchase) async {
    final source =
        defaultTargetPlatform == TargetPlatform.iOS ? 'apple' : 'google';

    final resolved = await _verifyReceipt(
      receipt: purchase.verificationData.serverVerificationData,
      source: source,
      productId: purchase.productID,
      purchaseId: purchase.purchaseID,
      announce: true,
    );

    // Only acknowledge once the server has given a definitive answer. Leaving
    // an unconfirmed purchase pending means the store re-delivers it on next
    // launch, which is a second safety net behind our own stored retry.
    if (resolved) {
      await _completeIfNeeded(purchase);
    }
  }

  /// Sends a receipt to the backend for verification.
  ///
  /// Returns true when the store reached a verdict either way, false when the
  /// attempt was transient and the receipt has been stored for retry.
  Future<bool> _verifyReceipt({
    required String receipt,
    required String source,
    required String productId,
    required String? purchaseId,
    required bool announce,
  }) async {
    try {
      final result = await _functions.httpsCallable('verifyReceipt').call({
        'receipt': receipt,
        'source': source,
        'productId': productId,
      });

      final data = Map<String, dynamic>.from(result.data as Map);
      final valid = data['valid'] as bool? ?? false;

      final expiresAtStr = data['expiresAt'] as String?;
      final expiresAt =
          expiresAtStr != null ? DateTime.tryParse(expiresAtStr) : null;

      await _preferencesDao.applyEntitlement(
        isPremium: valid,
        subscriptionId: purchaseId,
        plan: data['productId'] as String? ?? productId,
        expiresAt: expiresAt,
      );

      await _clearPending();

      if (announce) {
        _stateController.add(valid
            ? const PurchaseState.success()
            : const PurchaseState.error(
                'The store could not confirm this purchase. If you were '
                'charged, tap Restore Purchases or contact support.'));
      }
      return true;
    } on FirebaseFunctionsException catch (e) {
      // `unavailable` is the backend telling us the store was unreachable.
      // Anything else is also treated as transient: we would rather retry than
      // wrongly tell a paying user their purchase failed.
      debugPrint('Receipt verification error (${e.code}): ${e.message}');
      await _storePending(
        receipt: receipt,
        source: source,
        productId: productId,
        purchaseId: purchaseId,
      );
      if (announce) {
        _stateController.add(const PurchaseState.verificationPending());
      }
      return false;
    } catch (e) {
      debugPrint('Receipt verification error: $e');
      await _storePending(
        receipt: receipt,
        source: source,
        productId: productId,
        purchaseId: purchaseId,
      );
      if (announce) {
        _stateController.add(const PurchaseState.verificationPending());
      }
      return false;
    }
  }

  Future<void> _storePending({
    required String receipt,
    required String source,
    required String productId,
    required String? purchaseId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _pendingKey,
      jsonEncode({
        'receipt': receipt,
        'source': source,
        'productId': productId,
        'purchaseId': purchaseId,
      }),
    );
  }

  Future<void> _clearPending() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pendingKey);
  }

  Future<void> _completeIfNeeded(PurchaseDetails purchase) async {
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
  const factory PurchaseState.verificationPending() = PurchaseVerificationPending;
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

/// The purchase went through but the backend could not confirm it yet.
/// The receipt is stored and retried automatically; access is not granted.
class PurchaseVerificationPending extends PurchaseState {
  const PurchaseVerificationPending() : super._();
}

class PurchaseError extends PurchaseState {
  final String message;
  const PurchaseError(this.message) : super._();
}
