import {createHash} from "crypto";
import {getFirestore} from "firebase-admin/firestore";
import {EntitlementDoc, VerifiedSubscription} from "../types";

export type PurchaseSource = "apple" | "google";

/** The one document that decides whether a user is premium. */
export function entitlementRef(uid: string) {
  return getFirestore().doc(`users/${uid}/entitlement/current`);
}

/**
 * Index key for a subscription. Hashed because Google purchase tokens are long
 * enough to be awkward as document IDs and are effectively bearer credentials.
 */
function indexKey(source: PurchaseSource, id: string): string {
  return createHash("sha256").update(`${source}:${id}`).digest("hex");
}

function indexRef(source: PurchaseSource, id: string) {
  return getFirestore().doc(`subscriptionIndex/${indexKey(source, id)}`);
}

/** Persists the verified state as the user's entitlement. */
export async function writeEntitlement(
  uid: string,
  source: PurchaseSource,
  verified: VerifiedSubscription
): Promise<EntitlementDoc> {
  const doc: EntitlementDoc = {
    isPremium: verified.valid,
    productId: verified.productId,
    expiresAt: verified.expiresAt ? Date.parse(verified.expiresAt) : null,
    source,
    originalTransactionId: verified.originalTransactionId,
    environment: verified.environment,
    autoRenewing: verified.autoRenewing,
    updatedAt: Date.now(),
  };

  await entitlementRef(uid).set(doc);
  return doc;
}

/**
 * Whether the user is entitled right now.
 *
 * Re-checks the expiry rather than trusting `isPremium` alone, so a missed or
 * delayed renewal notification degrades to "expired" instead of granting
 * premium forever.
 */
export async function isEntitled(uid: string): Promise<boolean> {
  const snap = await entitlementRef(uid).get();
  if (!snap.exists) return false;

  const data = snap.data() as EntitlementDoc;
  if (!data.isPremium) return false;
  if (data.expiresAt != null && data.expiresAt < Date.now()) return false;

  return true;
}

/**
 * Records which account owns a subscription, so a renewal notification — which
 * carries a transaction, not a uid — can be routed back to the right user.
 *
 * The Apple receipt is stored alongside because Apple's notifications are only
 * a trigger: we re-verify from the receipt rather than trusting the payload.
 */
export async function linkSubscription(params: {
  uid: string;
  source: PurchaseSource;
  id: string;
  receipt?: string;
}): Promise<void> {
  const {uid, source, id, receipt} = params;
  await indexRef(source, id).set(
    {
      uid,
      source,
      ...(receipt ? {receipt} : {}),
      updatedAt: Date.now(),
    },
    {merge: true}
  );
}

/** Looks up the account and stored receipt behind a store notification. */
export async function lookupSubscription(
  source: PurchaseSource,
  id: string
): Promise<{uid: string; receipt?: string} | null> {
  const snap = await indexRef(source, id).get();
  if (!snap.exists) return null;

  const data = snap.data() as {uid?: string; receipt?: string};
  if (!data.uid) return null;

  return {uid: data.uid, receipt: data.receipt};
}
