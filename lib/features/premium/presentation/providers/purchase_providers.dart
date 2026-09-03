import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../../core/providers/database_providers.dart';
import '../../data/services/entitlement_service.dart';
import '../../data/services/purchase_service.dart';

/// Singleton provider for the purchase service.
final purchaseServiceProvider = Provider<PurchaseService>((ref) {
  final service = PurchaseService(
    preferencesDao: ref.watch(preferencesDaoProvider),
  );
  ref.onDispose(() => service.dispose());
  return service;
});

/// Loads available subscription products from the store.
final availableProductsProvider =
    FutureProvider<List<ProductDetails>>((ref) async {
  final service = ref.watch(purchaseServiceProvider);
  return service.loadProducts();
});

/// Stream of purchase state changes.
final purchaseStateProvider = StreamProvider<PurchaseState>((ref) {
  final service = ref.watch(purchaseServiceProvider);
  return service.stateStream;
});

/// Syncs server-owned entitlement into the local cache.
final entitlementServiceProvider = Provider<EntitlementService>((ref) {
  return EntitlementService(
    preferencesDao: ref.watch(preferencesDaoProvider),
  );
});

/// Watched once at app start. Keeps premium status current for the lifetime of
/// the session and retries any purchase the backend could not confirm.
final entitlementSyncProvider = StreamProvider<bool>((ref) {
  // Fire-and-forget: a receipt stranded by a previous transient failure.
  ref.read(purchaseServiceProvider).retryPendingVerification();

  return ref.watch(entitlementServiceProvider).watch();
});
