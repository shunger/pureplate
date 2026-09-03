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
}

const FREE_PLAN_LIMIT = 2;
const FREE_CHAT_LIMIT = 10;
const WEEK_MS = 7 * 24 * 60 * 60 * 1000;
const TRIAL_MS = 14 * 24 * 60 * 60 * 1000;

/**
 * Checks and increments weekly usage quota for the given user.
 * Premium subscribers and users within the 14-day free trial bypass limits.
 * Resets automatically each week.
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
      };
      tx.set(docRef, data);
    }

    // Backfill for users who predate the trial.
    if (!data.firstUsedAt) {
      data.firstUsedAt = now;
      tx.set(docRef, {firstUsedAt: now}, {merge: true});
    }

    const limit = feature === "plan" ? FREE_PLAN_LIMIT : FREE_CHAT_LIMIT;
    const field = feature === "plan" ? "planCount" : "chatCount";
    const used = feature === "plan" ? data.planCount : data.chatCount;

    const trialEndsAt = data.firstUsedAt + TRIAL_MS;
    const inTrial = now < trialEndsAt;
    const unlimited = premium || inTrial;

    if (!unlimited && used >= limit) {
      throw new HttpsError(
        "resource-exhausted",
        `You've reached your weekly limit of ${limit} ${
          feature === "plan" ? "meal plans" : "chat messages"
        }. Upgrade to Premium for unlimited access.`
      );
    }

    // Counted for everyone, including premium, so the client can always show
    // usage — only the limit check above is skipped.
    tx.set(docRef, {[field]: FieldValue.increment(1)}, {merge: true});

    return {
      unlimited,
      used: used + 1,
      limit,
      remaining: unlimited ? -1 : Math.max(0, limit - (used + 1)),
      resetAt: data.weekStart + WEEK_MS,
      trialEndsAt: premium ? null : trialEndsAt,
    };
  });
}
