import {defineSecret} from "firebase-functions/params";
import {google, androidpublisher_v3} from "googleapis";
import {ANDROID_PACKAGE_NAME, isPremiumProductId} from "../constants/products";
import {VerifiedSubscription} from "../types";

/**
 * JSON key for a service account with the "View financial data" permission in
 * Play Console, stored whole as a single secret.
 */
export const googlePlayServiceAccount = defineSecret(
  "GOOGLE_PLAY_SERVICE_ACCOUNT"
);

/** States in which Google still considers the user entitled. */
const ENTITLED_STATES = new Set([
  "SUBSCRIPTION_STATE_ACTIVE",
  "SUBSCRIPTION_STATE_IN_GRACE_PERIOD",
]);

function invalid(reason: string): VerifiedSubscription {
  return {
    valid: false,
    productId: null,
    expiresAt: null,
    originalTransactionId: null,
    environment: null,
    autoRenewing: false,
    reason,
  };
}

function publisher(): androidpublisher_v3.Androidpublisher {
  const auth = new google.auth.GoogleAuth({
    credentials: JSON.parse(googlePlayServiceAccount.value()),
    scopes: ["https://www.googleapis.com/auth/androidpublisher"],
  });
  return google.androidpublisher({version: "v3", auth});
}

function expiryMs(item: androidpublisher_v3.Schema$SubscriptionPurchaseLineItem): number {
  if (!item.expiryTime) return 0;
  const parsed = Date.parse(item.expiryTime);
  return Number.isFinite(parsed) ? parsed : 0;
}

/**
 * Verifies a Google Play purchase token against the Play Developer API.
 *
 * The purchase token is the stable identity for a subscription — it survives
 * renewals — so it doubles as the key we index the account by.
 */
export async function verifyGooglePurchase(
  purchaseToken: string
): Promise<VerifiedSubscription> {
  const res = await publisher().purchases.subscriptionsv2.get({
    packageName: ANDROID_PACKAGE_NAME,
    token: purchaseToken,
  });

  const sub = res.data;
  const items = (sub.lineItems ?? []).filter((li) =>
    isPremiumProductId(li.productId ?? undefined)
  );
  if (items.length === 0) {
    return invalid("no_matching_product");
  }

  const latest = items.reduce((best, li) =>
    expiryMs(li) > expiryMs(best) ? li : best
  );

  const expiresMs = expiryMs(latest);
  if (expiresMs <= 0) {
    return invalid("no_expiry");
  }

  const state = sub.subscriptionState ?? "";

  // A cancelled subscription stays entitled until the paid period runs out,
  // so trust the expiry rather than the state alone.
  const entitled =
    ENTITLED_STATES.has(state) ||
    (state === "SUBSCRIPTION_STATE_CANCELED" && expiresMs > Date.now());

  return {
    valid: entitled && expiresMs > Date.now(),
    productId: latest.productId ?? null,
    expiresAt: new Date(expiresMs).toISOString(),
    originalTransactionId: purchaseToken,
    environment: sub.testPurchase ? "sandbox" : "production",
    autoRenewing: latest.autoRenewingPlan?.autoRenewEnabled ?? false,
    reason: entitled ? undefined : `play_state_${state}`,
  };
}
