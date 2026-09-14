import {EntitlementDoc, VerifiedSubscription} from "../types";

/**
 * How many Pure Pantry accounts one store subscription can grant Premium to.
 *
 * Purchases don't require sign-in, so every device is its own anonymous
 * account: someone with an iPhone and an iPad, or a household sharing one
 * Apple ID, restores the same subscription on several accounts. Apple Family
 * Sharing is unaffected — each family member gets their own transaction, so
 * their own index entry. The cap stops a receipt being spread any wider.
 */
export const MAX_LINKED_ACCOUNTS = 5;

/** uid → epoch ms when that account last verified the subscription. */
export type LinkedAccounts = Record<string, number>;

/**
 * Reads the linked accounts from a `subscriptionIndex` document. Documents
 * written before multi-account linking hold a single `uid`; it counts as
 * linked at the document's `updatedAt`.
 */
export function readLinkedAccounts(data: unknown): LinkedAccounts {
  const accounts: LinkedAccounts = {};
  if (!data || typeof data !== "object") return accounts;
  const doc = data as {accounts?: unknown; uid?: unknown; updatedAt?: unknown};

  if (doc.accounts && typeof doc.accounts === "object") {
    for (const [uid, linkedAt] of Object.entries(doc.accounts)) {
      if (typeof linkedAt === "number") accounts[uid] = linkedAt;
    }
  }
  if (typeof doc.uid === "string" && !(doc.uid in accounts)) {
    accounts[doc.uid] = typeof doc.updatedAt === "number" ? doc.updatedAt : 0;
  }
  return accounts;
}

/**
 * Links [uid] (or refreshes its link time) and, if that takes the
 * subscription past [max] accounts, drops the least recently linked others.
 */
export function linkAccount(
  accounts: LinkedAccounts,
  uid: string,
  now: number,
  max: number = MAX_LINKED_ACCOUNTS
): {accounts: LinkedAccounts; dropped: string[]} {
  const next: LinkedAccounts = {...accounts, [uid]: now};
  const dropped: string[] = [];

  const others = Object.keys(next)
    .filter((other) => other !== uid)
    .sort((a, b) => next[a] - next[b] || a.localeCompare(b));
  while (Object.keys(next).length > max && others.length > 0) {
    const oldest = others.shift()!;
    delete next[oldest];
    dropped.push(oldest);
  }
  return {accounts: next, dropped};
}

/** Linked uids, most recently linked first. */
export function linkedUids(accounts: LinkedAccounts): string[] {
  return Object.keys(accounts).sort(
    (a, b) => accounts[b] - accounts[a] || a.localeCompare(b)
  );
}

/** Whether an entitlement grants Premium at [now]. */
export function isEntitlementActive(
  doc: EntitlementDoc | undefined,
  now: number
): boolean {
  if (!doc || !doc.isPremium) return false;
  return doc.expiresAt == null || doc.expiresAt > now;
}

/**
 * Whether a freshly verified subscription should replace an account's
 * entitlement.
 *
 * An account can be linked to more than one subscription (its own purchase
 * plus a shared one, or an old lapsed one that Restore re-delivers). News
 * about one subscription must never take away Premium granted by another
 * that's still active.
 */
export function shouldApplyEntitlement(
  existing: EntitlementDoc | undefined,
  verified: VerifiedSubscription,
  now: number
): boolean {
  if (!existing) return true;
  if (existing.originalTransactionId === verified.originalTransactionId) {
    return true;
  }
  return !isEntitlementActive(existing, now) && verified.valid;
}
