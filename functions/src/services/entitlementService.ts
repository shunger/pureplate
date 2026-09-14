import {createHash} from "crypto";
import {getFirestore} from "firebase-admin/firestore";
import {EntitlementDoc, VerifiedSubscription} from "../types";
import {
  linkAccount,
  linkedUids,
  readLinkedAccounts,
  shouldApplyEntitlement,
} from "./subscriptionLinks";

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

function toEntitlementDoc(
  source: PurchaseSource,
  verified: VerifiedSubscription,
  now: number
): EntitlementDoc {
  return {
    isPremium: verified.valid,
    productId: verified.productId,
    expiresAt: verified.expiresAt ? Date.parse(verified.expiresAt) : null,
    source,
    originalTransactionId: verified.originalTransactionId,
    environment: verified.environment,
    autoRenewing: verified.autoRenewing,
    updatedAt: now,
  };
}

/**
 * Records a verified subscription as the user's entitlement — unless the user
 * has Premium from a different subscription that's still active (see
 * `shouldApplyEntitlement`). Returns the entitlement now in effect.
 */
export async function applyEntitlement(
  uid: string,
  source: PurchaseSource,
  verified: VerifiedSubscription
): Promise<{doc: EntitlementDoc; applied: boolean}> {
  const ref = entitlementRef(uid);
  return getFirestore().runTransaction(async (tx) => {
    const now = Date.now();
    const snap = await tx.get(ref);
    const existing = snap.exists ? (snap.data() as EntitlementDoc) : undefined;
    if (existing && !shouldApplyEntitlement(existing, verified, now)) {
      return {doc: existing, applied: false};
    }
    const doc = toEntitlementDoc(source, verified, now);
    tx.set(ref, doc);
    return {doc, applied: true};
  });
}

/** Applies a re-verified subscription to every account linked to it. */
export async function applyToLinkedAccounts(
  uids: string[],
  source: PurchaseSource,
  verified: VerifiedSubscription
): Promise<void> {
  for (const uid of uids) {
    await applyEntitlement(uid, source, verified);
  }
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
 * Links a subscription to the account that verified it, so a renewal
 * notification — which carries a transaction, not a uid — reaches every
 * account using it. Up to `MAX_LINKED_ACCOUNTS` stay linked; returns the uids
 * dropped to make room, whose Premium from this subscription the caller
 * should revoke.
 *
 * The Apple receipt is stored alongside because Apple's notifications are only
 * a trigger: we re-verify from the receipt rather than trusting the payload.
 */
export async function linkSubscription(params: {
  uid: string;
  source: PurchaseSource;
  id: string;
  receipt?: string;
}): Promise<string[]> {
  const {uid, source, id, receipt} = params;
  const ref = indexRef(source, id);
  return getFirestore().runTransaction(async (tx) => {
    const snap = await tx.get(ref);
    const existing = snap.data();
    const now = Date.now();
    const {accounts, dropped} =
      linkAccount(readLinkedAccounts(existing), uid, now);
    const storedReceipt =
      receipt ?? (existing?.receipt as string | undefined);

    // A full set() also drops the single `uid` field older documents used.
    tx.set(ref, {
      source,
      accounts,
      ...(storedReceipt ? {receipt: storedReceipt} : {}),
      updatedAt: now,
    });
    return dropped;
  });
}

/**
 * Takes away Premium an account got from this particular subscription (after
 * it was unlinked). Premium from any other purchase is left alone. Returns
 * whether anything was revoked.
 */
export async function revokeIfFromSubscription(
  uid: string,
  source: PurchaseSource,
  id: string
): Promise<boolean> {
  const ref = entitlementRef(uid);
  return getFirestore().runTransaction(async (tx) => {
    const snap = await tx.get(ref);
    const data = snap.data() as EntitlementDoc | undefined;
    if (
      !data ||
      !data.isPremium ||
      data.source !== source ||
      data.originalTransactionId !== id
    ) {
      return false;
    }
    tx.update(ref, {isPremium: false, updatedAt: Date.now()});
    return true;
  });
}

/**
 * Looks up the accounts (most recently linked first) and stored receipt
 * behind a store notification.
 */
export async function lookupSubscription(
  source: PurchaseSource,
  id: string
): Promise<{uids: string[]; receipt?: string} | null> {
  const snap = await indexRef(source, id).get();
  if (!snap.exists) return null;

  const data = snap.data() as {receipt?: string};
  const uids = linkedUids(readLinkedAccounts(data));
  if (uids.length === 0) return null;

  return {uids, receipt: data.receipt};
}
