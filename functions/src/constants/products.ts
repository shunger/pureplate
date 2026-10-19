/**
 * Subscription product IDs. Must stay in sync with `ProductIds` in
 * lib/features/premium/data/services/purchase_service.dart.
 */
export const PREMIUM_PRODUCT_IDS = [
  "ppmonthly02",
  "ppannual02",
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

/** iOS bundle ID, from ios/Runner.xcodeproj. Checked on every Apple JWS. */
export const IOS_BUNDLE_ID = "com.purehungerlabs.purepantry";

/**
 * The app's numeric Apple ID (App Store Connect → App Information → Apple ID).
 * Apple requires it to verify Production transactions; Sandbox and TestFlight
 * work without it. Production purchases stay pending (and retry) until set.
 */
export const APPLE_APP_ID: number | null = null;
