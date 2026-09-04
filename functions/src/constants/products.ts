/**
 * Subscription product IDs. Must stay in sync with `ProductIds` in
 * lib/features/premium/data/services/purchase_service.dart.
 */
export const PREMIUM_PRODUCT_IDS = [
  "premium_monthly",
  "premium_annual",
] as const;

export type PremiumProductId = (typeof PREMIUM_PRODUCT_IDS)[number];

/**
 * Whether a store-reported product ID is one of ours. Used to reject receipts
 * for products that are real but not a Pure Pantry subscription.
 */
export function isPremiumProductId(
  id: string | null | undefined
): id is PremiumProductId {
  return !!id && (PREMIUM_PRODUCT_IDS as readonly string[]).includes(id);
}

/** Android applicationId, from android/app/build.gradle.kts. */
export const ANDROID_PACKAGE_NAME = "com.purehungerlabs.purepantryai";
