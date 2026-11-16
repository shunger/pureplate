import {HttpsError} from "firebase-functions/v2/https";
import {getFirestore, FieldValue} from "firebase-admin/firestore";
import {isEntitled} from "../services/entitlementService";
import {QuotaStatus} from "../types";

/**
 * Weekly usage counters. Note there is deliberately no `isPremium` field here
 * any more — entitlement lives in users/{uid}/entitlement/current, which only
 * Cloud Functions can write. Older quota docs may still carry a self-granted
 * `isPremium: true` from when this collection was client-writable; it is
 * ignored.
 */
interface QuotaDoc {
  planCount: number;
  chatCount: number;
  weekStart: number;
  firstUsedAt?: number;
  /**
   * Cumulative counts that survive the weekly reset. The weekly fields above
   * are zeroed every seven days, so they cannot answer "how much has this
   * account ever used". These can. Absent on documents written before this
   * field existed; treat undefined as 0 rather than backfilling.
   */
  lifetimePlanCount?: number;
  lifetimeChatCount?: number;
}

const WEEK_MS = 7 * 24 * 60 * 60 * 1000;
const TRIAL_MS = 14 * 24 * 60 * 60 * 1000;

/**
 * Checks access and counts usage for the given user. AI plans and chat are
 * free and unlimited for 14 days from the first use, then Premium only:
 * there is no free weekly allowance. Usage is still counted weekly (and in
 * total) for everyone, so the client can show it.
 *
 * @param uid - Firebase Auth UID
 * @param feature - "plan" or "chat"
 * @returns the usage after this call, for the client to display
 */
export async function checkRateLimit(
  uid: string,
  feature: "plan" | "chat"
): Promise<QuotaStatus> {
  const db = getFirestore();
  const docRef = db.doc(`users/${uid}/quota/weekly`);
  const now = Date.now();

  // Read entitlement before opening the transaction: it is a separate document
  // with its own writer, and Firestore requires transactional reads up front.
  const premium = await isEntitled(uid);

  return db.runTransaction(async (tx) => {
    const snap = await tx.get(docRef);
    let data = snap.data() as QuotaDoc | undefined;

    // No doc, or the week has elapsed — start a fresh window, preserving when
    // the user first used AI so the trial cannot be restarted by waiting.
    if (!data || now - data.weekStart >= WEEK_MS) {
      data = {
        planCount: 0,
        chatCount: 0,
        weekStart: now,
        firstUsedAt: data?.firstUsedAt ?? now,
        // Carried forward explicitly: this set() replaces the whole document,
        // so anything omitted here is destroyed at the week boundary.
        lifetimePlanCount: data?.lifetimePlanCount ?? 0,
        lifetimeChatCount: data?.lifetimeChatCount ?? 0,
      };
      tx.set(docRef, data);
    }

    // Backfill for users who predate the trial.
    if (!data.firstUsedAt) {
      data.firstUsedAt = now;
      tx.set(docRef, {firstUsedAt: now}, {merge: true});
    }

    const field = feature === "plan" ? "planCount" : "chatCount";
    const lifetimeField =
      feature === "plan" ? "lifetimePlanCount" : "lifetimeChatCount";
    const used = feature === "plan" ? data.planCount : data.chatCount;

    const trialEndsAt = data.firstUsedAt + TRIAL_MS;
    const inTrial = now < trialEndsAt;
    const unlimited = premium || inTrial;

    if (!unlimited) {
      throw new HttpsError(
        "resource-exhausted",
        `Your 14-day free trial has ended. Upgrade to Premium to keep using ${
          feature === "plan" ? "AI meal plans" : "AI chat"
        }.`
      );
    }

    // Counted for everyone, including premium, so the client can always show
    // usage — only the limit check above is skipped. The lifetime counter rides
    // along in the same write: no extra document, no extra cost.
    tx.set(
      docRef,
      {
        [field]: FieldValue.increment(1),
        [lifetimeField]: FieldValue.increment(1),
      },
      {merge: true}
    );

    return {
      unlimited,
      used: used + 1,
      // No free allowance outside the trial; kept for older app builds.
      limit: 0,
      remaining: -1,
      resetAt: data.weekStart + WEEK_MS,
      trialEndsAt: premium ? null : trialEndsAt,
    };
  });
}
